import 'package:drift/drift.dart';
import 'package:kendime_soz/core/errors/app_failure.dart';
import 'package:kendime_soz/core/result/result.dart';
import 'package:kendime_soz/core/time/local_date.dart';
import 'package:kendime_soz/features/focus/domain/entities/focus_session.dart';
import 'package:kendime_soz/features/habits/data/mappers/habit_mapper.dart';
import 'package:kendime_soz/features/habits/domain/entities/habit_plan.dart';
import 'package:kendime_soz/features/journey/domain/repositories/journey_repository.dart';
import 'package:kendime_soz/features/progress/domain/services/streak_calculator.dart';
import 'package:kendime_soz/features/rewards/domain/entities/reward.dart';
import 'package:kendime_soz/infrastructure/database/app_database.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  const JourneyRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Result<CompletionOutcome>> recordProgress({
    required String habitId,
    required LocalDate date,
    required int addManualValue,
    required DateTime nowUtc,
    String? note,
  }) async {
    try {
      return await _db.transaction(() async {
        // 1. Fetch Habit
        final habitRow = await (_db.select(
          _db.habitsTable,
        )..where((tbl) => tbl.id.equals(habitId))).getSingleOrNull();
        if (habitRow == null) {
          return const Failure(NotFoundFailure('Alışkanlık bulunamadı'));
        }

        // 2. Fetch Active Plan Version for this date
        final planRows =
            await (_db.select(_db.habitPlanVersionsTable)
                  ..where(
                    (tbl) =>
                        tbl.habitId.equals(habitId) &
                        tbl.effectiveFromDate.isSmallerOrEqualValue(date.key),
                  )
                  ..orderBy([(tbl) => OrderingTerm.desc(tbl.effectiveFromDate)])
                  ..limit(1))
                .get();
        final planRow = planRows.isNotEmpty ? planRows.first : null;
        final targetType = planRow != null
            ? HabitTargetType.fromString(planRow.targetType)
            : HabitTargetType.check;
        final targetValue = planRow?.targetValue ?? 1;
        final rewardEligible = planRow?.rewardEligible ?? false;

        // 3. Find or create DailyCheckIn
        final checkInQuery = _db.select(_db.dailyCheckInsTable)
          ..where(
            (tbl) =>
                tbl.habitId.equals(habitId) & tbl.localDate.equals(date.key),
          );
        final existingCheckIn = await checkInQuery.getSingleOrNull();

        final checkInId = existingCheckIn?.id ?? '${habitId}_${date.key}';
        final currentManual = existingCheckIn?.manualValue ?? 0;
        final newManual = targetType == HabitTargetType.check
            ? (addManualValue > 0 ? 1 : 0)
            : (currentManual + addManualValue);
        final sessionSeconds = existingCheckIn?.sessionSeconds ?? 0;

        bool isCompleted = false;
        switch (targetType) {
          case HabitTargetType.check:
            isCompleted = newManual >= 1;
            break;
          case HabitTargetType.count:
            isCompleted = newManual >= targetValue;
            break;
          case HabitTargetType.duration:
            isCompleted = (newManual + (sessionSeconds ~/ 60)) >= targetValue;
            break;
        }

        final wasPreviouslyCompleted = existingCheckIn?.isCompleted ?? false;
        final firstCompleted = wasPreviouslyCompleted
            ? existingCheckIn!.firstCompletedAtUtc
            : (isCompleted ? nowUtc : null);

        final planVersionId = planRow?.id ?? 'default';

        if (existingCheckIn == null) {
          await _db
              .into(_db.dailyCheckInsTable)
              .insert(
                DailyCheckInsTableCompanion.insert(
                  id: checkInId,
                  habitId: habitId,
                  localDate: date.key,
                  planVersionId: planVersionId,
                  manualValue: Value(newManual),
                  sessionSeconds: Value(sessionSeconds),
                  isCompleted: Value(isCompleted),
                  firstCompletedAtUtc: Value(firstCompleted),
                  lastCompletedAtUtc: Value(isCompleted ? nowUtc : null),
                  note: Value(note),
                ),
              );
        } else {
          await (_db.update(
            _db.dailyCheckInsTable,
          )..where((tbl) => tbl.id.equals(checkInId))).write(
            DailyCheckInsTableCompanion(
              manualValue: Value(newManual),
              isCompleted: Value(isCompleted),
              firstCompletedAtUtc: Value(firstCompleted),
              lastCompletedAtUtc: Value(
                isCompleted ? nowUtc : existingCheckIn.lastCompletedAtUtc,
              ),
              note: note != null ? Value(note) : Value(existingCheckIn.note),
            ),
          );
        }

        bool rewardEarned = false;
        String? earnedRewardTitle;
        final awardedBadges = <String>[];

        // 4. If newly completed, handle Reward Contribution and Badges
        if (isCompleted && !wasPreviouslyCompleted) {
          // A. Reward contribution
          if (rewardEligible) {
            final activeReward =
                await (_db.select(_db.rewardsTable)..where(
                      (tbl) => tbl.status.equals(RewardStatus.active.name),
                    ))
                    .getSingleOrNull();

            if (activeReward != null) {
              final isLinked =
                  (await (_db.select(_db.rewardHabitLinksTable)..where(
                        (tbl) =>
                            tbl.rewardId.equals(activeReward.id) &
                            tbl.habitId.equals(habitId),
                      ))
                      .getSingleOrNull()) !=
                  null;

              if (isLinked) {
                // Check if this checkInId already has contribution
                final existingCont =
                    await (_db.select(_db.rewardContributionsTable)
                          ..where((tbl) => tbl.checkInId.equals(checkInId)))
                        .getSingleOrNull();

                if (existingCont == null) {
                  await _db
                      .into(_db.rewardContributionsTable)
                      .insert(
                        RewardContributionsTableCompanion.insert(
                          id: 'cont_${checkInId}_${nowUtc.millisecondsSinceEpoch}',
                          rewardId: activeReward.id,
                          checkInId: Value(checkInId),
                          allocatedAtUtc: nowUtc,
                          isReversed: const Value(false),
                          reversedAfterUse: const Value(false),
                        ),
                      );
                } else if (existingCont.isReversed) {
                  await (_db.update(
                    _db.rewardContributionsTable,
                  )..where((tbl) => tbl.id.equals(existingCont.id))).write(
                    const RewardContributionsTableCompanion(
                      isReversed: Value(false),
                    ),
                  );
                }

                // Check total active contributions
                final totalConts =
                    await (_db.select(_db.rewardContributionsTable)..where(
                          (tbl) =>
                              tbl.rewardId.equals(activeReward.id) &
                              tbl.isReversed.equals(false),
                        ))
                        .get();

                if (totalConts.length >= activeReward.targetSteps) {
                  await (_db.update(
                    _db.rewardsTable,
                  )..where((tbl) => tbl.id.equals(activeReward.id))).write(
                    RewardsTableCompanion(
                      status: Value(RewardStatus.earned.name),
                      earnedAtUtc: Value(nowUtc),
                    ),
                  );
                  rewardEarned = true;
                  earnedRewardTitle = activeReward.title;

                  // First ticket badge
                  final existingBadge =
                      await (_db.select(_db.badgesTable)
                            ..where((tbl) => tbl.code.equals('first_ticket')))
                          .getSingleOrNull();
                  if (existingBadge == null) {
                    await _db
                        .into(_db.badgesTable)
                        .insert(
                          BadgesTableCompanion.insert(
                            code: 'first_ticket',
                            earnedAtUtc: nowUtc,
                            evidenceId: Value(activeReward.id),
                          ),
                        );
                    awardedBadges.add('İlk Bilet 🎟️');
                  }
                }
              }
            }
          }

          // B. First step badge
          final totalCompletedEver = await (_db.select(
            _db.dailyCheckInsTable,
          )..where((tbl) => tbl.isCompleted.equals(true))).get();
          if (totalCompletedEver.length == 1) {
            final b = await (_db.select(
              _db.badgesTable,
            )..where((tbl) => tbl.code.equals('first_step'))).getSingleOrNull();
            if (b == null) {
              await _db
                  .into(_db.badgesTable)
                  .insert(
                    BadgesTableCompanion.insert(
                      code: 'first_step',
                      earnedAtUtc: nowUtc,
                    ),
                  );
              awardedBadges.add('İlk Adım 🌱');
            }
          }

          // C. Streak check
          final allCheckInsForHabit =
              await (_db.select(_db.dailyCheckInsTable)..where(
                    (tbl) =>
                        tbl.habitId.equals(habitId) &
                        tbl.isCompleted.equals(true),
                  ))
                  .get();
          final completedDateSet = allCheckInsForHabit
              .map((c) => LocalDate.parse(c.localDate))
              .toSet();

          // Collect planned dates
          final plannedDates = <LocalDate>[];
          if (planRow != null) {
            final weekdays = planRow.weekdays
                .split(',')
                .where((s) => s.trim().isNotEmpty)
                .map(int.parse)
                .toSet();
            final startDate = LocalDate.parse(
              habitRow.createdAtUtc.toIso8601String().substring(0, 10),
            );
            var cursor = startDate;
            while (!cursor.isAfter(date)) {
              if (weekdays.contains(cursor.weekday)) {
                plannedDates.add(cursor);
              }
              cursor = cursor.addDays(1);
            }
          }

          final streak = StreakCalculator.calculate(
            plannedDays: plannedDates,
            completedDays: completedDateSet,
            today: date,
          );

          if (streak.currentStreak >= 7) {
            final b =
                await (_db.select(_db.badgesTable)
                      ..where((tbl) => tbl.code.equals('in_the_rhythm')))
                    .getSingleOrNull();
            if (b == null) {
              await _db
                  .into(_db.badgesTable)
                  .insert(
                    BadgesTableCompanion.insert(
                      code: 'in_the_rhythm',
                      earnedAtUtc: nowUtc,
                    ),
                  );
              awardedBadges.add('Ritim Buldum 🔥');
            }
          }
        }

        final updatedCheckIn = await (_db.select(
          _db.dailyCheckInsTable,
        )..where((tbl) => tbl.id.equals(checkInId))).getSingle();

        return Success(
          CompletionOutcome(
            checkIn: HabitMapper.toCheckInEntity(updatedCheckIn),
            rewardEarned: rewardEarned,
            rewardTitle: earnedRewardTitle,
            awardedBadges: awardedBadges,
          ),
        );
      });
    } catch (e) {
      return Failure(StorageFailure('İlerleme kaydedilemedi', e));
    }
  }

  @override
  Future<Result<CompletionOutcome>> revertProgress({
    required String habitId,
    required LocalDate date,
    required DateTime nowUtc,
  }) async {
    try {
      return await _db.transaction(() async {
        final checkInQuery = _db.select(_db.dailyCheckInsTable)
          ..where(
            (tbl) =>
                tbl.habitId.equals(habitId) & tbl.localDate.equals(date.key),
          );
        final checkInRow = await checkInQuery.getSingleOrNull();
        if (checkInRow == null) {
          return const Failure(NotFoundFailure('Kayıt bulunamadı'));
        }

        // Revert completion
        await (_db.update(
          _db.dailyCheckInsTable,
        )..where((tbl) => tbl.id.equals(checkInRow.id))).write(
          const DailyCheckInsTableCompanion(
            isCompleted: Value(false),
            manualValue: Value(0),
          ),
        );

        String? warning;

        // Check contribution reversal
        final cont =
            await (_db.select(_db.rewardContributionsTable)
                  ..where((tbl) => tbl.checkInId.equals(checkInRow.id)))
                .getSingleOrNull();

        if (cont != null && !cont.isReversed) {
          final reward = await (_db.select(
            _db.rewardsTable,
          )..where((tbl) => tbl.id.equals(cont.rewardId))).getSingleOrNull();

          if (reward != null) {
            if (reward.status == RewardStatus.earned.name ||
                reward.status == RewardStatus.planned.name) {
              // Bilet tekrar active olur, plan temizlenir
              await (_db.update(
                _db.rewardsTable,
              )..where((tbl) => tbl.id.equals(reward.id))).write(
                const RewardsTableCompanion(
                  status: Value('active'),
                  planAtUtc: Value(null),
                  planTimezone: Value(null),
                  placeName: Value(null),
                  planNote: Value(null),
                ),
              );
              warning = 'Kazanılmış bilet tekrar aktif duruma getirildi.';
            } else if (reward.status == RewardStatus.used.name) {
              await (_db.update(
                _db.rewardContributionsTable,
              )..where((tbl) => tbl.id.equals(cont.id))).write(
                const RewardContributionsTableCompanion(
                  reversedAfterUse: Value(true),
                ),
              );
              warning = 'Kullanılmış bilette geçmiş kayıt düzeltildi.';
            }

            await (_db.update(
              _db.rewardContributionsTable,
            )..where((tbl) => tbl.id.equals(cont.id))).write(
              const RewardContributionsTableCompanion(isReversed: Value(true)),
            );
          }
        }

        final updatedCheckIn = await (_db.select(
          _db.dailyCheckInsTable,
        )..where((tbl) => tbl.id.equals(checkInRow.id))).getSingle();

        return Success(
          CompletionOutcome(
            checkIn: HabitMapper.toCheckInEntity(updatedCheckIn),
            warningMessage: warning,
          ),
        );
      });
    } catch (e) {
      return Failure(StorageFailure('İlerleme geri alınamadı', e));
    }
  }

  @override
  Future<Result<CompletionOutcome>> finalizeFocusSession({
    required String sessionId,
    required DateTime nowUtc,
  }) async {
    try {
      return await _db.transaction(() async {
        final sessionQuery = _db.select(_db.focusSessionsTable)
          ..where((tbl) => tbl.id.equals(sessionId));
        final sessionRow = await sessionQuery.getSingleOrNull();
        if (sessionRow == null) {
          return const Failure(NotFoundFailure('Oturum bulunamadı'));
        }

        int totalSeconds = sessionRow.accumulatedSeconds;
        if (sessionRow.activeSegmentStartedAtUtc != null) {
          final add = nowUtc
              .difference(sessionRow.activeSegmentStartedAtUtc!)
              .inSeconds;
          if (add > 0) totalSeconds += add;
        }

        // If less than 1 minute, cancel session
        if (totalSeconds < 60) {
          await (_db.update(
            _db.focusSessionsTable,
          )..where((tbl) => tbl.id.equals(sessionId))).write(
            FocusSessionsTableCompanion(
              status: Value(FocusSessionStatus.canceled.name),
              endedAtUtc: Value(nowUtc),
              activeSegmentStartedAtUtc: const Value(null),
            ),
          );
          return const Failure(
            ValidationFailure('1 dakikadan kısa odaklanma kaydedilmedi.'),
          );
        }

        // Complete session
        await (_db.update(
          _db.focusSessionsTable,
        )..where((tbl) => tbl.id.equals(sessionId))).write(
          FocusSessionsTableCompanion(
            status: Value(FocusSessionStatus.completed.name),
            accumulatedSeconds: Value(totalSeconds),
            endedAtUtc: Value(nowUtc),
            activeSegmentStartedAtUtc: const Value(null),
          ),
        );

        // Date allocation
        final today = LocalDate.fromDateTime(nowUtc);
        await _db
            .into(_db.focusAllocationsTable)
            .insertOnConflictUpdate(
              FocusAllocationsTableCompanion.insert(
                sessionId: sessionId,
                localDate: today.key,
                activeSeconds: totalSeconds,
              ),
            );

        // Update daily check in
        final checkInQuery = _db.select(_db.dailyCheckInsTable)
          ..where(
            (tbl) =>
                tbl.habitId.equals(sessionRow.habitId) &
                tbl.localDate.equals(today.key),
          );
        final checkInRow = await checkInQuery.getSingleOrNull();

        final checkInId =
            checkInRow?.id ?? '${sessionRow.habitId}_${today.key}';
        final newSessionSeconds =
            (checkInRow?.sessionSeconds ?? 0) + totalSeconds;
        final manualVal = checkInRow?.manualValue ?? 0;

        // Fetch plan
        final planRows =
            await (_db.select(_db.habitPlanVersionsTable)
                  ..where(
                    (tbl) =>
                        tbl.habitId.equals(sessionRow.habitId) &
                        tbl.effectiveFromDate.isSmallerOrEqualValue(today.key),
                  )
                  ..orderBy([(tbl) => OrderingTerm.desc(tbl.effectiveFromDate)])
                  ..limit(1))
                .get();
        final planRow = planRows.isNotEmpty ? planRows.first : null;
        final targetVal = planRow?.targetValue ?? 25;
        final isCompleted =
            (manualVal + (newSessionSeconds ~/ 60)) >= targetVal;

        if (checkInRow == null) {
          await _db
              .into(_db.dailyCheckInsTable)
              .insert(
                DailyCheckInsTableCompanion.insert(
                  id: checkInId,
                  habitId: sessionRow.habitId,
                  localDate: today.key,
                  planVersionId: planRow?.id ?? 'default',
                  manualValue: Value(manualVal),
                  sessionSeconds: Value(newSessionSeconds),
                  isCompleted: Value(isCompleted),
                  firstCompletedAtUtc: Value(isCompleted ? nowUtc : null),
                  lastCompletedAtUtc: Value(isCompleted ? nowUtc : null),
                ),
              );
        } else {
          await (_db.update(
            _db.dailyCheckInsTable,
          )..where((tbl) => tbl.id.equals(checkInId))).write(
            DailyCheckInsTableCompanion(
              sessionSeconds: Value(newSessionSeconds),
              isCompleted: Value(isCompleted),
              firstCompletedAtUtc: Value(
                checkInRow.firstCompletedAtUtc ?? (isCompleted ? nowUtc : null),
              ),
              lastCompletedAtUtc: Value(
                isCompleted ? nowUtc : checkInRow.lastCompletedAtUtc,
              ),
            ),
          );
        }

        final updatedCheckIn = await (_db.select(
          _db.dailyCheckInsTable,
        )..where((tbl) => tbl.id.equals(checkInId))).getSingle();

        return Success(
          CompletionOutcome(
            checkIn: HabitMapper.toCheckInEntity(updatedCheckIn),
          ),
        );
      });
    } catch (e) {
      return Failure(StorageFailure('Odaklanma tamamlanamadı', e));
    }
  }
}
