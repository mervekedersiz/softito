import 'package:flutter/foundation.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';

class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({int initialGoalMl = 2500})
      : _dailyGoalMl = initialGoalMl;

  int _dailyGoalMl;
  final List<WaterLog> _logs = <WaterLog>[];

  int get dailyGoalMl => _dailyGoalMl;
  List<WaterLog> get logs => List<WaterLog>.unmodifiable(_logs);

  int get totalDrankMl {
    var sum = 0;
    for (final log in _logs) {
      sum += log.amountMl;
    }
    return sum;
  }

  double get progress {
    if (_dailyGoalMl <= 0) return 0.0;
    final ratio = totalDrankMl / _dailyGoalMl;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  int get remainingMl {
    final remaining = _dailyGoalMl - totalDrankMl;
    return remaining < 0 ? 0 : remaining;
  }

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final newLog = WaterLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );
    _logs.insert(0, newLog);
    notifyListeners();
  }

  void removeLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }

  void setDailyGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    _dailyGoalMl = newGoalMl;
    notifyListeners();
  }

  void resetToday() {
    _logs.clear();
    notifyListeners();
  }
}
