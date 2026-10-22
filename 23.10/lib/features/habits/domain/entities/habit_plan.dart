import '../../../../core/time/local_date.dart';

enum HabitTargetType {
  check('Tek Onay'),
  count('Adet'),
  duration('Dakika');

  const HabitTargetType(this.displayName);
  final String displayName;

  static HabitTargetType fromString(String val) => HabitTargetType.values
      .firstWhere((e) => e.name == val, orElse: () => HabitTargetType.check);
}

class HabitPlan {
  HabitPlan({
    required this.id,
    required this.habitId,
    required this.effectiveFromDate,
    required List<int> weekdays,
    required this.targetType,
    required this.targetValue,
    required this.unit,
    required this.rewardEligible,
  }) : weekdays = List.unmodifiable(weekdays);

  final String id;
  final String habitId;
  final LocalDate effectiveFromDate;
  final List<int> weekdays; // 1 = Monday ... 7 = Sunday
  final HabitTargetType targetType;
  final int targetValue;
  final String unit;
  final bool rewardEligible;

  bool isPlannedForWeekday(int weekday) => weekdays.contains(weekday);

  HabitPlan copyWith({
    String? id,
    String? habitId,
    LocalDate? effectiveFromDate,
    List<int>? weekdays,
    HabitTargetType? targetType,
    int? targetValue,
    String? unit,
    bool? rewardEligible,
  }) {
    return HabitPlan(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      effectiveFromDate: effectiveFromDate ?? this.effectiveFromDate,
      weekdays: weekdays != null ? List.unmodifiable(weekdays) : this.weekdays,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      rewardEligible: rewardEligible ?? this.rewardEligible,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is HabitPlan && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
