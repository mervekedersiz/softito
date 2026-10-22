import '../../../../core/result/result.dart';
import '../../../../core/time/local_date.dart';
import '../entities/daily_check_in.dart';
import '../entities/habit.dart';
import '../entities/habit_plan.dart';

abstract class HabitRepository {
  Stream<List<Habit>> watchHabits({
    HabitCategory? category,
    bool includeArchived = false,
  });
  Future<Result<List<Habit>>> getHabits({
    HabitCategory? category,
    bool includeArchived = false,
  });
  Future<Result<Habit>> getHabitById(String id);
  Future<Result<Habit>> createHabit({
    required Habit habit,
    required HabitPlan plan,
  });
  Future<Result<Habit>> updateHabit({required Habit habit, HabitPlan? newPlan});
  Future<Result<void>> archiveHabit(String id, DateTime archivedAtUtc);
  Future<Result<void>> unarchiveHabit(String id);
  Future<Result<void>> deleteHabitPermanently(String id);

  Stream<DailyCheckIn?> watchCheckIn(String habitId, LocalDate date);
  Future<Result<DailyCheckIn?>> getCheckIn(String habitId, LocalDate date);
  Future<Result<List<DailyCheckIn>>> getCheckInsForHabit(String habitId);
  Future<Result<List<DailyCheckIn>>> getCheckInsForDate(LocalDate date);
}
