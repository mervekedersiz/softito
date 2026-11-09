import 'package:drift/drift.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/repositories/focus_repository.dart';

class FocusRepositoryImpl implements FocusRepository {
  const FocusRepositoryImpl(this._db);

  final AppDatabase _db;

  FocusSession _mapToSessionEntity(FocusSessionsTableData row) {
    return FocusSession(
      id: row.id,
      habitId: row.habitId,
      startedAtUtc: row.startedAtUtc,
      activeSegmentStartedAtUtc: row.activeSegmentStartedAtUtc,
      accumulatedSeconds: row.accumulatedSeconds,
      plannedSeconds: row.plannedSeconds,
      status: FocusSessionStatus.fromString(row.status),
      endedAtUtc: row.endedAtUtc,
    );
  }

  @override
  Stream<FocusSession?> watchActiveSession() {
    final query = _db.select(_db.focusSessionsTable)
      ..where(
        (tbl) =>
            tbl.status.equals(FocusSessionStatus.running.name) |
            tbl.status.equals(FocusSessionStatus.paused.name),
      )
      ..limit(1);

    return query.watchSingleOrNull().map(
      (row) => row != null ? _mapToSessionEntity(row) : null,
    );
  }

  @override
  Future<Result<FocusSession?>> getActiveSession() async {
    try {
      final query = _db.select(_db.focusSessionsTable)
        ..where(
          (tbl) =>
              tbl.status.equals(FocusSessionStatus.running.name) |
              tbl.status.equals(FocusSessionStatus.paused.name),
        )
        ..limit(1);
      final row = await query.getSingleOrNull();
      return Success(row != null ? _mapToSessionEntity(row) : null);
    } catch (e) {
      return Failure(StorageFailure('Aktif odaklanma oturumu getirilemedi', e));
    }
  }

  @override
  Future<Result<FocusSession>> startSession({
    required String habitId,
    required int plannedSeconds,
    required DateTime startedAtUtc,
  }) async {
    try {
      return await _db.transaction(() async {
        // Enforce single active session
        final activeQuery = _db.select(_db.focusSessionsTable)
          ..where(
            (tbl) =>
                tbl.status.equals(FocusSessionStatus.running.name) |
                tbl.status.equals(FocusSessionStatus.paused.name),
          );
        final existing = await activeQuery.getSingleOrNull();
        if (existing != null) {
          return const Failure(
            ConflictFailure(
              'Zaten devam eden veya duraklatılmış bir odaklanma oturumunuz var.',
            ),
          );
        }

        final sessionId = startedAtUtc.millisecondsSinceEpoch.toString();
        await _db
            .into(_db.focusSessionsTable)
            .insert(
              FocusSessionsTableCompanion.insert(
                id: sessionId,
                habitId: habitId,
                startedAtUtc: startedAtUtc,
                activeSegmentStartedAtUtc: Value(startedAtUtc),
                accumulatedSeconds: const Value(0),
                plannedSeconds: plannedSeconds,
                status: FocusSessionStatus.running.name,
              ),
            );

        return Success(
          FocusSession(
            id: sessionId,
            habitId: habitId,
            startedAtUtc: startedAtUtc,
            activeSegmentStartedAtUtc: startedAtUtc,
            accumulatedSeconds: 0,
            plannedSeconds: plannedSeconds,
            status: FocusSessionStatus.running,
          ),
        );
      });
    } catch (e) {
      return Failure(StorageFailure('Oturum başlatılamadı', e));
    }
  }

  @override
  Future<Result<FocusSession>> pauseSession({
    required String sessionId,
    required DateTime pausedAtUtc,
  }) async {
    try {
      return await _db.transaction(() async {
        final query = _db.select(_db.focusSessionsTable)
          ..where((tbl) => tbl.id.equals(sessionId));
        final row = await query.getSingleOrNull();
        if (row == null) {
          return const Failure(NotFoundFailure('Oturum bulunamadı'));
        }

        int addSeconds = 0;
        if (row.activeSegmentStartedAtUtc != null) {
          final diff = pausedAtUtc
              .difference(row.activeSegmentStartedAtUtc!)
              .inSeconds;
          if (diff > 0) addSeconds = diff;
        }

        final newAccumulated = row.accumulatedSeconds + addSeconds;

        await (_db.update(
          _db.focusSessionsTable,
        )..where((tbl) => tbl.id.equals(sessionId))).write(
          FocusSessionsTableCompanion(
            status: Value(FocusSessionStatus.paused.name),
            accumulatedSeconds: Value(newAccumulated),
            activeSegmentStartedAtUtc: const Value(null),
          ),
        );

        final updated = await query.getSingle();
        return Success(_mapToSessionEntity(updated));
      });
    } catch (e) {
      return Failure(StorageFailure('Oturum duraklatılamadı', e));
    }
  }

  @override
  Future<Result<FocusSession>> resumeSession({
    required String sessionId,
    required DateTime resumedAtUtc,
  }) async {
    try {
      await (_db.update(
        _db.focusSessionsTable,
      )..where((tbl) => tbl.id.equals(sessionId))).write(
        FocusSessionsTableCompanion(
          status: Value(FocusSessionStatus.running.name),
          activeSegmentStartedAtUtc: Value(resumedAtUtc),
        ),
      );
      final query = _db.select(_db.focusSessionsTable)
        ..where((tbl) => tbl.id.equals(sessionId));
      final updated = await query.getSingle();
      return Success(_mapToSessionEntity(updated));
    } catch (e) {
      return Failure(StorageFailure('Oturum sürdürülemedi', e));
    }
  }

  @override
  Future<Result<void>> cancelSession(String sessionId) async {
    try {
      await (_db.update(
        _db.focusSessionsTable,
      )..where((tbl) => tbl.id.equals(sessionId))).write(
        FocusSessionsTableCompanion(
          status: Value(FocusSessionStatus.canceled.name),
          endedAtUtc: Value(DateTime.now().toUtc()),
          activeSegmentStartedAtUtc: const Value(null),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Failure(StorageFailure('Oturum iptal edilemedi', e));
    }
  }

  @override
  Future<Result<List<FocusSession>>> getSessionsForHabit(String habitId) async {
    try {
      final query = _db.select(_db.focusSessionsTable)
        ..where((tbl) => tbl.habitId.equals(habitId))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAtUtc)]);
      final rows = await query.get();
      return Success(rows.map(_mapToSessionEntity).toList());
    } catch (e) {
      return Failure(StorageFailure('Oturumlar getirilemedi', e));
    }
  }
}
