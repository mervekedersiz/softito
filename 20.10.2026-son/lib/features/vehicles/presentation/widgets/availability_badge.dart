import 'package:flutter/material.dart';

import '../../../../app/brand_colors.dart';

/// Availability shown with an icon and text, never with color alone.
class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({required this.isAvailable, super.key});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final brand = context.brand;
    final background = isAvailable
        ? brand.successContainer
        : colors.errorContainer;
    final foreground = isAvailable
        ? brand.onSuccessContainer
        : colors.onErrorContainer;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAvailable ? Icons.check_circle : Icons.block,
              size: 16,
              color: foreground,
            ),
            const SizedBox(width: 6),
            Text(
              isAvailable ? 'Müsait (demo)' : 'Müsait değil',
              style: theme.textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
