import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    HabitsTable,
    HabitPlanVersionsTable,
    DailyCheckInsTable,
    FocusSessionsTable,
    FocusAllocationsTable,
    RewardsTable,
    RewardHabitLinksTable,
    RewardContributionsTable,
    BadgesTable,
    DailyReflectionsTable,
    RemindersTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'kendime_soz_db');
  }
}
