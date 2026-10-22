import 'package:drift/drift.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/time/local_date.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/badge.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  const ProgressRepositoryImpl(this._db);

  final AppDatabase _db;

  List<AppBadge> _mergeWithCatalog(List<BadgesTableData> earnedRows) {
    final earnedMap = {for (final r in earnedRows) r.code: r};
    return AppBadge.allCatalog.map((catalogBadge) {
      final earned = earnedMap[catalogBadge.code];
      if (earned != null) {
        return catalogBadge.copyWith(
          earnedAtUtc: () => earned.earnedAtUtc,
          evidenceId: () => earned.evidenceId,
        );
      }
      return catalogBadge;
    }).toList();
  }

  @override
  Stream<List<AppBadge>> watchBadges() {
    return _db.select(_db.badgesTable).watch().map(_mergeWithCatalog);
  }

  @override
  Future<Result<List<AppBadge>>> getBadges() async {
    try {
      final earnedRows = await _db.select(_db.badgesTable).get();
      return Success(_mergeWithCatalog(earnedRows));
    } catch (e) {
      return Failure(StorageFailure('Rozetler getirilemedi', e));
    }
  }

  @override
  Future<Result<void>> awardBadge({
    required String code,
    required DateTime earnedAtUtc,
    String? evidenceId,
  }) async {
    try {
      final existing = await (_db.select(
        _db.badgesTable,
      )..where((tbl) => tbl.code.equals(code))).getSingleOrNull();
      if (existing == null) {
        await _db
            .into(_db.badgesTable)
            .insert(
              BadgesTableCompanion.insert(
                code: code,
                earnedAtUtc: earnedAtUtc,
                evidenceId: Value(evidenceId),
              ),
            );
      }
      return const Success(null);
    } catch (e) {
      return Failure(StorageFailure('Rozet kaydedilemedi', e));
    }
  }

  @override
  Stream<String?> watchReflection(LocalDate date) {
    final query = _db.select(_db.dailyReflectionsTable)
      ..where((tbl) => tbl.localDate.equals(date.key));
    return query.watchSingleOrNull().map((row) => row?.textContent);
  }

  @override
  Future<Result<String?>> getReflection(LocalDate date) async {
    try {
      final query = _db.select(_db.dailyReflectionsTable)
        ..where((tbl) => tbl.localDate.equals(date.key));
      final row = await query.getSingleOrNull();
      return Success(row?.textContent);
    } catch (e) {
      return Failure(StorageFailure('Günlük not getirilemedi', e));
    }
  }

  @override
  Future<Result<void>> saveReflection({
    required LocalDate date,
    required String text,
    required DateTime updatedAtUtc,
  }) async {
    try {
      await _db
          .into(_db.dailyReflectionsTable)
          .insertOnConflictUpdate(
            DailyReflectionsTableCompanion.insert(
              localDate: date.key,
              textContent: text,
              updatedAtUtc: updatedAtUtc,
            ),
          );
      return const Success(null);
    } catch (e) {
      return Failure(StorageFailure('Günlük not kaydedilemedi', e));
    }
  }
}
