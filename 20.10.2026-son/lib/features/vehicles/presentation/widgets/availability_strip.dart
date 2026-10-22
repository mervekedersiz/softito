import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/services/demo_availability.dart';

/// 7-day sample availability. Each day shows an icon and text, not just color.
class AvailabilityStrip extends StatelessWidget {
  const AvailabilityStrip({required this.vehicle, this.today, super.key});

  final Vehicle vehicle;

  /// Overrides "today" (used by tests); defaults to the current date.
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final now = today ?? DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var offset = 0; offset < 7; offset++)
          _DayCell(
            date: DateTime(start.year, start.month, start.day + offset),
            isAvailable: isDemoDayAvailable(vehicle, offset),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.date, required this.isAvailable});

  final DateTime date;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final foreground = isAvailable ? colors.onPrimary : colors.onSurfaceVariant;

    return Semantics(
      label:
          '${formatDayMonth(date)} ${formatWeekday(date)}: '
          '${isAvailable ? 'müsait' : 'müsait değil'}',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isAvailable ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  formatWeekday(date),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                  ),
                ),
                Text(
                  '${date.day}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  isAvailable ? Icons.check : Icons.close,
                  size: 16,
                  color: foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
