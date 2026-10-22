import '../../../../core/result/result.dart';
import '../entities/reward.dart';

abstract class RewardRepository {
  Stream<List<Reward>> watchRewards();
  Future<Result<List<Reward>>> getRewards();
  Future<Result<Reward?>> getActiveReward();
  Future<Result<Reward>> getRewardById(String id);
  Future<Result<Reward>> createReward({
    required Reward reward,
    required List<String> habitIds,
  });
  Future<Result<Reward>> activateReward({
    required String rewardId,
    required DateTime activatedAtUtc,
  });
  Future<Result<void>> cancelReward(String rewardId);
  Future<Result<Reward>> planReward({
    required String rewardId,
    required DateTime planAtUtc,
    required String planTimezone,
    String? placeName,
    String? planNote,
  });
  Future<Result<Reward>> removeRewardPlan(String rewardId);
  Future<Result<Reward>> markRewardUsed({
    required String rewardId,
    required DateTime usedAtUtc,
  });
}
