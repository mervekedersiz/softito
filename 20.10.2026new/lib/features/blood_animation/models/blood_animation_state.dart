enum AnimationStatusState {
  idle('Başlamaya Hazır'),
  running('Akış Sürüyor'),
  paused('Duraklatıldı'),
  completed('Tamamlandı');

  final String label;
  const AnimationStatusState(this.label);
}

class BloodAnimationState {
  final AnimationStatusState status;
  final double progress; // 0.0 to 1.0

  const BloodAnimationState({
    this.status = AnimationStatusState.idle,
    this.progress = 0.0,
  });

  bool get isIdle => status == AnimationStatusState.idle;
  bool get isRunning => status == AnimationStatusState.running;
  bool get isPaused => status == AnimationStatusState.paused;
  bool get isCompleted => status == AnimationStatusState.completed;

  int get percentage => (progress.clamp(0.0, 1.0) * 100).round();

  BloodAnimationState copyWith({
    AnimationStatusState? status,
    double? progress,
  }) {
    return BloodAnimationState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}
