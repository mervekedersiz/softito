class WorkoutModel {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final int recommendedHydrationMl;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.recommendedHydrationMl,
  });

  WorkoutModel copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    int? recommendedHydrationMl,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      recommendedHydrationMl: recommendedHydrationMl ?? this.recommendedHydrationMl,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      title: json['title'] as String,
      durationMinutes: json['durationMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      recommendedHydrationMl: json['recommendedHydrationMl'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'recommendedHydrationMl': recommendedHydrationMl,
    };
  }
}
