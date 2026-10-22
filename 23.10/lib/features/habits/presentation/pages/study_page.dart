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
import '../../../focus/presentation/widgets/focus_timer_panel.dart';
import '../../../journey/presentation/controllers/completion_controller.dart';
import '../../../settings/presentation/settings_sheet.dart';
import '../../domain/entities/habit.dart';
import '../controllers/habit_list_controller.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/numeric_progress_sheet.dart';

class StudyPage extends ConsumerWidget {
  const StudyPage({super.key});

  void _openAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => HabitFormSheet(
        defaultCategory: HabitCategory.study,
        onSave: (habit, plan) async {
          final repo = ref.read(habitRepositoryProvider);
          final res = await repo.createHabit(habit: habit, plan: plan);
          res.when(
            onSuccess: (_) {
              if (context.mounted) {
                ActionFeedback.showSuccess(
                  context,
                  'Ders ve gelişim hedefi eklendi! 📚',
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
      habitsWithCheckInsProvider(HabitCategory.study),
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
                const Text('📚', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  'Ders ve Gelişim',
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
            const LoadingState(message: 'Ders hedefleri yükleniyor...'),
        error: (err, _) => ErrorState(
          message: 'Veriler yüklenirken bir sorun oluştu.',
          onRetry: () =>
              ref.refresh(habitsWithCheckInsProvider(HabitCategory.study)),
        ),
        data: (items) {
          final habitEntities = items.map((i) => i.habit).toList();

          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(habitsWithCheckInsProvider(HabitCategory.study)),
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              children: [
                // Pomodoro Focus Timer
                FocusTimerPanel(habits: habitEntities),

                if (items.isEmpty)
                  EmptyState(
                    emoji: '📚',
                    title: 'Henüz Ders Hedefin Yok',
                    message: 'Geleceğine yatırım yapacak küçük hedefler belirle: soru çözmek, kitap okumak, kod yazmak veya odaklanma oturumu.',
                    actionLabel: 'İlk Hedefini Ekle',
                    onAction: () => _openAddSheet(context, ref),
                  )
                else ...[
                  // Summary Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Günlük Alışkanlıklar (${items.where((i) => i.isCompleted).length}/${items.length})',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Zinciri Kırma 🔥',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                'Harika bir adım attın! 🎯',
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
                                  'İlerleme kaydedildi! 🚀',
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Alışkanlık'),
      ),
    );
  }
}
