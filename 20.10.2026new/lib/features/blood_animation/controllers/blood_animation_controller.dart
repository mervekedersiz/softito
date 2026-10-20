import 'package:flutter/foundation.dart';
import '../models/blood_animation_state.dart';

class BloodAnimationController extends ValueNotifier<BloodAnimationState> {
  BloodAnimationController() : super(const BloodAnimationState());

  void start() {
    if (value.isIdle) {
      value = value.copyWith(
        status: AnimationStatusState.running,
        progress: 0.0,
      );
    }
  }

  void pause() {
    if (value.isRunning) {
      value = value.copyWith(status: AnimationStatusState.paused);
    }
  }

  void resume() {
    if (value.isPaused) {
      value = value.copyWith(status: AnimationStatusState.running);
    }
  }

  void reset() {
    value = const BloodAnimationState(
      status: AnimationStatusState.idle,
      progress: 0.0,
    );
  }

  void updateProgress(double p) {
    final clamped = p.clamp(0.0, 1.0);
    if (clamped >= 1.0) {
      value = value.copyWith(
        status: AnimationStatusState.completed,
        progress: 1.0,
      );
    } else {
      value = value.copyWith(progress: clamped);
    }
  }
}
