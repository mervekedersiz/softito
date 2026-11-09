import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/time/local_date.dart';
import '../../domain/entities/badge.dart';
import '../../domain/services/completion_rate_calculator.dart';
import '../../domain/services/streak_calculator.dart';

final badgesListProvider = StreamProvider<List<AppBadge>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.watchBadges();
});

class DailyHeatmapCell {
  const DailyHeatmapCell({
    required this.date,
    required this.completedCount,
    required this.plannedCount,
  });

  final LocalDate date;
  final int completedCount;
  final int plannedCount;

  bool get isPlanned => plannedCount > 0;
  double get ratio =>
      plannedCount > 0 ? (completedCount / plannedCount).clamp(0.0, 1.0) : 0.0;
}

class ProgressSummaryData {
  const ProgressSummaryData({
    required this.weeklyRate,
    required this.monthlyRate,
    required this.bestStreak,
    required this.totalCompletions,
    required this.heatmapCells,
  });

  final CompletionRateResult weeklyRate;
  final CompletionRateResult monthlyRate;
  final int bestStreak;
  final int totalCompletions;
  final List<DailyHeatmapCell> heatmapCells;
}

final progressSummaryProvider = FutureProvider<ProgressSummaryData>((
  ref,
) async {
  final clock = ref.watch(clockProvider);
  final habitRepo = ref.watch(habitRepositoryProvider);

  final today = LocalDate.fromDateTime(clock.now());

  // Fetch all active habits
  final habitsRes = await habitRepo.getHabits(includeArchived: false);
  final habits = habitsRes.dataOrNull ?? [];

  // Generate last 60 days
  final days = <LocalDate>[];
  for (int i = 59; i >= 0; i--) {
    days.add(today.addDays(-i));
  }

  final heatmapCells = <DailyHeatmapCell>[];
  int totalWeeklyCompleted = 0;
  int totalWeeklyPlanned = 0;
  int totalMonthlyCompleted = 0;
  int totalMonthlyPlanned = 0;
  int grandTotalCompleted = 0;

  final weekStart = today.addDays(-6);
  final monthStart = today.addDays(-29);

  for (final day in days) {
    int dayPlanned = 0;
    int dayCompleted = 0;

    for (final h in habits) {
      if (h.currentPlan != null &&
          h.currentPlan!.isPlannedForWeekday(day.weekday)) {
        dayPlanned++;
      }
    }

    final checkIns = await habitRepo.getCheckInsForDate(day);
    for (final ci in checkIns.dataOrNull ?? []) {
      if (ci.isCompleted) {
        dayCompleted++;
        grandTotalCompleted++;
      }
    }

    if (!day.isBefore(weekStart)) {
      totalWeeklyPlanned += dayPlanned;
      totalWeeklyCompleted += dayCompleted;
    }

    if (!day.isBefore(monthStart)) {
      totalMonthlyPlanned += dayPlanned;
      totalMonthlyCompleted += dayCompleted;
    }

    heatmapCells.add(
      DailyHeatmapCell(
        date: day,
        completedCount: dayCompleted,
        plannedCount: dayPlanned,
      ),
    );
  }

  // Calculate best streak among habits
  int bestStreak = 0;
  for (final h in habits) {
    if (h.currentPlan == null) continue;
    final checkInsRes = await habitRepo.getCheckInsForHabit(h.id);
    final completedDays = (checkInsRes.dataOrNull ?? [])
        .where((c) => c.isCompleted)
        .map((c) => c.localDate)
        .toSet();

    final weekdays = h.currentPlan!.weekdays.toSet();
    final start = LocalDate.fromDateTime(h.createdAtUtc);
    final planned = <LocalDate>[];
    var c = start;
    while (!c.isAfter(today)) {
      if (weekdays.contains(c.weekday)) planned.add(c);
      c = c.addDays(1);
    }

    final s = StreakCalculator.calculate(
      plannedDays: planned,
      completedDays: completedDays,
      today: today,
    );
    if (s.longestStreak > bestStreak) bestStreak = s.longestStreak;
    if (s.currentStreak > bestStreak) bestStreak = s.currentStreak;
  }

  return ProgressSummaryData(
    weeklyRate: CompletionRateCalculator.calculate(
      completed: totalWeeklyCompleted,
      planned: totalWeeklyPlanned,
    ),
    monthlyRate: CompletionRateCalculator.calculate(
      completed: totalMonthlyCompleted,
      planned: totalMonthlyPlanned,
    ),
    bestStreak: bestStreak,
    totalCompletions: grandTotalCompleted,
    heatmapCells: heatmapCells,
  );
});
