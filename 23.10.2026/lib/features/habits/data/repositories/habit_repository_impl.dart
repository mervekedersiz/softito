import 'package:drift/drift.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/time/local_date.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/daily_check_in.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_plan.dart';
import '../../domain/repositories/habit_repository.dart';
import '../mappers/habit_mapper.dart';

class HabitRepositoryImpl implements HabitRepository {
  const HabitRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Habit>> watchHabits({
    HabitCategory? category,
    bool includeArchived = false,
  }) {
    final query = _db.select(_db.habitsTable);
    if (category != null) {
      query.where((tbl) => tbl.category.equals(category.name));
    }
    if (!includeArchived) {
      query.where((tbl) => tbl.archivedAtUtc.isNull());
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.createdAtUtc)]);

    return query.watch().asyncMap((habitRows) async {
      final results = <Habit>[];
      for (final row in habitRows) {
        // Fetch latest plan version
        final planQuery = _db.select(_db.habitPlanVersionsTable)
          ..where((tbl) => tbl.habitId.equals(row.id))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.effectiveFromDate)])
          ..limit(1);
        final planRow = await planQuery.getSingleOrNull();
        results.add(HabitMapper.toHabitEntity(row, planData: planRow));
      }
      return results;
    });
  }

  @override
  Future<Result<List<Habit>>> getHabits({
    HabitCategory? category,
    bool includeArchived = false,
  }) async {
    try {
      final query = _db.select(_db.habitsTable);
      if (category != null) {
        query.where((tbl) => tbl.category.equals(category.name));
      }
      if (!includeArchived) {
        query.where((tbl) => tbl.archivedAtUtc.isNull());
      }
      query.orderBy([(tbl) => OrderingTerm.desc(tbl.createdAtUtc)]);
      final habitRows = await query.get();

      final results = <Habit>[];
      for (final row in habitRows) {
        final planQuery = _db.select(_db.habitPlanVersionsTable)
          ..where((tbl) => tbl.habitId.equals(row.id))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.effectiveFromDate)])
          ..limit(1);
        final planRow = await planQuery.getSingleOrNull();
        results.add(HabitMapper.toHabitEntity(row, planData: planRow));
      }
      return Success(results);
    } catch (e) {
      return Failure(StorageFailure('Alışkanlıklar getirilemedi', e));
    }
  }

  @override
  Future<Result<Habit>> getHabitById(String id) async {
    try {
      final query = _db.select(_db.habitsTable)
        ..where((tbl) => tbl.id.equals(id));
      final habitRow = await query.getSingleOrNull();
      if (habitRow == null) {
        return const Failure(NotFoundFailure('Alışkanlık bulunamadı'));
      }

      final planQuery = _db.select(_db.habitPlanVersionsTable)
        ..where((tbl) => tbl.habitId.equals(id))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.effectiveFromDate)])
        ..limit(1);
      final planRow = await planQuery.getSingleOrNull();

      return Success(HabitMapper.toHabitEntity(habitRow, planData: planRow));
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık detayı getirilemedi', e));
    }
  }

  @override
  Future<Result<Habit>> createHabit({
    required Habit habit,
    required HabitPlan plan,
  }) async {
    try {
      return await _db.transaction(() async {
        await _db
            .into(_db.habitsTable)
            .insert(
              HabitsTableCompanion.insert(
                id: habit.id,
                title: habit.title,
                emoji: habit.emoji,
                category: habit.category.name,
                subcategory: habit.subcategory,
                createdAtUtc: habit.createdAtUtc,
                archivedAtUtc: Value(habit.archivedAtUtc),
              ),
            );

        await _db
            .into(_db.habitPlanVersionsTable)
            .insert(
              HabitPlanVersionsTableCompanion.insert(
                id: plan.id,
                habitId: habit.id,
                effectiveFromDate: plan.effectiveFromDate.key,
                weekdays: plan.weekdays.join(','),
                targetType: plan.targetType.name,
                targetValue: plan.targetValue,
                unit: plan.unit,
                rewardEligible: Value(plan.rewardEligible),
              ),
            );

        return Success(habit.copyWith(currentPlan: () => plan));
      });
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık oluşturulamadı', e));
    }
  }

  @override
  Future<Result<Habit>> updateHabit({
    required Habit habit,
    HabitPlan? newPlan,
  }) async {
    try {
      return await _db.transaction(() async {
        await (_db.update(
          _db.habitsTable,
        )..where((tbl) => tbl.id.equals(habit.id))).write(
          HabitsTableCompanion(
            title: Value(habit.title),
            emoji: Value(habit.emoji),
            category: Value(habit.category.name),
            subcategory: Value(habit.subcategory),
            archivedAtUtc: Value(habit.archivedAtUtc),
          ),
        );

        if (newPlan != null) {
          await _db
              .into(_db.habitPlanVersionsTable)
              .insert(
                HabitPlanVersionsTableCompanion.insert(
                  id: newPlan.id,
                  habitId: habit.id,
                  effectiveFromDate: newPlan.effectiveFromDate.key,
                  weekdays: newPlan.weekdays.join(','),
                  targetType: newPlan.targetType.name,
                  targetValue: newPlan.targetValue,
                  unit: newPlan.unit,
                  rewardEligible: Value(newPlan.rewardEligible),
                ),
              );
        }

        return Success(
          habit.copyWith(currentPlan: newPlan != null ? () => newPlan : null),
        );
      });
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık güncellenemedi', e));
    }
  }

  @override
  Future<Result<void>> archiveHabit(String id, DateTime archivedAtUtc) async {
    try {
      await (_db.update(_db.habitsTable)..where((tbl) => tbl.id.equals(id)))
          .write(HabitsTableCompanion(archivedAtUtc: Value(archivedAtUtc)));
      return const Success(null);
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık arşivlenemedi', e));
    }
  }

  @override
  Future<Result<void>> unarchiveHabit(String id) async {
    try {
      await (_db.update(_db.habitsTable)..where((tbl) => tbl.id.equals(id)))
          .write(const HabitsTableCompanion(archivedAtUtc: Value(null)));
      return const Success(null);
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık arşivden çıkarılamadı', e));
    }
  }

  @override
  Future<Result<void>> deleteHabitPermanently(String id) async {
    try {
      return await _db.transaction(() async {
        await (_db.delete(
          _db.habitsTable,
        )..where((tbl) => tbl.id.equals(id))).go();
        return const Success(null);
      });
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık silinemedi', e));
    }
  }

  @override
  Stream<DailyCheckIn?> watchCheckIn(String habitId, LocalDate date) {
    final query = _db.select(_db.dailyCheckInsTable)
      ..where(
        (tbl) => tbl.habitId.equals(habitId) & tbl.localDate.equals(date.key),
      );
    return query.watchSingleOrNull().map(
      (row) => row != null ? HabitMapper.toCheckInEntity(row) : null,
    );
  }

  @override
  Future<Result<DailyCheckIn?>> getCheckIn(
    String habitId,
    LocalDate date,
  ) async {
    try {
      final query = _db.select(_db.dailyCheckInsTable)
        ..where(
          (tbl) => tbl.habitId.equals(habitId) & tbl.localDate.equals(date.key),
        );
      final row = await query.getSingleOrNull();
      return Success(row != null ? HabitMapper.toCheckInEntity(row) : null);
    } catch (e) {
      return Failure(StorageFailure('Günlük kayıt getirilemedi', e));
    }
  }

  @override
  Future<Result<List<DailyCheckIn>>> getCheckInsForHabit(String habitId) async {
    try {
      final query = _db.select(_db.dailyCheckInsTable)
        ..where((tbl) => tbl.habitId.equals(habitId))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.localDate)]);
      final rows = await query.get();
      return Success(rows.map(HabitMapper.toCheckInEntity).toList());
    } catch (e) {
      return Failure(StorageFailure('Alışkanlık geçmişi getirilemedi', e));
    }
  }

  @override
  Future<Result<List<DailyCheckIn>>> getCheckInsForDate(LocalDate date) async {
    try {
      final query = _db.select(_db.dailyCheckInsTable)
        ..where((tbl) => tbl.localDate.equals(date.key));
      final rows = await query.get();
      return Success(rows.map(HabitMapper.toCheckInEntity).toList());
    } catch (e) {
      return Failure(StorageFailure('Tarih kayıtları getirilemedi', e));
    }
  }
}
