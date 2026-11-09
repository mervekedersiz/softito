class WaterTrackerModel {
  final int currentIntakeMl;
  final int dailyGoalMl;
  final int intakeCount;
  final int streakDays;
  final DateTime? lastIntakeTime;
  final int todayCaloriesBurned;
  final int workoutMinutes;

  const WaterTrackerModel({
    required this.currentIntakeMl,
    required this.dailyGoalMl,
    required this.intakeCount,
    required this.streakDays,
    this.lastIntakeTime,
    required this.todayCaloriesBurned,
    required this.workoutMinutes,
  });

  factory WaterTrackerModel.initial() {
    return const WaterTrackerModel(
      currentIntakeMl: 1250,
      dailyGoalMl: 2750,
      intakeCount: 5,
      streakDays: 4,
      lastIntakeTime: null,
      todayCaloriesBurned: 420,
      workoutMinutes: 45,
    );
  }

  double get progressPercentage {
    if (dailyGoalMl == 0) return 0.0;
    final ratio = currentIntakeMl / dailyGoalMl;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  int get remainingMl {
    final remaining = dailyGoalMl - currentIntakeMl;
    return remaining < 0 ? 0 : remaining;
  }

  WaterTrackerModel copyWith({
    int? currentIntakeMl,
    int? dailyGoalMl,
    int? intakeCount,
    int? streakDays,
    DateTime? lastIntakeTime,
    int? todayCaloriesBurned,
    int? workoutMinutes,
  }) {
    return WaterTrackerModel(
      currentIntakeMl: currentIntakeMl ?? this.currentIntakeMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      intakeCount: intakeCount ?? this.intakeCount,
      streakDays: streakDays ?? this.streakDays,
      lastIntakeTime: lastIntakeTime ?? this.lastIntakeTime,
      todayCaloriesBurned: todayCaloriesBurned ?? this.todayCaloriesBurned,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentIntakeMl: json['currentIntakeMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2500,
      intakeCount: json['intakeCount'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      lastIntakeTime: json['lastIntakeTime'] != null
          ? DateTime.tryParse(json['lastIntakeTime'] as String)
          : null,
      todayCaloriesBurned: json['todayCaloriesBurned'] as int? ?? 0,
      workoutMinutes: json['workoutMinutes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentIntakeMl': currentIntakeMl,
      'dailyGoalMl': dailyGoalMl,
      'intakeCount': intakeCount,
      'streakDays': streakDays,
      'lastIntakeTime': lastIntakeTime?.toIso8601String(),
      'todayCaloriesBurned': todayCaloriesBurned,
      'workoutMinutes': workoutMinutes,
    };
  }
}
