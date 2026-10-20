import 'package:flutter/material.dart';

/// Lays [children] out in as many equal-width columns as fit, so cards form
/// a gallery on wide screens and a list on phones without fixed heights.
class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    required this.children,
    this.minItemWidth = 340,
    this.spacing = 16,
    super.key,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final columns = ((available + spacing) / (minItemWidth + spacing))
            .floor();
        final count = columns < 1 ? 1 : columns;
        final width = (available - spacing * (count - 1)) / count;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}
