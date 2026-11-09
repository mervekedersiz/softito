import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(WaterTrackerModel.initial());

  WaterTrackerModel get current => state.value;

  void addWater(int amountMl) {
    final currentModel = state.value;
    final newAmount = currentModel.currentIntakeMl + amountMl;
    state.value = currentModel.copyWith(
      currentIntakeMl: newAmount,
      intakeCount: currentModel.intakeCount + 1,
      lastIntakeTime: DateTime.now(),
    );
  }

  void resetWater() {
    final currentModel = state.value;
    state.value = currentModel.copyWith(
      currentIntakeMl: 0,
      intakeCount: 0,
    );
  }

  void setGoal(int goalMl) {
    final currentModel = state.value;
    state.value = currentModel.copyWith(dailyGoalMl: goalMl);
  }

  void logWorkout(int additionalMinutes, int burnedCalories) {
    final currentModel = state.value;
    // Egzersiz yapıldıkça su ihtiyacı da artar (+12ml / dakika egzersiz)
    final extraGoal = additionalMinutes * 12;
    state.value = currentModel.copyWith(
      workoutMinutes: currentModel.workoutMinutes + additionalMinutes,
      todayCaloriesBurned: currentModel.todayCaloriesBurned + burnedCalories,
      dailyGoalMl: currentModel.dailyGoalMl + extraGoal,
    );
  }

  void dispose() {
    state.dispose();
  }
}
