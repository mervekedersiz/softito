import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../domain/entities/reward.dart';

final rewardsListProvider = StreamProvider<List<Reward>>((ref) {
  final repo = ref.watch(rewardRepositoryProvider);
  return repo.watchRewards();
});

class RewardActionState {
  const RewardActionState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  RewardActionState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return RewardActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage: successMessage != null
          ? successMessage()
          : this.successMessage,
    );
  }
}

class RewardController extends Notifier<RewardActionState> {
  @override
  RewardActionState build() => const RewardActionState();

  Future<bool> createReward({
    required String title,
    required String emoji,
    required String description,
    required int targetSteps,
    required List<String> habitIds,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      successMessage: () => null,
    );
    final repo = ref.read(rewardRepositoryProvider);

    final id = 'rew_${DateTime.now().millisecondsSinceEpoch}';
    final reward = Reward(
      id: id,
      title: title,
      emoji: emoji,
      description: description,
      targetSteps: targetSteps,
      status: RewardStatus.draft,
      linkedHabitIds: habitIds,
    );

    final result = await repo.createReward(reward: reward, habitIds: habitIds);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: () => 'Ödül taslağı oluşturuldu.',
        );
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

  Future<bool> activateReward(String rewardId) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      successMessage: () => null,
    );
    final repo = ref.read(rewardRepositoryProvider);
    final clock = ref.read(clockProvider);

    final result = await repo.activateReward(
      rewardId: rewardId,
      activatedAtUtc: clock.nowUtc(),
    );

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: () =>
              'Ödül biletin aktifleşti! Adımları tamamla, ödülünü kazan.',
        );
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

  Future<bool> planReward({
    required String rewardId,
    required DateTime planAtUtc,
    required String planTimezone,
    String? placeName,
    String? planNote,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      successMessage: () => null,
    );
    final repo = ref.read(rewardRepositoryProvider);

    final result = await repo.planReward(
      rewardId: rewardId,
      planAtUtc: planAtUtc,
      planTimezone: planTimezone,
      placeName: placeName,
      planNote: planNote,
    );

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: () => 'Ödül planı kaydedildi! Keyifli anlar dileriz.',
        );
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

  Future<bool> removeRewardPlan(String rewardId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final repo = ref.read(rewardRepositoryProvider);

    final result = await repo.removeRewardPlan(rewardId);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: () =>
              'Plan kaldırıldı, bilet kazanılmış olarak bekliyor.',
        );
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

  Future<bool> markRewardUsed(String rewardId) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      successMessage: () => null,
    );
    final repo = ref.read(rewardRepositoryProvider);
    final clock = ref.read(clockProvider);

    final result = await repo.markRewardUsed(
      rewardId: rewardId,
      usedAtUtc: clock.nowUtc(),
    );

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: () =>
              'Tebrikler! Ödülünü kullandın ve anını kutladın. 🎟️🎉',
        );
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

  Future<bool> cancelReward(String rewardId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final repo = ref.read(rewardRepositoryProvider);

    final result = await repo.cancelReward(rewardId);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: () => 'Ödül iptal edildi.',
        );
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
}

final rewardControllerProvider =
    NotifierProvider<RewardController, RewardActionState>(RewardController.new);
