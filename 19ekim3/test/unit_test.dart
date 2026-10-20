import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/features/sport_habit_tracker/controllers/habit_controller.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';

void main() {
  group('Susadım v1 Unit Tests', () {
    test('ThemeController toggles between dark and light modes', () {
      final themeController = ThemeController();
      expect(themeController.current, ThemeMode.dark);
      expect(themeController.isDarkMode, isTrue);

      themeController.toggleTheme();
      expect(themeController.current, ThemeMode.light);
      expect(themeController.isDarkMode, isFalse);

      themeController.toggleTheme();
      expect(themeController.current, ThemeMode.dark);

      themeController.dispose();
    });

    test('WaterTrackerController adds water and resets properly', () {
      final controller = WaterTrackerController();
      final initialWater = controller.current.currentIntakeMl;

      controller.addWater(250);
      expect(controller.current.currentIntakeMl, initialWater + 250);

      controller.resetWater();
      expect(controller.current.currentIntakeMl, 0);
      expect(controller.current.glassCount, 0);

      controller.dispose();
    });

    test('WorkoutController toggles workout completion status', () {
      final controller = WorkoutController();
      final firstWorkout = controller.current.workouts.first;
      final initialStatus = firstWorkout.isCompleted;

      controller.toggleWorkoutCompletion(firstWorkout.id);
      expect(
        controller.current.workouts.first.isCompleted,
        !initialStatus,
      );

      controller.dispose();
    });

    test('HabitController toggles habit and updates streak', () {
      final controller = HabitController();
      final firstHabit = controller.current.habits.first;
      final initialStreak = firstHabit.streakDays;

      controller.toggleHabit(firstHabit.id);
      expect(controller.current.habits.first.isDoneToday, !firstHabit.isDoneToday);
      if (firstHabit.isDoneToday) {
        expect(controller.current.habits.first.streakDays, initialStreak - 1);
      } else {
        expect(controller.current.habits.first.streakDays, initialStreak + 1);
      }

      controller.dispose();
    });
  });
}
