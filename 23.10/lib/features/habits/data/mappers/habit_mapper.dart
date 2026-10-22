import '../../../../core/time/local_date.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/daily_check_in.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_plan.dart';

class HabitMapper {
  static Habit toHabitEntity(
    HabitsTableData data, {
    HabitPlanVersionsTableData? planData,
  }) {
    return Habit(
      id: data.id,
      title: data.title,
      emoji: data.emoji,
      category: HabitCategory.fromString(data.category),
      subcategory: data.subcategory,
      createdAtUtc: data.createdAtUtc,
      archivedAtUtc: data.archivedAtUtc,
      currentPlan: planData != null ? toPlanEntity(planData) : null,
    );
  }

  static HabitPlan toPlanEntity(HabitPlanVersionsTableData data) {
    final weekdays = data.weekdays
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map(int.parse)
        .toList();

    return HabitPlan(
      id: data.id,
      habitId: data.habitId,
      effectiveFromDate: LocalDate.parse(data.effectiveFromDate),
      weekdays: weekdays,
      targetType: HabitTargetType.fromString(data.targetType),
      targetValue: data.targetValue,
      unit: data.unit,
      rewardEligible: data.rewardEligible,
    );
  }

  static DailyCheckIn toCheckInEntity(DailyCheckInsTableData data) {
    return DailyCheckIn(
      id: data.id,
      habitId: data.habitId,
      localDate: LocalDate.parse(data.localDate),
      planVersionId: data.planVersionId,
      manualValue: data.manualValue,
      sessionSeconds: data.sessionSeconds,
      isCompleted: data.isCompleted,
      firstCompletedAtUtc: data.firstCompletedAtUtc,
      lastCompletedAtUtc: data.lastCompletedAtUtc,
      note: data.note,
    );
  }
}
