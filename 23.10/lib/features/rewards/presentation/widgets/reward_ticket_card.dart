import 'package:flutter/material.dart';

import '../../domain/entities/reward.dart';

class RewardTicketCard extends StatelessWidget {
  const RewardTicketCard({
    super.key,
    required this.reward,
    required this.onActivate,
    required this.onPlan,
    required this.onUse,
    required this.onCancel,
  });

  final Reward reward;
  final VoidCallback onActivate;
  final VoidCallback onPlan;
  final VoidCallback onUse;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color statusColor;
    switch (reward.status) {
      case RewardStatus.active:
        statusColor = const Color(0xFFD67D3E);
        break;
      case RewardStatus.earned:
        statusColor = const Color(0xFF4A7C59);
        break;
      case RewardStatus.planned:
        statusColor = const Color(0xFF3F72AF);
        break;
      case RewardStatus.used:
        statusColor = Colors.grey;
        break;
      default:
        statusColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: reward.isActive
              ? statusColor
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: reward.isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(19),
              ),
            ),
            child: Row(
              children: [
                Text(reward.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (reward.description.isNotEmpty)
                        Text(
                          reward.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reward.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dashed divider line representation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                30,
                (index) => Expanded(
                  child: Container(
                    color: index.isEven
                        ? theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          )
                        : Colors.transparent,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Body & Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reward.isActive || reward.isEarned) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'İlerleme: ${reward.currentSteps} / ${reward.targetSteps} adım',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        reward.isEarned
                            ? '🎉 Kazanıldı!'
                            : 'Son ${reward.remainingSteps} adım',
                        style: TextStyle(
                          color: reward.isEarned
                              ? const Color(0xFF4A7C59)
                              : statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: reward.progressRatio,
                      minHeight: 8,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(statusColor),
                    ),
                  ),
                ],
                if (reward.isPlanned) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_rounded,
                        size: 18,
                        color: Color(0xFF3F72AF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Planlandı: ${reward.placeName ?? 'Seçilen mekan'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (reward.planNote != null && reward.planNote!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 26),
                      child: Text(
                        reward.planNote!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
                if (reward.isUsed) ...[
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Bu ödül biletini kullandın ve anını yaşadın!',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),

                // Buttons depending on status
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (reward.status == RewardStatus.draft)
                      FilledButton.icon(
                        onPressed: onActivate,
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Bileti Etkinleştir'),
                      ),
                    if (reward.isActive)
                      TextButton.icon(
                        onPressed: onCancel,
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Bileti İptal Et'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    if (reward.isEarned) ...[
                      FilledButton.icon(
                        onPressed: onPlan,
                        icon: const Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                        ),
                        label: const Text('Planla'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: onUse,
                        child: const Text('Şimdi Kullandım'),
                      ),
                    ],
                    if (reward.isPlanned) ...[
                      OutlinedButton(
                        onPressed: onPlan,
                        child: const Text('Planı Düzenle'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: onUse,
                        icon: const Icon(Icons.celebration_rounded, size: 18),
                        label: const Text('Ödülümü Kullandım!'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
