class WorkoutItemModel {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int calories;
  final bool isCompleted;

  const WorkoutItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.calories,
    this.isCompleted = false,
  });

  WorkoutItemModel copyWith({
    String? id,
    String? title,
    String? category,
    int? durationMinutes,
    int? calories,
    bool? isCompleted,
  }) {
    return WorkoutItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'durationMinutes': durationMinutes,
      'calories': calories,
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutItemModel.fromJson(Map<String, dynamic> json) {
    return WorkoutItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class WorkoutStateModel {
  final List<WorkoutItemModel> workouts;
  final int targetCalories;

  const WorkoutStateModel({
    required this.workouts,
    this.targetCalories = 600,
  });

  int get totalBurnedCalories => workouts
      .where((w) => w.isCompleted)
      .fold(0, (sum, w) => sum + w.calories);

  int get totalCompletedMinutes => workouts
      .where((w) => w.isCompleted)
      .fold(0, (sum, w) => sum + w.durationMinutes);

  double get calorieProgress => targetCalories > 0
      ? (totalBurnedCalories / targetCalories).clamp(0.0, 1.0)
      : 0.0;

  WorkoutStateModel copyWith({
    List<WorkoutItemModel>? workouts,
    int? targetCalories,
  }) {
    return WorkoutStateModel(
      workouts: workouts ?? this.workouts,
      targetCalories: targetCalories ?? this.targetCalories,
    );
  }
}
