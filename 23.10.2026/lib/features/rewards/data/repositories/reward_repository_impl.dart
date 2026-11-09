import 'package:drift/drift.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/reward.dart';
import '../../domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  const RewardRepositoryImpl(this._db);

  final AppDatabase _db;

  Future<Reward> _mapToRewardEntity(RewardsTableData row) async {
    // Calculate currentSteps from valid non-reversed contributions
    final contQuery = _db.select(_db.rewardContributionsTable)
      ..where(
        (tbl) => tbl.rewardId.equals(row.id) & tbl.isReversed.equals(false),
      );
    final contributions = await contQuery.get();

    // Fetch linked habit IDs
    final linksQuery = _db.select(_db.rewardHabitLinksTable)
      ..where((tbl) => tbl.rewardId.equals(row.id));
    final links = await linksQuery.get();

    return Reward(
      id: row.id,
      title: row.title,
      emoji: row.emoji,
      description: row.description,
      targetSteps: row.targetSteps,
      status: RewardStatus.fromString(row.status),
      activatedAtUtc: row.activatedAtUtc,
      earnedAtUtc: row.earnedAtUtc,
      usedAtUtc: row.usedAtUtc,
      planAtUtc: row.planAtUtc,
      planTimezone: row.planTimezone,
      placeName: row.placeName,
      planNote: row.planNote,
      currentSteps: contributions.length,
      linkedHabitIds: links.map((l) => l.habitId).toList(),
    );
  }

  @override
  Stream<List<Reward>> watchRewards() {
    return _db.select(_db.rewardsTable).watch().asyncMap((rows) async {
      final list = <Reward>[];
      for (final r in rows) {
        list.add(await _mapToRewardEntity(r));
      }
      return list;
    });
  }

  @override
  Future<Result<List<Reward>>> getRewards() async {
    try {
      final rows = await _db.select(_db.rewardsTable).get();
      final list = <Reward>[];
      for (final r in rows) {
        list.add(await _mapToRewardEntity(r));
      }
      return Success(list);
    } catch (e) {
      return Failure(StorageFailure('Ödüller getirilemedi', e));
    }
  }

  @override
  Future<Result<Reward?>> getActiveReward() async {
    try {
      final query = _db.select(_db.rewardsTable)
        ..where((tbl) => tbl.status.equals(RewardStatus.active.name));
      final row = await query.getSingleOrNull();
      if (row == null) return const Success(null);
      return Success(await _mapToRewardEntity(row));
    } catch (e) {
      return Failure(StorageFailure('Aktif ödül getirilemedi', e));
    }
  }

  @override
  Future<Result<Reward>> getRewardById(String id) async {
    try {
      final query = _db.select(_db.rewardsTable)
        ..where((tbl) => tbl.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) {
        return const Failure(NotFoundFailure('Ödül bulunamadı'));
      }
      return Success(await _mapToRewardEntity(row));
    } catch (e) {
      return Failure(StorageFailure('Ödül getirilemedi', e));
    }
  }

  @override
  Future<Result<Reward>> createReward({
    required Reward reward,
    required List<String> habitIds,
  }) async {
    try {
      return await _db.transaction(() async {
        await _db
            .into(_db.rewardsTable)
            .insert(
              RewardsTableCompanion.insert(
                id: reward.id,
                title: reward.title,
                emoji: reward.emoji,
                description: reward.description,
                targetSteps: reward.targetSteps,
                status: reward.status.name,
                activatedAtUtc: Value(reward.activatedAtUtc),
                earnedAtUtc: Value(reward.earnedAtUtc),
                usedAtUtc: Value(reward.usedAtUtc),
                planAtUtc: Value(reward.planAtUtc),
                planTimezone: Value(reward.planTimezone),
                placeName: Value(reward.placeName),
                planNote: Value(reward.planNote),
              ),
            );

        for (final hid in habitIds) {
          await _db
              .into(_db.rewardHabitLinksTable)
              .insert(
                RewardHabitLinksTableCompanion.insert(
                  rewardId: reward.id,
                  habitId: hid,
                ),
              );
        }

        return Success(reward.copyWith(linkedHabitIds: habitIds));
      });
    } catch (e) {
      return Failure(StorageFailure('Ödül oluşturulamadı', e));
    }
  }

  @override
  Future<Result<Reward>> activateReward({
    required String rewardId,
    required DateTime activatedAtUtc,
  }) async {
    try {
      return await _db.transaction(() async {
        // Enforce single active reward rule
        final activeQuery = _db.select(_db.rewardsTable)
          ..where((tbl) => tbl.status.equals(RewardStatus.active.name));
        final existingActive = await activeQuery.getSingleOrNull();
        if (existingActive != null && existingActive.id != rewardId) {
          return const Failure(
            ConflictFailure(
              'Zaten aktif bir ödülün var. Yeni ödül başlatmak için önce onu tamamla veya iptal et.',
            ),
          );
        }

        // Verify has at least one linked habit
        final links = await (_db.select(
          _db.rewardHabitLinksTable,
        )..where((tbl) => tbl.rewardId.equals(rewardId))).get();
        if (links.isEmpty) {
          return const Failure(
            ValidationFailure(
              'Ödülü etkinleştirmek için en az bir alışkanlık bağlamalısın.',
            ),
          );
        }

        await (_db.update(
          _db.rewardsTable,
        )..where((tbl) => tbl.id.equals(rewardId))).write(
          RewardsTableCompanion(
            status: Value(RewardStatus.active.name),
            activatedAtUtc: Value(activatedAtUtc),
          ),
        );

        final updatedRow = await (_db.select(
          _db.rewardsTable,
        )..where((tbl) => tbl.id.equals(rewardId))).getSingle();
        return Success(await _mapToRewardEntity(updatedRow));
      });
    } catch (e) {
      return Failure(StorageFailure('Ödül etkinleştirilemedi', e));
    }
  }

  @override
  Future<Result<void>> cancelReward(String rewardId) async {
    try {
      await (_db.update(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).write(
        RewardsTableCompanion(status: Value(RewardStatus.canceled.name)),
      );
      return const Success(null);
    } catch (e) {
      return Failure(StorageFailure('Ödül iptal edilemedi', e));
    }
  }

  @override
  Future<Result<Reward>> planReward({
    required String rewardId,
    required DateTime planAtUtc,
    required String planTimezone,
    String? placeName,
    String? planNote,
  }) async {
    try {
      await (_db.update(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).write(
        RewardsTableCompanion(
          status: Value(RewardStatus.planned.name),
          planAtUtc: Value(planAtUtc),
          planTimezone: Value(planTimezone),
          placeName: Value(placeName),
          planNote: Value(planNote),
        ),
      );
      final updatedRow = await (_db.select(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).getSingle();
      return Success(await _mapToRewardEntity(updatedRow));
    } catch (e) {
      return Failure(StorageFailure('Ödül planı kaydedilemedi', e));
    }
  }

  @override
  Future<Result<Reward>> removeRewardPlan(String rewardId) async {
    try {
      await (_db.update(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).write(
        const RewardsTableCompanion(
          status: Value('earned'),
          planAtUtc: Value(null),
          planTimezone: Value(null),
          placeName: Value(null),
          planNote: Value(null),
        ),
      );
      final updatedRow = await (_db.select(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).getSingle();
      return Success(await _mapToRewardEntity(updatedRow));
    } catch (e) {
      return Failure(StorageFailure('Plan kaldırılamadı', e));
    }
  }

  @override
  Future<Result<Reward>> markRewardUsed({
    required String rewardId,
    required DateTime usedAtUtc,
  }) async {
    try {
      await (_db.update(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).write(
        RewardsTableCompanion(
          status: Value(RewardStatus.used.name),
          usedAtUtc: Value(usedAtUtc),
        ),
      );
      final updatedRow = await (_db.select(
        _db.rewardsTable,
      )..where((tbl) => tbl.id.equals(rewardId))).getSingle();
      return Success(await _mapToRewardEntity(updatedRow));
    } catch (e) {
      return Failure(StorageFailure('Ödül kullanımı kaydedilemedi', e));
    }
  }
}
