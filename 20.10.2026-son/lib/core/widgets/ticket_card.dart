import 'package:flutter/material.dart';

import 'dashed_divider.dart';

/// Ticket / receipt shaped card: a [top] and a [bottom] part separated by a
/// perforation line with semicircular notches on both sides.
class TicketCard extends StatelessWidget {
  const TicketCard({required this.top, required this.bottom, super.key});

  static const double _radius = 24;
  static const double _notch = 12;

  final Widget top;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHigh;

    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_radius),
            ),
          ),
          child: SizedBox(width: double.infinity, child: top),
        ),
        ClipPath(
          clipper: const _NotchClipper(_notch),
          child: ColoredBox(
            color: color,
            child: const SizedBox(
              height: _notch * 2,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: _notch + 8),
                child: Center(child: DashedDivider()),
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(_radius),
            ),
          ),
          child: SizedBox(width: double.infinity, child: bottom),
        ),
      ],
    );
  }
}

class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper(this.radius);

  final double radius;

  @override
  Path getClip(Size size) {
    final rect = Path()..addRect(Offset.zero & size);
    final circles = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: radius),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, size.height / 2),
          radius: radius,
        ),
      );
    return Path.combine(PathOperation.difference, rect, circles);
  }

  @override
  bool shouldReclip(_NotchClipper old) => old.radius != radius;
}
