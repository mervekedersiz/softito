import 'package:flutter/material.dart';

import '../../app/brand_colors.dart';

/// The brand's infinity-road ribbon, drawn in code (no image asset needed).
class BrandMark extends StatelessWidget {
  const BrandMark({this.height = 32, this.opacity = 1, super.key});

  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ExcludeSemantics(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          size: Size(height * 2, height),
          painter: _BrandMarkPainter(
            start: brand.gold,
            middle: brand.sun,
            end: brand.silver,
          ),
        ),
      ),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter({
    required this.start,
    required this.middle,
    required this.end,
  });

  final Color start;
  final Color middle;
  final Color end;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * .5, h * .5)
      ..cubicTo(w * .62, h * .12, w * .97, h * .12, w * .97, h * .5)
      ..cubicTo(w * .97, h * .88, w * .62, h * .88, w * .5, h * .5)
      ..cubicTo(w * .38, h * .12, w * .03, h * .12, w * .03, h * .5)
      ..cubicTo(w * .03, h * .88, w * .38, h * .88, w * .5, h * .5);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * .16
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(colors: [start, middle, end])
          .createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BrandMarkPainter old) =>
      old.start != start || old.middle != middle || old.end != end;
}
