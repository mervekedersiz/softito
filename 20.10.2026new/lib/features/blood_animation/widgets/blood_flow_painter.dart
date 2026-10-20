import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BloodFlowPainter extends CustomPainter {
  final double flowPhase; // 0.0 to 1.0 (repeating cycle)
  final bool isFlowing;
  final Color tubeColor;
  final Color bloodColor;
  final bool isDark;

  BloodFlowPainter({
    required this.flowPhase,
    required this.isFlowing,
    required this.tubeColor,
    required this.bloodColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Inlet entry is at bag top neck
    final inletX = size.width / 2;
    final inletY = size.height * 0.16;

    // Tube path starting from top-left, looping gracefully down into the inlet
    final tubePath = Path();
    tubePath.moveTo(size.width * 0.22, 0);
    tubePath.cubicTo(
      size.width * 0.22,
      size.height * 0.10,
      size.width * 0.38,
      size.height * 0.05,
      inletX,
      inletY,
    );

    // 1. Draw outer transparent silicone tube
    final tubeOuterPaint = Paint()
      ..color = (isDark ? Colors.white24 : AppColors.tubeColor.withAlpha(120))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(tubePath, tubeOuterPaint);

    // 2. Draw inner tube core line
    final tubeInnerPaint = Paint()
      ..color = (isDark ? Colors.black26 : Colors.white60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawPath(tubePath, tubeInnerPaint);

    // 3. Draw blood stream & moving pulses along the path
    final pathMetrics = tubePath.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final metric = pathMetrics.first;
    final totalLength = metric.length;

    if (isFlowing) {
      // Draw 3 moving blood pulse segments along the tube
      const segmentCount = 3;
      const segmentLengthRatio = 0.22;
      final segmentLength = totalLength * segmentLengthRatio;

      for (int i = 0; i < segmentCount; i++) {
        final phaseOffset = (flowPhase + (i / segmentCount)) % 1.0;
        final startDist = phaseOffset * totalLength;
        final endDist = startDist + segmentLength;

        Path extractSegment(double start, double end) {
          return metric.extractPath(start, end);
        }

        final bloodPaint = Paint()
          ..color = AppColors.vibrantRed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

        if (endDist <= totalLength) {
          final seg = extractSegment(startDist, endDist);
          canvas.drawPath(seg, bloodPaint);
        } else {
          // Wrapped around end of path
          final seg1 = extractSegment(startDist, totalLength);
          final seg2 = extractSegment(0, endDist - totalLength);
          canvas.drawPath(seg1, bloodPaint);
          canvas.drawPath(seg2, bloodPaint);
        }

        // Draw a tiny bright droplet head at the front of each segment
        final headDist = (endDist <= totalLength
            ? endDist
            : endDist - totalLength);
        final tangent = metric.getTangentForOffset(headDist);
        if (tangent != null) {
          final dropletPaint = Paint()
            ..color = Colors.white.withAlpha(200)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(tangent.position, 1.8, dropletPaint);
        }
      }
    } else {
      // When not flowing, show subtle resting blood in the tube if partially filled
      final staticBloodPaint = Paint()
        ..color = AppColors.bloodRed.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(tubePath, staticBloodPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BloodFlowPainter oldDelegate) {
    return oldDelegate.flowPhase != flowPhase ||
        oldDelegate.isFlowing != isFlowing ||
        oldDelegate.tubeColor != tubeColor ||
        oldDelegate.bloodColor != bloodColor ||
        oldDelegate.isDark != isDark;
  }
}
