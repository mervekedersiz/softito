import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<List<WorkoutModel>> availableWorkouts =
      ValueNotifier<List<WorkoutModel>>([
    const WorkoutModel(
      id: '1',
      title: 'HIIT Kardiyo & Sprint',
      durationMinutes: 25,
      caloriesBurned: 240,
      recommendedHydrationMl: 350,
    ),
    const WorkoutModel(
      id: '2',
      title: 'Ağırlık & Hipertrofi',
      durationMinutes: 45,
      caloriesBurned: 320,
      recommendedHydrationMl: 500,
    ),
    const WorkoutModel(
      id: '3',
      title: 'Açık Hava Koşusu',
      durationMinutes: 40,
      caloriesBurned: 380,
      recommendedHydrationMl: 600,
    ),
    const WorkoutModel(
      id: '4',
      title: 'Pilates & Core Kuvvet',
      durationMinutes: 30,
      caloriesBurned: 180,
      recommendedHydrationMl: 250,
    ),
    const WorkoutModel(
      id: '5',
      title: 'Yüzme & Kondisyon',
      durationMinutes: 35,
      caloriesBurned: 310,
      recommendedHydrationMl: 450,
    ),
  ]);

  final ValueNotifier<int> totalWorkoutsCompleted = ValueNotifier<int>(2);

  void completeWorkout(
    WorkoutModel workout, {
    required void Function(int minutes, int calories) onLoggedToWaterTracker,
  }) {
    totalWorkoutsCompleted.value += 1;
    onLoggedToWaterTracker(workout.durationMinutes, workout.caloriesBurned);
  }

  void dispose() {
    availableWorkouts.dispose();
    totalWorkoutsCompleted.dispose();
  }
}
