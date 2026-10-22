import '../../../../core/time/local_date.dart';

class StreakResult {
  const StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletedPlannedDays,
  });

  final int currentStreak;
  final int longestStreak;
  final int totalCompletedPlannedDays;
}

class StreakCalculator {
  /// Calculates current streak and longest streak for a habit
  /// [plannedDays]: sorted list of LocalDates where the habit was planned, in ascending order
  /// [completedDays]: set of LocalDates where the habit was completed
  /// [today]: current local date
  static StreakResult calculate({
    required List<LocalDate> plannedDays,
    required Set<LocalDate> completedDays,
    required LocalDate today,
  }) {
    if (plannedDays.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        totalCompletedPlannedDays: 0,
      );
    }

    // Filter to only past and today
    final eligibleDays = plannedDays.where((d) => !d.isAfter(today)).toList()
      ..sort((a, b) => a.compareTo(b));

    if (eligibleDays.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        totalCompletedPlannedDays: 0,
      );
    }

    int totalCompleted = 0;
    int longest = 0;
    int running = 0;

    for (final day in eligibleDays) {
      final isComp = completedDays.contains(day);
      if (isComp) {
        totalCompleted++;
        running++;
        if (running > longest) longest = running;
      } else {
        // If it's today and not yet completed, don't break the streak until today ends!
        if (day == today) {
          // today is pending, current running streak is preserved
        } else {
          running = 0;
        }
      }
    }

    // For current streak:
    // Check backwards from today
    int current = 0;
    final reversed = eligibleDays.reversed.toList();

    for (int i = 0; i < reversed.length; i++) {
      final day = reversed[i];
      final isComp = completedDays.contains(day);

      if (day == today) {
        if (isComp) {
          current++;
        }
        // If today is not completed, we continue backwards to count previous streak
        continue;
      }

      if (isComp) {
        current++;
      } else {
        // missed past planned day breaks current streak
        break;
      }
    }

    return StreakResult(
      currentStreak: current,
      longestStreak: longest,
      totalCompletedPlannedDays: totalCompleted,
    );
  }
}
