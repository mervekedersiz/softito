import 'package:flutter/foundation.dart';
import 'package:susadim/features/workout/models/workout_item.dart';

class WorkoutController extends ChangeNotifier {
  WorkoutController({int initialCalorieGoal = 600})
      : _dailyCalorieGoal = initialCalorieGoal {
    _initSampleData();
  }

  int _dailyCalorieGoal;
  final List<WorkoutItem> _items = <WorkoutItem>[];

  int get dailyCalorieGoal => _dailyCalorieGoal;
  List<WorkoutItem> get items => List<WorkoutItem>.unmodifiable(_items);

  void setDailyCalorieGoal(int newGoal) {
    if (newGoal <= 0) return;
    _dailyCalorieGoal = newGoal;
    notifyListeners();
  }

  int get totalCaloriesBurned {
    var sum = 0;
    for (final item in _items) {
      sum += item.caloriesBurned;
    }
    return sum;
  }

  int get totalMinutes {
    var sum = 0;
    for (final item in _items) {
      sum += item.durationMinutes;
    }
    return sum;
  }

  double get calorieProgress {
    if (_dailyCalorieGoal <= 0) return 0.0;
    final ratio = totalCaloriesBurned / _dailyCalorieGoal;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  void addWorkout({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    final newItem = WorkoutItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      category: category,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
    );
    _items.insert(0, newItem);
    notifyListeners();
  }

  void removeWorkout(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void _initSampleData() {
    _items.addAll([
      WorkoutItem(
        id: '1',
        title: 'Kuvvet Antrenmanı',
        category: 'Ağırlık',
        durationMinutes: 45,
        caloriesBurned: 320,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      WorkoutItem(
        id: '2',
        title: 'Koşu Bandı HIIT',
        category: 'Kardiyo',
        durationMinutes: 20,
        caloriesBurned: 180,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ]);
  }
}
