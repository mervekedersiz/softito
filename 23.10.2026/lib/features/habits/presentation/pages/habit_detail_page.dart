import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/time/local_date.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../domain/entities/habit.dart';

import 'package:kendime_soz/features/progress/domain/services/streak_calculator.dart';

import '../widgets/habit_form_sheet.dart';

class HabitDetailPage extends ConsumerStatefulWidget {
  const HabitDetailPage({super.key, required this.habitId});

  final String habitId;

  @override
  ConsumerState<HabitDetailPage> createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends ConsumerState<HabitDetailPage> {
  void _editHabit(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => HabitFormSheet(
        initialHabit: habit,
        onSave: (updatedHabit, updatedPlan) async {
          final repo = ref.read(habitRepositoryProvider);
          final res = await repo.updateHabit(
            habit: updatedHabit,
            newPlan: updatedPlan,
          );
          res.when(
            onSuccess: (_) {
              setState(() {});
              if (context.mounted) {
                ActionFeedback.showSuccess(context, 'Alışkanlık güncellendi.');
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

  void _confirmDelete(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alışkanlığı Kalıcı Olarak Sil?'),
        content: Text(
          '“${habit.title}” alışkanlığını ve geçmiş tüm günlük kayıtlarını silmek istediğine emin misin? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final repo = ref.read(habitRepositoryProvider);
              final res = await repo.deleteHabitPermanently(habit.id);
              res.when(
                onSuccess: (_) {
                  if (context.mounted) {
                    ActionFeedback.showInfo(context, 'Alışkanlık silindi.');
                    context.pop();
                  }
                },
                onFailure: (f) {
                  if (context.mounted) {
                    ActionFeedback.showError(context, f.message);
                  }
                },
              );
            },
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(habitRepositoryProvider);
    final clock = ref.watch(clockProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alışkanlık Detayı')),
      body: FutureBuilder(
        future: Future.wait([
          repo.getHabitById(widget.habitId),
          repo.getCheckInsForHabit(widget.habitId),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingState(message: 'Detaylar yükleniyor...');
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return ErrorState(
              title: 'Alışkanlık Bulunamadı',
              message: 'Belirtilen alışkanlık silinmiş veya bulunamıyor.',
              onRetry: () => setState(() {}),
            );
          }

          final habitRes = snapshot.data![0];
          final checkInsRes = snapshot.data![1];

          if (habitRes.isFailure) {
            return ErrorState(
              title: 'Kayıt Bulunamadı',
              message:
                  habitRes.failureOrNull?.message ?? 'Alışkanlık bulunamadı.',
              onRetry: () => setState(() {}),
            );
          }

          final habit = habitRes.dataOrNull as Habit;
          final checkIns = (checkInsRes.dataOrNull ?? []) as List;

          final plan = habit.currentPlan;
          final today = LocalDate.fromDateTime(clock.now());

          // Calculate streak
          final completedDays = checkIns
              .where((c) => c.isCompleted)
              .map<LocalDate>((c) => c.localDate as LocalDate)
              .toSet();

          final planned = <LocalDate>[];
          if (plan != null) {
            final start = LocalDate.fromDateTime(habit.createdAtUtc);
            final weekdays = plan.weekdays.toSet();
            var c = start;
            while (!c.isAfter(today)) {
              if (weekdays.contains(c.weekday)) planned.add(c);
              c = c.addDays(1);
            }
          }

          final streak = StreakCalculator.calculate(
            plannedDays: planned,
            completedDays: completedDays,
            today: today,
          );

          final weekdayNames = [
            'Pzt',
            'Sal',
            'Çar',
            'Per',
            'Cum',
            'Cmt',
            'Paz',
          ];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Hero header card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(habit.emoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      habit.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${habit.category.displayName} • ${habit.subcategory}',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Streak & Stats Row
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${streak.currentStreak} Gün',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            const Text(
                              'Mevcut Seri',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${streak.longestStreak} Gün',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const Text(
                              'En Uzun Seri',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('✅', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${streak.totalCompletedPlannedDays}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Toplam Gün',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Plan Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Bilgileri',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.track_changes_rounded, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Hedef: ${plan?.targetValue} ${plan?.unit} (${plan?.targetType.displayName})',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Tekrar: ${(plan?.weekdays ?? []).map((d) => weekdayNames[d - 1]).join(', ')}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.confirmation_num_outlined, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            plan?.rewardEligible == true
                                ? 'Ödül biletine dahil 🎟️'
                                : 'Ödül biletine dahil değil',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Action Buttons
              FilledButton.icon(
                onPressed: () => _editHabit(context, habit),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Alışkanlığı Düzenle'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  if (habit.isArchived) {
                    await repo.unarchiveHabit(habit.id);
                    if (context.mounted) {
                      ActionFeedback.showSuccess(
                        context,
                        'Alışkanlık arşivden çıkarıldı.',
                      );
                      setState(() {});
                    }
                  } else {
                    await repo.archiveHabit(habit.id, DateTime.now().toUtc());
                    if (context.mounted) {
                      ActionFeedback.showInfo(
                        context,
                        'Alışkanlık arşivlendi.',
                      );
                      setState(() {});
                    }
                  }
                },
                icon: Icon(
                  habit.isArchived
                      ? Icons.unarchive_rounded
                      : Icons.archive_outlined,
                ),
                label: Text(habit.isArchived ? 'Arşivden Çıkar' : 'Arşivle'),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _confirmDelete(context, habit),
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  'Kalıcı Olarak Sil',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
