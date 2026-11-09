import 'package:flutter/foundation.dart';
import '../models/water_record_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterRecordModel> state = ValueNotifier<WaterRecordModel>(
    WaterRecordModel(
      currentIntakeMl: 1250,
      dailyGoalMl: 2500,
      glassCount: 5,
      lastUpdated: DateTime.now(),
    ),
  );

  WaterRecordModel get current => state.value;

  void addWater(int amountMl) {
    final newAmount = current.currentIntakeMl + amountMl;
    state.value = current.copyWith(
      currentIntakeMl: newAmount,
      glassCount: current.glassCount + 1,
      lastUpdated: DateTime.now(),
    );
  }

  void resetWater() {
    state.value = current.copyWith(
      currentIntakeMl: 0,
      glassCount: 0,
      lastUpdated: DateTime.now(),
    );
  }

  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl > 0) {
      state.value = current.copyWith(dailyGoalMl: newGoalMl);
    }
  }

  void dispose() {
    state.dispose();
  }
}
