import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<WorkoutStateModel> state = ValueNotifier<WorkoutStateModel>(
    const WorkoutStateModel(
      targetCalories: 650,
      workouts: [
        WorkoutItemModel(
          id: 'w1',
          title: 'HIIT Kardiyo & Sprint',
          category: 'Kardiyo',
          durationMinutes: 25,
          calories: 280,
          isCompleted: true,
        ),
        WorkoutItemModel(
          id: 'w2',
          title: 'Üst Vücut Hipertrofi',
          category: 'Ağırlık',
          durationMinutes: 45,
          calories: 240,
          isCompleted: false,
        ),
        WorkoutItemModel(
          id: 'w3',
          title: 'Core & Karın Güçlendirme',
          category: 'Fonksiyonel',
          durationMinutes: 15,
          calories: 120,
          isCompleted: false,
        ),
        WorkoutItemModel(
          id: 'w4',
          title: 'Antrenman Sonu Esneme',
          category: 'Mobilite',
          durationMinutes: 10,
          calories: 50,
          isCompleted: false,
        ),
      ],
    ),
  );

  WorkoutStateModel get current => state.value;

  void toggleWorkoutCompletion(String id) {
    final updatedList = current.workouts.map((w) {
      if (w.id == id) {
        return w.copyWith(isCompleted: !w.isCompleted);
      }
      return w;
    }).toList();

    state.value = current.copyWith(workouts: updatedList);
  }

  void addCustomWorkout({
    required String title,
    required String category,
    required int durationMinutes,
    required int calories,
  }) {
    final newWorkout = WorkoutItemModel(
      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      durationMinutes: durationMinutes,
      calories: calories,
      isCompleted: false,
    );

    state.value = current.copyWith(
      workouts: [...current.workouts, newWorkout],
    );
  }

  void dispose() {
    state.dispose();
  }
}
