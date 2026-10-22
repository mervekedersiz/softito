enum RewardStatus {
  draft('Taslak'),
  active('Aktif'),
  earned('Kazanıldı'),
  planned('Planlandı'),
  used('Kullanıldı'),
  canceled('İptal Edildi');

  const RewardStatus(this.displayName);
  final String displayName;

  static RewardStatus fromString(String val) => RewardStatus.values.firstWhere(
    (e) => e.name == val,
    orElse: () => RewardStatus.draft,
  );
}

class Reward {
  Reward({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.targetSteps,
    required this.status,
    this.activatedAtUtc,
    this.earnedAtUtc,
    this.usedAtUtc,
    this.planAtUtc,
    this.planTimezone,
    this.placeName,
    this.planNote,
    this.currentSteps = 0,
    List<String> linkedHabitIds = const [],
  }) : linkedHabitIds = List.unmodifiable(linkedHabitIds);

  final String id;
  final String title;
  final String emoji;
  final String description;
  final int targetSteps;
  final RewardStatus status;
  final DateTime? activatedAtUtc;
  final DateTime? earnedAtUtc;
  final DateTime? usedAtUtc;
  final DateTime? planAtUtc;
  final String? planTimezone;
  final String? placeName;
  final String? planNote;
  final int currentSteps;
  final List<String> linkedHabitIds;

  bool get isActive => status == RewardStatus.active;
  bool get isEarned => status == RewardStatus.earned;
  bool get isPlanned => status == RewardStatus.planned;
  bool get isUsed => status == RewardStatus.used;
  bool get isCanceled => status == RewardStatus.canceled;

  double get progressRatio =>
      targetSteps > 0 ? (currentSteps / targetSteps).clamp(0.0, 1.0) : 0.0;

  int get remainingSteps => (targetSteps - currentSteps).clamp(0, targetSteps);

  Reward copyWith({
    String? title,
    String? emoji,
    String? description,
    int? targetSteps,
    RewardStatus? status,
    DateTime? Function()? activatedAtUtc,
    DateTime? Function()? earnedAtUtc,
    DateTime? Function()? usedAtUtc,
    DateTime? Function()? planAtUtc,
    String? Function()? planTimezone,
    String? Function()? placeName,
    String? Function()? planNote,
    int? currentSteps,
    List<String>? linkedHabitIds,
  }) {
    return Reward(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      targetSteps: targetSteps ?? this.targetSteps,
      status: status ?? this.status,
      activatedAtUtc: activatedAtUtc != null
          ? activatedAtUtc()
          : this.activatedAtUtc,
      earnedAtUtc: earnedAtUtc != null ? earnedAtUtc() : this.earnedAtUtc,
      usedAtUtc: usedAtUtc != null ? usedAtUtc() : this.usedAtUtc,
      planAtUtc: planAtUtc != null ? planAtUtc() : this.planAtUtc,
      planTimezone: planTimezone != null ? planTimezone() : this.planTimezone,
      placeName: placeName != null ? placeName() : this.placeName,
      planNote: planNote != null ? planNote() : this.planNote,
      currentSteps: currentSteps ?? this.currentSteps,
      linkedHabitIds: linkedHabitIds != null
          ? List.unmodifiable(linkedHabitIds)
          : this.linkedHabitIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Reward && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
