import 'package:flutter/material.dart';

/// Visible notice that data, prices and bookings in the app are samples.
class DemoNoticeBanner extends StatelessWidget {
  const DemoNoticeBanner({super.key});

  static const String message =
      'Demo sürüm: araçlar, fiyatlar ve rezervasyonlar temsilidir. '
      'Gerçek kiralama, ödeme veya canlı takip yapılmaz.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      container: true,
      label: message,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: colors.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
