import 'package:drift/drift.dart';

class HabitsTable extends Table {
  @override
  String get tableName => 'habits';

  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 2, max: 60)();
  TextColumn get emoji => text()();
  TextColumn get category => text()(); // 'spiritual' or 'study'
  TextColumn get subcategory => text()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get archivedAtUtc => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitPlanVersionsTable extends Table {
  @override
  String get tableName => 'habit_plan_versions';

  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(HabitsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get effectiveFromDate => text()(); // yyyy-MM-dd
  TextColumn get weekdays => text()(); // comma separated 1,2,3
  TextColumn get targetType => text()(); // check, count, duration
  IntColumn get targetValue => integer()();
  TextColumn get unit => text()();
  BoolColumn get rewardEligible =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyCheckInsTable extends Table {
  @override
  String get tableName => 'daily_check_ins';

  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(HabitsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get localDate => text()(); // yyyy-MM-dd
  TextColumn get planVersionId => text()();
  IntColumn get manualValue => integer().withDefault(const Constant(0))();
  IntColumn get sessionSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get firstCompletedAtUtc => dateTime().nullable()();
  DateTimeColumn get lastCompletedAtUtc => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, localDate},
  ];
}

class FocusSessionsTable extends Table {
  @override
  String get tableName => 'focus_sessions';

  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(HabitsTable, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAtUtc => dateTime()();
  DateTimeColumn get activeSegmentStartedAtUtc => dateTime().nullable()();
  IntColumn get accumulatedSeconds =>
      integer().withDefault(const Constant(0))();
  IntColumn get plannedSeconds => integer()();
  TextColumn get status => text()(); // running, paused, completed, canceled
  DateTimeColumn get endedAtUtc => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FocusAllocationsTable extends Table {
  @override
  String get tableName => 'focus_allocations';

  TextColumn get sessionId =>
      text().references(FocusSessionsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get localDate => text()(); // yyyy-MM-dd
  IntColumn get activeSeconds => integer()();

  @override
  Set<Column> get primaryKey => {sessionId, localDate};
}

class RewardsTable extends Table {
  @override
  String get tableName => 'rewards';

  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 2, max: 80)();
  TextColumn get emoji => text()();
  TextColumn get description => text().withLength(max: 500)();
  IntColumn get targetSteps => integer()();
  TextColumn get status =>
      text()(); // draft, active, earned, planned, used, canceled
  DateTimeColumn get activatedAtUtc => dateTime().nullable()();
  DateTimeColumn get earnedAtUtc => dateTime().nullable()();
  DateTimeColumn get usedAtUtc => dateTime().nullable()();
  DateTimeColumn get planAtUtc => dateTime().nullable()();
  TextColumn get planTimezone => text().nullable()();
  TextColumn get placeName => text().nullable()();
  TextColumn get planNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RewardHabitLinksTable extends Table {
  @override
  String get tableName => 'reward_habit_links';

  TextColumn get rewardId =>
      text().references(RewardsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get habitId =>
      text().references(HabitsTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {rewardId, habitId};
}

class RewardContributionsTable extends Table {
  @override
  String get tableName => 'reward_contributions';

  TextColumn get id => text()();
  TextColumn get rewardId =>
      text().references(RewardsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get checkInId => text().nullable()();
  DateTimeColumn get allocatedAtUtc => dateTime()();
  BoolColumn get isReversed => boolean().withDefault(const Constant(false))();
  BoolColumn get reversedAfterUse =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class BadgesTable extends Table {
  @override
  String get tableName => 'badges';

  TextColumn get code => text()();
  DateTimeColumn get earnedAtUtc => dateTime()();
  TextColumn get evidenceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {code};
}

class DailyReflectionsTable extends Table {
  @override
  String get tableName => 'daily_reflections';

  TextColumn get localDate => text()(); // yyyy-MM-dd
  TextColumn get textContent => text().withLength(max: 500)();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {localDate};
}

class RemindersTable extends Table {
  @override
  String get tableName => 'reminders';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get habitId =>
      text().references(HabitsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get weekday => integer()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  TextColumn get status => text()();
  TextColumn get lastErrorCode => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, weekday},
  ];
}
