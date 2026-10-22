import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/time/local_date.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../journey/presentation/controllers/completion_controller.dart';
import '../../../settings/presentation/settings_sheet.dart';
import '../../domain/entities/habit.dart';
import '../controllers/habit_list_controller.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/numeric_progress_sheet.dart';

class SpiritualPage extends ConsumerWidget {
  const SpiritualPage({super.key});

  void _openAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => HabitFormSheet(
        defaultCategory: HabitCategory.spiritual,
        onSave: (habit, plan) async {
          final repo = ref.read(habitRepositoryProvider);
          final res = await repo.createHabit(habit: habit, plan: plan);
          res.when(
            onSuccess: (_) {
              if (context.mounted) {
                ActionFeedback.showSuccess(
                  context,
                  'Alışkanlık başarıyla eklendi! 🌱',
                );
              }
            },
            onFailure: (f) {
              if (context.mounted) {
                ActionFeedback.showError(context, f.message);
              }
            },
          );
        },
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final habitsAsync = ref.watch(
      habitsWithCheckInsProvider(HabitCategory.spiritual),
    );
    final completionState = ref.watch(completionControllerProvider);
    final completionNotifier = ref.read(completionControllerProvider.notifier);

    final isToday = selectedDate == LocalDate.fromDateTime(DateTime.now());
    final dateFormat = DateFormat('d MMMM, EEEE', 'tr_TR');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🤲', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  'Maneviyat ve İyilik',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.toDateTime(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  ref
                      .read(selectedDateProvider.notifier)
                      .selectDate(LocalDate.fromDateTime(picked));
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isToday
                        ? 'Bugün • ${dateFormat.format(selectedDate.toDateTime())}'
                        : dateFormat.format(selectedDate.toDateTime()),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            tooltip: 'İlerlemem',
            onPressed: () => context.push(RoutePaths.progress),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Ayarlar',
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: habitsAsync.when(
        loading: () =>
            const LoadingState(message: 'Alışkanlıklar yükleniyor...'),
        error: (err, _) => ErrorState(
          message: 'Veriler yüklenirken bir sorun oluştu.',
          onRetry: () =>
              ref.refresh(habitsWithCheckInsProvider(HabitCategory.spiritual)),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              emoji: '🤲',
              title: 'Henüz Maneviyat ve İyilik Alışkanlığın Yok',
              message: 'Günün telaşında ruhuna iyi gelecek küçük hedefler belirle: şükür, tefekkür, birine yardım veya ibadet.',
              actionLabel: 'İlk Sözünü Ekle',
              onAction: () => _openAddSheet(context, ref),
            );
          }

          final completedCount = items.where((i) => i.isCompleted).length;
          final totalCount = items.length;
          final ratio = totalCount > 0 ? completedCount / totalCount : 0.0;

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(
              habitsWithCheckInsProvider(HabitCategory.spiritual),
            ),
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              children: [
                // Daily progress summary banner
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Günün İlerlemesi: $completedCount / $totalCount Tamamlandı',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              completedCount == totalCount && totalCount > 0
                                  ? 'Harika! Bugünün tüm manevi hedeflerini tamamladın. 🌟'
                                  : 'Küçük adımlarla kalbini dinlendir.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 6,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.5,
                                ),
                                valueColor: AlwaysStoppedAnimation(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                // Habit cards
                ...items.map((item) {
                  return HabitCard(
                    item: item,
                    isPending: completionState.isPending(item.habit.id),
                    onTap: () => context.push('/habits/${item.habit.id}'),
                    onToggleCompletion: () async {
                      if (item.isCompleted) {
                        final outcome = await completionNotifier.revert(
                          habitId: item.habit.id,
                          date: selectedDate,
                        );
                        if (outcome != null && context.mounted) {
                          ActionFeedback.showInfo(
                            context,
                            'Tamamlama geri alındı.',
                          );
                        }
                      } else {
                        final outcome = await completionNotifier.complete(
                          habitId: item.habit.id,
                          date: selectedDate,
                          addValue: 1,
                        );
                        if (outcome != null && context.mounted) {
                          if (outcome.rewardEarned) {
                            ActionFeedback.showSuccess(
                              context,
                              'Tebrikler! "${outcome.rewardTitle}" biletini kazandın! 🎟️🎉',
                            );
                          } else {
                            ActionFeedback.showSuccess(
                              context,
                              'Harika! Tamamlandı. 🤲',
                            );
                          }
                        }
                      }
                    },
                    onOpenNumericSheet: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => NumericProgressSheet(
                          habit: item.habit,
                          currentValue: item.currentProgressValue,
                          onSave: (val, note) async {
                            final outcome = await completionNotifier.complete(
                              habitId: item.habit.id,
                              date: selectedDate,
                              addValue: val,
                              note: note,
                            );
                            if (outcome != null && context.mounted) {
                              ActionFeedback.showSuccess(
                                context,
                                'İlerleme kaydedildi! ✨',
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Hedef'),
      ),
    );
  }
}
