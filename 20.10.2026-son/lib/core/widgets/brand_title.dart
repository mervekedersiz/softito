import 'package:flutter/material.dart';

import 'brand_mark.dart';

/// "YolOrtağım" wordmark with the brand's two-tone styling.
class BrandTitle extends StatelessWidget {
  const BrandTitle({this.onDark = false, super.key});

  /// Use light text colors on dark backgrounds such as the home hero.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final style = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );

    return Semantics(
      label: 'YolOrtağım',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandMark(height: 28),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Yol',
                  style: style?.copyWith(
                    color: onDark ? colors.onPrimary : colors.primary,
                  ),
                ),
                TextSpan(
                  text: 'Ortağım',
                  style: style?.copyWith(color: colors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
