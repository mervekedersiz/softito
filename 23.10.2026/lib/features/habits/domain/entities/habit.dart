import 'habit_plan.dart';

enum HabitCategory {
  spiritual('Maneviyat ve İyilik', '🤲'),
  study('Ders ve Gelişim', '📚');

  const HabitCategory(this.displayName, this.defaultEmoji);
  final String displayName;
  final String defaultEmoji;

  static HabitCategory fromString(String val) => HabitCategory.values
      .firstWhere((e) => e.name == val, orElse: () => HabitCategory.study);
}

class Habit {
  Habit({
    required this.id,
    required this.title,
    required this.emoji,
    required this.category,
    required this.subcategory,
    required this.createdAtUtc,
    this.archivedAtUtc,
    this.currentPlan,
  });

  final String id;
  final String title;
  final String emoji;
  final HabitCategory category;
  final String subcategory;
  final DateTime createdAtUtc;
  final DateTime? archivedAtUtc;
  final HabitPlan? currentPlan;

  bool get isArchived => archivedAtUtc != null;

  Habit copyWith({
    String? title,
    String? emoji,
    HabitCategory? category,
    String? subcategory,
    DateTime? createdAtUtc,
    DateTime? Function()? archivedAtUtc,
    HabitPlan? Function()? currentPlan,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      archivedAtUtc: archivedAtUtc != null
          ? archivedAtUtc()
          : this.archivedAtUtc,
      currentPlan: currentPlan != null ? currentPlan() : this.currentPlan,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Habit && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
