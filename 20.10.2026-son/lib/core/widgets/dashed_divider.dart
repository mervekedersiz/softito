import 'package:flutter/material.dart';

/// A horizontal dashed line, used as a ticket perforation.
class DashedDivider extends StatelessWidget {
  const DashedDivider({this.dashWidth = 8, this.gap = 6, super.key});

  final double dashWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return SizedBox(
      height: 2,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedPainter(color: color, dashWidth: dashWidth, gap: gap),
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  const _DashedPainter({
    required this.color,
    required this.dashWidth,
    required this.gap,
  });

  final Color color;
  final double dashWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var x = 0.0; x < size.width; x += dashWidth + gap) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dashWidth).clamp(0, size.width), size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedPainter old) =>
      old.color != color || old.dashWidth != dashWidth || old.gap != gap;
}
