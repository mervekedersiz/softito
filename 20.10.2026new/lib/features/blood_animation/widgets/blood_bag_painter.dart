import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BloodBagPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final double wavePhase; // 0.0 to 2*pi
  final Color fluidTopColor;
  final Color fluidBottomColor;
  final Color bagBorderColor;
  final Color bagBgColor;
  final bool isDark;

  BloodBagPainter({
    required this.progress,
    required this.wavePhase,
    required this.fluidTopColor,
    required this.fluidBottomColor,
    required this.bagBorderColor,
    required this.bagBgColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Bag dimensions relative to canvas size
    final bagWidth = size.width * 0.72;
    final bagHeight = size.height * 0.78;
    final left = (size.width - bagWidth) / 2;
    final top = size.height * 0.16;
    final right = left + bagWidth;
    final bottom = top + bagHeight;

    // Top hanger loop
    final hangerPaint = Paint()
      ..color = bagBorderColor.withAlpha(150)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final hangerRect = Rect.fromCenter(
      center: Offset(size.width / 2, top - 14),
      width: 32,
      height: 18,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hangerRect, const Radius.circular(8)),
      hangerPaint,
    );

    // Inner hanger eyelet hole
    final eyeletPaint = Paint()
      ..color = isDark ? AppColors.darkBackground : AppColors.lightBackground
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, top - 14), 4.5, eyeletPaint);

    // Bag neck / inlet port
    final neckRect = Rect.fromLTWH(size.width / 2 - 12, top - 8, 24, 12);
    final neckPaint = Paint()
      ..color = bagBorderColor.withAlpha(200)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(neckRect, const Radius.circular(3)),
      neckPaint,
    );

    // Main Bag Body Path
    final bagRRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(left, top, right, bottom),
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: const Radius.circular(32),
      bottomRight: const Radius.circular(32),
    );

    final bagPath = Path()..addRRect(bagRRect);

    // 1. Draw bag transparent background
    final bgPaint = Paint()
      ..color = bagBgColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(bagPath, bgPaint);

    // 2. Liquid Filling (clipped to bag inner bounds)
    if (progress > 0.005) {
      canvas.save();
      canvas.clipPath(bagPath);

      final liquidHeight = bagHeight * progress.clamp(0.0, 1.0);
      final liquidTopBase = bottom - liquidHeight;

      final liquidPath = Path();
      liquidPath.moveTo(left - 10, bottom + 10);
      liquidPath.lineTo(left - 10, liquidTopBase);

      // Sinusoidal surface wave across width
      final waveAmp =
          (1.0 - (progress - 0.5).abs() * 1.5).clamp(0.0, 1.0) * 3.5;
      const step = 4.0;
      for (double x = left - 10; x <= right + 10; x += step) {
        final relX = (x - left) / bagWidth;
        // Damp amplitude near left & right bag edges
        final edgeDamping = math.sin((relX.clamp(0.0, 1.0)) * math.pi);
        final y =
            liquidTopBase +
            math.sin((x / 18.0) + wavePhase) * waveAmp * edgeDamping;
        liquidPath.lineTo(x, y);
      }

      liquidPath.lineTo(right + 10, bottom + 10);
      liquidPath.close();

      // Liquid Gradient Fill
      final liquidGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fluidTopColor, fluidBottomColor],
        stops: const [0.0, 1.0],
      );

      final fluidPaint = Paint()
        ..shader = liquidGradient.createShader(
          Rect.fromLTRB(left, liquidTopBase - 10, right, bottom),
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(liquidPath, fluidPaint);

      // Specular highlight on wave crest
      final waveHighlightPaint = Paint()
        ..color = Colors.white.withAlpha(60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(liquidPath, waveHighlightPaint);

      // Deep bottom blood shadow
      final bottomGlowPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0.9),
          radius: 0.8,
          colors: [Colors.black.withAlpha(80), Colors.transparent],
        ).createShader(Rect.fromLTRB(left, bottom - 40, right, bottom))
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTRB(left, bottom - 40, right, bottom),
        bottomGlowPaint,
      );

      canvas.restore();
    }

    // 3. Measurement ticks on the side (100, 200, 300, 400 ml markings)
    final tickPaint = Paint()
      ..color = (isDark ? Colors.white30 : Colors.black26)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 1; i <= 4; i++) {
      final tickY = bottom - (bagHeight * 0.18 * i);
      final tickX = right - 16;
      canvas.drawLine(
        Offset(tickX, tickY),
        Offset(right - 4, tickY),
        tickPaint,
      );

      textPainter.text = TextSpan(
        text: '${i * 100}',
        style: TextStyle(
          color: (isDark ? Colors.white38 : Colors.black38),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(tickX - textPainter.width - 4, tickY - 5),
      );
    }

    // 4. Stylized Medical Cross Label in center-top of bag
    final crossCenter = Offset(size.width / 2, top + 26);
    final crossPaint = Paint()
      ..color = AppColors.bloodRed.withAlpha(160)
      ..style = PaintingStyle.fill;
    // Horizontal cross bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: crossCenter, width: 14, height: 4),
        const Radius.circular(2),
      ),
      crossPaint,
    );
    // Vertical cross bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: crossCenter, width: 4, height: 14),
        const Radius.circular(2),
      ),
      crossPaint,
    );

    // 5. Bag Border & Glassmorphic outer stroke
    final borderPaint = Paint()
      ..color = bagBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(bagPath, borderPaint);

    // 6. Subtle glass sheen highlight on right corner
    final sheenPath = Path();
    sheenPath.moveTo(right - 12, top + 30);
    sheenPath.quadraticBezierTo(
      right - 6,
      top + bagHeight * 0.4,
      right - 12,
      bottom - 40,
    );
    final sheenPaint = Paint()
      ..color = Colors.white.withAlpha(isDark ? 30 : 60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(sheenPath, sheenPaint);
  }

  @override
  bool shouldRepaint(covariant BloodBagPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.fluidTopColor != fluidTopColor ||
        oldDelegate.fluidBottomColor != fluidBottomColor ||
        oldDelegate.bagBorderColor != bagBorderColor ||
        oldDelegate.bagBgColor != bagBgColor ||
        oldDelegate.isDark != isDark;
  }
}
