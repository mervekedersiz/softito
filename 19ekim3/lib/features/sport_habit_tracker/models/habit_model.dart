class HabitItemModel {
  final String id;
  final String title;
  final int streakDays;
  final bool isDoneToday;
  final int targetDaysPerWeek;
  final String iconKey;

  const HabitItemModel({
    required this.id,
    required this.title,
    required this.streakDays,
    this.isDoneToday = false,
    this.targetDaysPerWeek = 5,
    this.iconKey = 'gym',
  });

  HabitItemModel copyWith({
    String? id,
    String? title,
    int? streakDays,
    bool? isDoneToday,
    int? targetDaysPerWeek,
    String? iconKey,
  }) {
    return HabitItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      streakDays: streakDays ?? this.streakDays,
      isDoneToday: isDoneToday ?? this.isDoneToday,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      iconKey: iconKey ?? this.iconKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'streakDays': streakDays,
      'isDoneToday': isDoneToday,
      'targetDaysPerWeek': targetDaysPerWeek,
      'iconKey': iconKey,
    };
  }

  factory HabitItemModel.fromJson(Map<String, dynamic> json) {
    return HabitItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      isDoneToday: json['isDoneToday'] as bool? ?? false,
      targetDaysPerWeek: (json['targetDaysPerWeek'] as num?)?.toInt() ?? 5,
      iconKey: json['iconKey'] as String? ?? 'gym',
    );
  }
}

class HabitStateModel {
  final List<HabitItemModel> habits;

  const HabitStateModel({required this.habits});

  int get totalStreaks => habits.fold(0, (sum, h) => sum + h.streakDays);

  int get completedTodayCount => habits.where((h) => h.isDoneToday).length;

  HabitStateModel copyWith({List<HabitItemModel>? habits}) {
    return HabitStateModel(habits: habits ?? this.habits);
  }
}
