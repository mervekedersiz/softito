import 'package:flutter/material.dart';

import '../../domain/entities/habit_plan.dart';
import '../controllers/habit_list_controller.dart';
import 'completion_button.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.item,
    required this.isPending,
    required this.onTap,
    required this.onToggleCompletion,
    required this.onOpenNumericSheet,
  });

  final HabitWithCheckIn item;
  final bool isPending;
  final VoidCallback onTap;
  final VoidCallback onToggleCompletion;
  final VoidCallback onOpenNumericSheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habit = item.habit;
    final plan = habit.currentPlan;
    final isDone = item.isCompleted;

    String targetText = '';
    if (plan != null) {
      if (plan.targetType == HabitTargetType.check) {
        targetText = 'Günlük hedef';
      } else {
        targetText =
            '${item.currentProgressValue}/${plan.targetValue} ${plan.unit}';
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDone
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.6,
                        )
                      : theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.4,
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(habit.emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            habit.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isDone
                                  ? theme.colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    )
                                  : theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (plan?.rewardEligible ?? false) ...[
                          const SizedBox(width: 6),
                          const Tooltip(
                            message: 'Ödül biletine katkı sağlar',
                            child: Text('🎟️', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            habit.subcategory,
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          targetText,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDone
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isDone
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CompletionButton(
                isCompleted: isDone,
                isPending: isPending,
                targetDisplay:
                    plan?.targetType != HabitTargetType.check && !isDone
                    ? '${item.currentProgressValue}/${plan?.targetValue ?? 1}'
                    : null,
                onPressed: () {
                  if (plan?.targetType == HabitTargetType.check || isDone) {
                    onToggleCompletion();
                  } else {
                    onOpenNumericSheet();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
