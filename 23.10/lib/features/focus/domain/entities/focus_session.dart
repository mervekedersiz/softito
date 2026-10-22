enum FocusSessionStatus {
  running('Devam Ediyor'),
  paused('Duraklatıldı'),
  completed('Tamamlandı'),
  canceled('İptal Edildi');

  const FocusSessionStatus(this.displayName);
  final String displayName;

  static FocusSessionStatus fromString(String val) =>
      FocusSessionStatus.values.firstWhere(
        (e) => e.name == val,
        orElse: () => FocusSessionStatus.canceled,
      );
}

class FocusSession {
  const FocusSession({
    required this.id,
    required this.habitId,
    required this.startedAtUtc,
    this.activeSegmentStartedAtUtc,
    required this.accumulatedSeconds,
    required this.plannedSeconds,
    required this.status,
    this.endedAtUtc,
  });

  final String id;
  final String habitId;
  final DateTime startedAtUtc;
  final DateTime? activeSegmentStartedAtUtc;
  final int accumulatedSeconds;
  final int plannedSeconds;
  final FocusSessionStatus status;
  final DateTime? endedAtUtc;

  bool get isRunning => status == FocusSessionStatus.running;
  bool get isPaused => status == FocusSessionStatus.paused;
  bool get isCompleted => status == FocusSessionStatus.completed;
  bool get isCanceled => status == FocusSessionStatus.canceled;

  int calculateTotalActiveSeconds(DateTime nowUtc) {
    if (isRunning && activeSegmentStartedAtUtc != null) {
      final additional = nowUtc
          .difference(activeSegmentStartedAtUtc!)
          .inSeconds;
      return accumulatedSeconds + (additional > 0 ? additional : 0);
    }
    return accumulatedSeconds;
  }

  FocusSession copyWith({
    String? id,
    String? habitId,
    DateTime? startedAtUtc,
    DateTime? Function()? activeSegmentStartedAtUtc,
    int? accumulatedSeconds,
    int? plannedSeconds,
    FocusSessionStatus? status,
    DateTime? Function()? endedAtUtc,
  }) {
    return FocusSession(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      activeSegmentStartedAtUtc: activeSegmentStartedAtUtc != null
          ? activeSegmentStartedAtUtc()
          : this.activeSegmentStartedAtUtc,
      accumulatedSeconds: accumulatedSeconds ?? this.accumulatedSeconds,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      status: status ?? this.status,
      endedAtUtc: endedAtUtc != null ? endedAtUtc() : this.endedAtUtc,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FocusSession && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
