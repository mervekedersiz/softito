import 'package:flutter_test/flutter_test.dart';
import 'package:kendime_soz/core/time/local_date.dart';
import 'package:kendime_soz/core/validation/validators.dart';
import 'package:kendime_soz/features/progress/domain/services/completion_rate_calculator.dart';
import 'package:kendime_soz/features/progress/domain/services/streak_calculator.dart';

void main() {
  group('LocalDate tests', () {
    test('LocalDate formatting and parsing', () {
      final date = LocalDate(2026, 10, 22);
      expect(date.key, '2026-10-22');

      final parsed = LocalDate.parse('2026-10-22');
      expect(parsed, equals(date));
      expect(parsed.weekday, 4); // Thursday
    });

    test('LocalDate addDays and comparisons', () {
      final date = LocalDate(2026, 10, 22);
      final nextDay = date.addDays(1);
      expect(nextDay.key, '2026-10-23');
      expect(date.isBefore(nextDay), isTrue);
      expect(nextDay.isAfter(date), isTrue);
    });
  });

  group('Validators tests', () {
    test('Habit title validation', () {
      expect(validateHabitTitle(''), isNotNull);
      expect(validateHabitTitle('a'), isNotNull);
      expect(validateHabitTitle('25 dk Kitap Oku'), isNull);
    });

    test('Reward title validation', () {
      expect(validateRewardTitle(''), isNotNull);
      expect(validateRewardTitle('Sahilde Kahve'), isNull);
    });

    test('Target steps validation', () {
      expect(validateTargetSteps(null), isNotNull);
      expect(validateTargetSteps(0), isNotNull);
      expect(validateTargetSteps(8), isNull);
      expect(validateTargetSteps(1001), isNotNull);
    });
  });

  group('StreakCalculator tests', () {
    test('Preserves streak when today is pending', () {
      final today = LocalDate(2026, 10, 22); // Thursday
      final wednesday = LocalDate(2026, 10, 21);
      final tuesday = LocalDate(2026, 10, 20);

      final planned = [tuesday, wednesday, today];
      final completed = {tuesday, wednesday};

      final res = StreakCalculator.calculate(
        plannedDays: planned,
        completedDays: completed,
        today: today,
      );

      // Wednesday & Tuesday completed, today not yet finished -> streak is 2
      expect(res.currentStreak, 2);
      expect(res.longestStreak, 2);
      expect(res.totalCompletedPlannedDays, 2);
    });

    test('Adds to streak when today is completed', () {
      final today = LocalDate(2026, 10, 22);
      final wednesday = LocalDate(2026, 10, 21);

      final planned = [wednesday, today];
      final completed = {wednesday, today};

      final res = StreakCalculator.calculate(
        plannedDays: planned,
        completedDays: completed,
        today: today,
      );

      expect(res.currentStreak, 2);
      expect(res.longestStreak, 2);
    });

    test('Past missed planned day breaks streak', () {
      final today = LocalDate(2026, 10, 22);
      final wednesday = LocalDate(2026, 10, 21);
      final tuesday = LocalDate(2026, 10, 20);

      final planned = [tuesday, wednesday, today];
      // Tuesday completed, but Wednesday missed!
      final completed = {tuesday};

      final res = StreakCalculator.calculate(
        plannedDays: planned,
        completedDays: completed,
        today: today,
      );

      expect(res.currentStreak, 0);
      expect(res.longestStreak, 1);
    });
  });

  group('CompletionRateCalculator tests', () {
    test('Zero planned returns null ratio', () {
      final res = CompletionRateCalculator.calculate(completed: 0, planned: 0);
      expect(res.ratio, isNull);
      expect(res.formattedDisplay, '—');
    });

    test('Calculates correct percentage', () {
      final res = CompletionRateCalculator.calculate(completed: 3, planned: 4);
      expect(res.ratio, 0.75);
      expect(res.percentage, 75);
      expect(res.formattedDisplay, '%75');
    });
  });
}
