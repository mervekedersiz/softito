import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../domain/entities/focus_session.dart';

class FocusUIState {
  const FocusUIState({
    this.session,
    this.elapsedSeconds = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  final FocusSession? session;
  final int elapsedSeconds;
  final bool isLoading;
  final String? errorMessage;

  bool get hasActiveSession =>
      session != null && !session!.isCompleted && !session!.isCanceled;
  bool get isRunning => session?.isRunning ?? false;
  bool get isPaused => session?.isPaused ?? false;

  int get remainingSeconds {
    if (session == null) return 0;
    final rem = session!.plannedSeconds - elapsedSeconds;
    return rem > 0 ? rem : 0;
  }

  double get progressRatio {
    if (session == null || session!.plannedSeconds == 0) return 0.0;
    return (elapsedSeconds / session!.plannedSeconds).clamp(0.0, 1.0);
  }

  FocusUIState copyWith({
    FocusSession? Function()? session,
    int? elapsedSeconds,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return FocusUIState(
      session: session != null ? session() : this.session,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class FocusController extends Notifier<FocusUIState> {
  Timer? _ticker;
  StreamSubscription? _sessionSub;

  @override
  FocusUIState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _sessionSub?.cancel();
    });

    _listenToSession();
    return const FocusUIState();
  }

  void _listenToSession() {
    final repo = ref.read(focusRepositoryProvider);
    _sessionSub = repo.watchActiveSession().listen((session) {
      if (session == null) {
        _ticker?.cancel();
        state = const FocusUIState();
      } else {
        final clock = ref.read(clockProvider);
        final elapsed = session.calculateTotalActiveSeconds(clock.nowUtc());
        state = state.copyWith(
          session: () => session,
          elapsedSeconds: elapsed,
          isLoading: false,
        );
        _updateTicker(session.isRunning);
      }
    });
  }

  void _updateTicker(bool shouldRun) {
    _ticker?.cancel();
    if (shouldRun) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (state.session != null && state.session!.isRunning) {
          final clock = ref.read(clockProvider);
          final elapsed = state.session!.calculateTotalActiveSeconds(
            clock.nowUtc(),
          );
          state = state.copyWith(elapsedSeconds: elapsed);
        }
      });
    }
  }

  Future<bool> startSession({
    required String habitId,
    required int plannedMinutes,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final repo = ref.read(focusRepositoryProvider);
    final clock = ref.read(clockProvider);

    final result = await repo.startSession(
      habitId: habitId,
      plannedSeconds: plannedMinutes * 60,
      startedAtUtc: clock.nowUtc(),
    );

    return result.when(
      onSuccess: (session) {
        state = state.copyWith(
          session: () => session,
          elapsedSeconds: 0,
          isLoading: false,
        );
        _updateTicker(true);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  Future<void> pauseSession() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true);
    final repo = ref.read(focusRepositoryProvider);
    final clock = ref.read(clockProvider);

    await repo.pauseSession(
      sessionId: state.session!.id,
      pausedAtUtc: clock.nowUtc(),
    );
    _updateTicker(false);
  }

  Future<void> resumeSession() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true);
    final repo = ref.read(focusRepositoryProvider);
    final clock = ref.read(clockProvider);

    await repo.resumeSession(
      sessionId: state.session!.id,
      resumedAtUtc: clock.nowUtc(),
    );
    _updateTicker(true);
  }

  Future<bool> finishSession() async {
    if (state.session == null) return false;
    state = state.copyWith(isLoading: true);
    final journeyRepo = ref.read(journeyRepositoryProvider);
    final clock = ref.read(clockProvider);

    final result = await journeyRepo.finalizeFocusSession(
      sessionId: state.session!.id,
      nowUtc: clock.nowUtc(),
    );

    _updateTicker(false);
    return result.when(
      onSuccess: (_) {
        state = const FocusUIState();
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  Future<void> cancelSession() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true);
    final repo = ref.read(focusRepositoryProvider);
    await repo.cancelSession(state.session!.id);
    _updateTicker(false);
    state = const FocusUIState();
  }
}

final focusControllerProvider = NotifierProvider<FocusController, FocusUIState>(
  FocusController.new,
);
