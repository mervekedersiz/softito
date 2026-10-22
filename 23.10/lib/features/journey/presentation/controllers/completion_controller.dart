import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kendime_soz/app/di/app_providers.dart';
import 'package:kendime_soz/core/time/local_date.dart';
import 'package:kendime_soz/features/journey/domain/repositories/journey_repository.dart';

class CompletionState {
  const CompletionState({
    this.pendingIds = const {},
    this.lastOutcome,
    this.errorMessage,
  });

  final Set<String> pendingIds;
  final CompletionOutcome? lastOutcome;
  final String? errorMessage;

  bool isPending(String id) => pendingIds.contains(id);

  CompletionState copyWith({
    Set<String>? pendingIds,
    CompletionOutcome? Function()? lastOutcome,
    String? Function()? errorMessage,
  }) {
    return CompletionState(
      pendingIds: pendingIds ?? this.pendingIds,
      lastOutcome: lastOutcome != null ? lastOutcome() : this.lastOutcome,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class CompletionController extends Notifier<CompletionState> {
  @override
  CompletionState build() => const CompletionState();

  Future<CompletionOutcome?> complete({
    required String habitId,
    required LocalDate date,
    required int addValue,
    String? note,
  }) async {
    if (state.isPending(habitId)) return null;

    state = state.copyWith(
      pendingIds: {...state.pendingIds, habitId},
      errorMessage: () => null,
    );

    final clock = ref.read(clockProvider);
    final journeyRepo = ref.read(journeyRepositoryProvider);

    final result = await journeyRepo.recordProgress(
      habitId: habitId,
      date: date,
      addManualValue: addValue,
      nowUtc: clock.nowUtc(),
      note: note,
    );

    final newPending = Set<String>.from(state.pendingIds)..remove(habitId);

    return result.when(
      onSuccess: (outcome) {
        state = state.copyWith(
          pendingIds: newPending,
          lastOutcome: () => outcome,
        );
        return outcome;
      },
      onFailure: (failure) {
        state = state.copyWith(
          pendingIds: newPending,
          errorMessage: () => failure.message,
        );
        return null;
      },
    );
  }

  Future<CompletionOutcome?> revert({
    required String habitId,
    required LocalDate date,
  }) async {
    if (state.isPending(habitId)) return null;

    state = state.copyWith(
      pendingIds: {...state.pendingIds, habitId},
      errorMessage: () => null,
    );

    final clock = ref.read(clockProvider);
    final journeyRepo = ref.read(journeyRepositoryProvider);

    final result = await journeyRepo.revertProgress(
      habitId: habitId,
      date: date,
      nowUtc: clock.nowUtc(),
    );

    final newPending = Set<String>.from(state.pendingIds)..remove(habitId);

    return result.when(
      onSuccess: (outcome) {
        state = state.copyWith(
          pendingIds: newPending,
          lastOutcome: () => outcome,
        );
        return outcome;
      },
      onFailure: (failure) {
        state = state.copyWith(
          pendingIds: newPending,
          errorMessage: () => failure.message,
        );
        return null;
      },
    );
  }
}

final completionControllerProvider =
    NotifierProvider<CompletionController, CompletionState>(
      CompletionController.new,
    );
