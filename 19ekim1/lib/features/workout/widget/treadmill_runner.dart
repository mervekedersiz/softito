import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class TreadmillRunner extends StatefulWidget {
  const TreadmillRunner({
    super.key,
    required this.isRunning,
    this.speedKmh = 8.5,
  });

  final bool isRunning;
  final double speedKmh;

  @override
  State<TreadmillRunner> createState() => _TreadmillRunnerState();
}

class _TreadmillRunnerState extends State<TreadmillRunner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _runController;

  @override
  void initState() {
    super.initState();
    _runController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat();
  }

  @override
  void dispose() {
    _runController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _TreadmillHeader(speedKmh: widget.speedKmh),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _runController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _RunnerPainter(runPhase: _runController.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TreadmillHeader extends StatelessWidget {
  const _TreadmillHeader({required this.speedKmh});

  final double speedKmh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.directions_run_rounded, color: AppColors.neonLime, size: 20),
            SizedBox(width: 8),
            Text(
              'Koşu Bandı',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Text(
            '$speedKmh km/s • Canlı',
            style: const TextStyle(
              color: AppColors.neonLime,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _RunnerPainter extends CustomPainter {
  _RunnerPainter({required this.runPhase});

  final double runPhase;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width * 0.48;
    const groundY = 125.0;

    _drawTreadmill(canvas, size, groundY);
    _drawChildRunner(canvas, centerX, groundY);
  }

  void _drawTreadmill(Canvas canvas, Size size, double groundY) {
    final beltPaint = Paint()
      ..color = const Color(0xFF1F2430)
      ..style = PaintingStyle.fill;

    final beltRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, groundY, size.width * 0.70, 14),
      const Radius.circular(7),
    );
    canvas.drawRRect(beltRect, beltPaint);

    final stripePaint = Paint()
      ..color = AppColors.neonLime.withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final beltStart = size.width * 0.18;
    final beltWidth = size.width * 0.64;
    for (int i = 0; i < 7; i++) {
      final offset = ((i / 7.0) - runPhase) % 1.0;
      final x = beltStart + offset * beltWidth;
      canvas.drawLine(Offset(x, groundY + 2), Offset(x, groundY + 12), stripePaint);
    }

    final framePaint = Paint()
      ..color = AppColors.neonLime
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final consoleX = size.width * 0.78;
    canvas.drawLine(Offset(size.width * 0.72, groundY + 7), Offset(consoleX, groundY - 45), framePaint);
    canvas.drawLine(Offset(consoleX, groundY - 45), Offset(consoleX - 22, groundY - 45), framePaint);

    final screenPaint = Paint()
      ..color = AppColors.neonLime
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(consoleX - 8, groundY - 55, 16, 12),
        const Radius.circular(3),
      ),
      screenPaint,
    );
  }

  void _drawChildRunner(Canvas canvas, double cx, double groundY) {
    final cycle = runPhase * 2 * math.pi;
    final bounce = math.sin(cycle * 2).abs() * 5.0;
    final hipY = groundY - 42.0 - bounce;

    final bodyPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final limbPaint = Paint()
      ..color = AppColors.neonCyan
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = AppColors.neonLime
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final headY = hipY - 26;
    final headCenter = Offset(cx + 6, headY);
    canvas.drawCircle(headCenter, 8, Paint()..color = const Color(0xFFFFCC80));

    final capPaint = Paint()
      ..color = AppColors.neonCoral
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: headCenter, radius: 8.5),
      math.pi,
      math.pi,
      true,
      capPaint,
    );
    canvas.drawLine(Offset(headCenter.dx, headCenter.dy - 4), Offset(headCenter.dx + 12, headCenter.dy - 2), capPaint..strokeWidth = 2.5);

    final shoulder = Offset(cx + 4, hipY - 14);
    canvas.drawLine(shoulder, Offset(cx, hipY), bodyPaint);

    final leg1Angle = math.sin(cycle);
    final knee1 = Offset(cx + math.sin(leg1Angle) * 16, hipY + 16);
    final foot1 = Offset(knee1.dx + math.sin(leg1Angle - 0.4) * 18, groundY - 2);
    canvas.drawLine(Offset(cx, hipY), knee1, accentPaint);
    canvas.drawLine(knee1, foot1, accentPaint);

    final leg2Angle = math.sin(cycle + math.pi);
    final knee2 = Offset(cx + math.sin(leg2Angle) * 16, hipY + 16);
    final foot2 = Offset(knee2.dx + math.sin(leg2Angle - 0.4) * 18, groundY - 2);
    canvas.drawLine(Offset(cx, hipY), knee2, limbPaint);
    canvas.drawLine(knee2, foot2, limbPaint);

    final arm1Angle = math.sin(cycle + math.pi);
    final elbow1 = Offset(shoulder.dx - math.sin(arm1Angle) * 12, shoulder.dy + 8);
    final hand1 = Offset(elbow1.dx + 10, elbow1.dy + 4);
    canvas.drawLine(shoulder, elbow1, limbPaint);
    canvas.drawLine(elbow1, hand1, limbPaint);

    final arm2Angle = math.sin(cycle);
    final elbow2 = Offset(shoulder.dx - math.sin(arm2Angle) * 12, shoulder.dy + 8);
    final hand2 = Offset(elbow2.dx + 10, elbow2.dy + 4);
    canvas.drawLine(shoulder, elbow2, accentPaint);
    canvas.drawLine(elbow2, hand2, accentPaint);
  }

  @override
  bool shouldRepaint(covariant _RunnerPainter oldDelegate) {
    return oldDelegate.runPhase != runPhase;
  }
}
