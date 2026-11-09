import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kendime_soz/core/widgets/action_feedback.dart';
import 'package:kendime_soz/features/habits/domain/entities/habit.dart';
import 'package:kendime_soz/features/habits/domain/entities/habit_plan.dart';

import '../controllers/focus_controller.dart';

class FocusTimerPanel extends ConsumerStatefulWidget {
  const FocusTimerPanel({super.key, required this.habits});

  final List<Habit> habits;

  @override
  ConsumerState<FocusTimerPanel> createState() => _FocusTimerPanelState();
}

class _FocusTimerPanelState extends ConsumerState<FocusTimerPanel> {
  String? _selectedHabitId;
  int _selectedMinutes = 25;

  @override
  void initState() {
    super.initState();
    final durationHabits = _getDurationHabits();
    if (durationHabits.isNotEmpty) {
      _selectedHabitId = durationHabits.first.id;
    }
  }

  List<Habit> _getDurationHabits() {
    return widget.habits
        .where(
          (h) =>
              h.category == HabitCategory.study &&
              h.currentPlan?.targetType == HabitTargetType.duration,
        )
        .toList();
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusState = ref.watch(focusControllerProvider);
    final focusNotifier = ref.read(focusControllerProvider.notifier);

    final durationHabits = _getDurationHabits();
    if (_selectedHabitId == null && durationHabits.isNotEmpty) {
      _selectedHabitId = durationHabits.first.id;
    }

    final isSessionActive = focusState.hasActiveSession;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('⏱️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  'Odaklanma Sayacı (Pomodoro)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isSessionActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: focusState.isRunning
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      focusState.isRunning ? 'Devam Ediyor' : 'Duraklatıldı',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: focusState.isRunning
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (!isSessionActive) ...[
              if (durationHabits.isEmpty)
                Text(
                  'Sayacı başlatmak için dakika türünde bir ders alışkanlığı ekleyin.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else ...[
                DropdownButtonFormField<String>(
                  initialValue: _selectedHabitId,
                  decoration: const InputDecoration(
                    labelText: 'Odaklanılacak Alışkanlık',
                  ),
                  items: durationHabits.map((h) {
                    return DropdownMenuItem(
                      value: h.id,
                      child: Text('${h.emoji} ${h.title}'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedHabitId = val),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Süre:'),
                    const SizedBox(width: 12),
                    Wrap(
                      spacing: 8,
                      children: [15, 25, 45, 60].map((mins) {
                        return ChoiceChip(
                          label: Text('$mins dk'),
                          selected: _selectedMinutes == mins,
                          onSelected: (sel) {
                            if (sel) setState(() => _selectedMinutes = mins);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _selectedHabitId == null
                        ? null
                        : () async {
                            final ok = await focusNotifier.startSession(
                              habitId: _selectedHabitId!,
                              plannedMinutes: _selectedMinutes,
                            );
                            if (ok && context.mounted) {
                              ActionFeedback.showSuccess(
                                context,
                                '$_selectedMinutes dakikalık odaklanma oturumu başladı!',
                              );
                            }
                          },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text('Odaklanmaya Başla ($_selectedMinutes dk)'),
                  ),
                ),
              ],
            ] else ...[
              // Active session running / paused display
              Center(
                child: Column(
                  children: [
                    Text(
                      _formatTime(focusState.remainingSeconds),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tamamlanan: ${focusState.elapsedSeconds ~/ 60} dk • Hedef: ${focusState.session!.plannedSeconds ~/ 60} dk',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: focusState.progressRatio,
                        minHeight: 8,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (focusState.isRunning)
                    OutlinedButton.icon(
                      onPressed: () => focusNotifier.pauseSession(),
                      icon: const Icon(Icons.pause_rounded),
                      label: const Text('Duraklat'),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () => focusNotifier.resumeSession(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Sürdür'),
                    ),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final ok = await focusNotifier.finishSession();
                      if (ok && context.mounted) {
                        ActionFeedback.showSuccess(
                          context,
                          'Odaklanma tamamlandı ve kaydedildi! 🎉',
                        );
                      }
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Bitir'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await focusNotifier.cancelSession();
                      if (context.mounted) {
                        ActionFeedback.showInfo(
                          context,
                          'Oturum iptal edildi.',
                        );
                      }
                    },
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
