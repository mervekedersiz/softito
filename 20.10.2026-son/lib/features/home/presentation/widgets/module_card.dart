import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_chip.dart';

/// Card for one app module on the "Amacın ne?" screen.
///
/// When [onTap] is null the module is shown as "Yakında" and is not tappable.
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final emphasis = _isEnabled ? colors.onSurface : colors.onSurfaceVariant;

    return Semantics(
      button: _isEnabled,
      enabled: _isEnabled,
      label: _isEnabled
          ? '$title. $description'
          : '$title, yakında. $description',
      excludeSemantics: true,
      onTap: onTap,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 88),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _isEnabled
                        ? colors.primary
                        : colors.surfaceContainerHighest,
                    child: Icon(
                      icon,
                      color: _isEnabled
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: emphasis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isEnabled)
                    Icon(Icons.chevron_right, color: colors.onSurfaceVariant)
                  else
                    const ComingSoonChip(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
