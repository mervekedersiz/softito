import '../../../../core/time/local_date.dart';

class DailyCheckIn {
  const DailyCheckIn({
    required this.id,
    required this.habitId,
    required this.localDate,
    required this.planVersionId,
    required this.manualValue,
    required this.sessionSeconds,
    required this.isCompleted,
    this.firstCompletedAtUtc,
    this.lastCompletedAtUtc,
    this.note,
  });

  final String id;
  final String habitId;
  final LocalDate localDate;
  final String planVersionId;
  final int manualValue;
  final int sessionSeconds;
  final bool isCompleted;
  final DateTime? firstCompletedAtUtc;
  final DateTime? lastCompletedAtUtc;
  final String? note;

  int get sessionMinutes => sessionSeconds ~/ 60;

  DailyCheckIn copyWith({
    String? id,
    String? habitId,
    LocalDate? localDate,
    String? planVersionId,
    int? manualValue,
    int? sessionSeconds,
    bool? isCompleted,
    DateTime? Function()? firstCompletedAtUtc,
    DateTime? Function()? lastCompletedAtUtc,
    String? Function()? note,
  }) {
    return DailyCheckIn(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      localDate: localDate ?? this.localDate,
      planVersionId: planVersionId ?? this.planVersionId,
      manualValue: manualValue ?? this.manualValue,
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      firstCompletedAtUtc: firstCompletedAtUtc != null
          ? firstCompletedAtUtc()
          : this.firstCompletedAtUtc,
      lastCompletedAtUtc: lastCompletedAtUtc != null
          ? lastCompletedAtUtc()
          : this.lastCompletedAtUtc,
      note: note != null ? note() : this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DailyCheckIn && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
