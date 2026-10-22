import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';

import 'package:kendime_soz/features/habits/domain/entities/habit.dart';

import '../controllers/reward_controller.dart';
import '../widgets/reward_detail_sheet.dart';
import '../widgets/reward_form_sheet.dart';
import '../widgets/reward_ticket_card.dart';

class RewardsPage extends ConsumerWidget {
  const RewardsPage({super.key});

  void _openCreateSheet(
    BuildContext context,
    WidgetRef ref,
    List<Habit> availableHabits,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => RewardFormSheet(
        availableHabits: availableHabits,
        onSave:
            ({
              required title,
              required emoji,
              required description,
              required targetSteps,
              required habitIds,
            }) async {
              final notifier = ref.read(rewardControllerProvider.notifier);
              final ok = await notifier.createReward(
                title: title,
                emoji: emoji,
                description: description,
                targetSteps: targetSteps,
                habitIds: habitIds,
              );
              if (ok && context.mounted) {
                ActionFeedback.showSuccess(
                  context,
                  'Yeni ödül bileti oluşturuldu! 🎟️',
                );
              }
            },
      ),
    );
  }

  void _openPlanSheet(BuildContext context, WidgetRef ref, dynamic reward) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => RewardDetailSheet(
        reward: reward,
        onSavePlan:
            ({
              required planAtUtc,
              required planTimezone,
              placeName,
              planNote,
            }) async {
              final notifier = ref.read(rewardControllerProvider.notifier);
              final ok = await notifier.planReward(
                rewardId: reward.id,
                planAtUtc: planAtUtc,
                planTimezone: planTimezone,
                placeName: placeName,
                planNote: planNote,
              );
              if (ok && context.mounted) {
                ActionFeedback.showSuccess(
                  context,
                  'Ödül planı kaydedildi! Keyifli anlar dileriz. 📅',
                );
              }
            },
        onRemovePlan: () async {
          final notifier = ref.read(rewardControllerProvider.notifier);
          await notifier.removeRewardPlan(reward.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rewardsAsync = ref.watch(rewardsListProvider);
    final rewardNotifier = ref.read(rewardControllerProvider.notifier);

    final habitRepo = ref.watch(habitRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🎟️', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              'Kendime Zaman (Ödüller)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Habit>>(
        future: habitRepo.getHabits().then((res) => res.dataOrNull ?? []),
        builder: (context, habitSnapshot) {
          final availableHabits = habitSnapshot.data ?? [];

          return rewardsAsync.when(
            loading: () => const LoadingState(message: 'Ödüller yükleniyor...'),
            error: (err, _) => ErrorState(
              message: 'Ödül biletleri yüklenemedi.',
              onRetry: () => ref.refresh(rewardsListProvider),
            ),
            data: (rewards) {
              if (rewards.isEmpty) {
                return EmptyState(
                  emoji: '🎟️',
                  title: 'Henüz Bir Ödül Biletin Yok',
                  message: 'Belirlediğin sayıda alışkanlığı tamamlayınca kendine vereceğin güzel bir mola veya deneyim bileti oluştur (Müze gezisi, sinema, sahil yürüyüşü vb.).',
                  actionLabel: 'İlk Ödül Biletini Oluştur',
                  onAction: () =>
                      _openCreateSheet(context, ref, availableHabits),
                );
              }

              final activeRewards = rewards.where((r) => r.isActive).toList();
              final earnedOrPlanned = rewards
                  .where((r) => r.isEarned || r.isPlanned)
                  .toList();
              final otherRewards = rewards
                  .where((r) => r.status.name == 'draft' || r.isUsed)
                  .toList();

              return RefreshIndicator(
                onRefresh: () async => ref.refresh(rewardsListProvider),
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 88),
                  children: [
                    // Manifesto Card
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '“İç dünyama iyi geliyorum, geleceğime yatırım yapıyorum, kendime güzel anılar hediye ediyorum.”',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (activeRewards.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Şu Anki Aktif Biletin 🔥',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD67D3E),
                          ),
                        ),
                      ),
                      ...activeRewards.map(
                        (r) => RewardTicketCard(
                          reward: r,
                          onActivate: () {},
                          onPlan: () => _openPlanSheet(context, ref, r),
                          onUse: () {},
                          onCancel: () async {
                            final ok = await rewardNotifier.cancelReward(r.id);
                            if (ok && context.mounted) {
                              ActionFeedback.showInfo(
                                context,
                                'Bilet iptal edildi.',
                              );
                            }
                          },
                        ),
                      ),
                    ],

                    if (earnedOrPlanned.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Kazanılan ve Planlanan Biletler 🎉',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A7C59),
                          ),
                        ),
                      ),
                      ...earnedOrPlanned.map(
                        (r) => RewardTicketCard(
                          reward: r,
                          onActivate: () {},
                          onPlan: () => _openPlanSheet(context, ref, r),
                          onUse: () async {
                            final ok = await rewardNotifier.markRewardUsed(
                              r.id,
                            );
                            if (ok && context.mounted) {
                              ActionFeedback.showSuccess(
                                context,
                                'Tebrikler! Ödülünü kutladın! 🎟️🎉',
                              );
                            }
                          },
                          onCancel: () {},
                        ),
                      ),
                    ],

                    if (otherRewards.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Taslaklar ve Geçmiş Biletler',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      ...otherRewards.map(
                        (r) => RewardTicketCard(
                          reward: r,
                          onActivate: () async {
                            final ok = await rewardNotifier.activateReward(
                              r.id,
                            );
                            if (ok && context.mounted) {
                              ActionFeedback.showSuccess(
                                context,
                                'Ödül biletin aktifleşti! Adımları tamamla, ödülü kazan.',
                              );
                            }
                          },
                          onPlan: () => _openPlanSheet(context, ref, r),
                          onUse: () {},
                          onCancel: () {},
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await habitRepo.getHabits();
          final habits = res.dataOrNull ?? [];
          if (context.mounted) {
            _openCreateSheet(context, ref, habits);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Bilet'),
      ),
    );
  }
}
