import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/blood_measurement.dart';

class BloodValueChart extends StatelessWidget {
  final List<BloodMeasurement> measurements;
  final BloodMeasurement? selectedMeasurement;
  final ValueChanged<BloodMeasurement?> onSelect;
  final double height;

  const BloodValueChart({
    super.key,
    required this.measurements,
    this.selectedMeasurement,
    required this.onSelect,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (measurements.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Henüz bu gösterge için kayıtlı ölçüm bulunmuyor.',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            _handleTap(
              details.localPosition,
              Size(constraints.maxWidth, height),
            );
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, height),
            painter: _ChartPainter(
              measurements: measurements,
              selectedMeasurement: selectedMeasurement,
              isDark: isDark,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset localPos, Size size) {
    if (measurements.isEmpty) return;
    const paddingLeft = 44.0;
    const paddingRight = 20.0;
    const paddingTop = 24.0;
    const paddingBottom = 32.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    double minVal = measurements.map((m) => m.value).reduce(math.min);
    double maxVal = measurements.map((m) => m.value).reduce(math.max);
    if ((maxVal - minVal).abs() < 0.001) {
      minVal -= 1.0;
      maxVal += 1.0;
    }

    BloodMeasurement? closest;
    double closestDist = 40.0; // Touch threshold in px

    for (int i = 0; i < measurements.length; i++) {
      final m = measurements[i];
      final double x;
      if (measurements.length == 1) {
        x = paddingLeft + chartWidth / 2;
      } else {
        x = paddingLeft + (i / (measurements.length - 1)) * chartWidth;
      }
      final normY = (m.value - minVal) / (maxVal - minVal);
      final y = paddingTop + (1.0 - normY) * chartHeight;

      final dist = (Offset(x, y) - localPos).distance;
      if (dist < closestDist) {
        closestDist = dist;
        closest = m;
      }
    }

    onSelect(closest);
  }
}

class _ChartPainter extends CustomPainter {
  final List<BloodMeasurement> measurements;
  final BloodMeasurement? selectedMeasurement;
  final bool isDark;

  _ChartPainter({
    required this.measurements,
    required this.selectedMeasurement,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const paddingLeft = 44.0;
    const paddingRight = 20.0;
    const paddingTop = 24.0;
    const paddingBottom = 32.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    if (chartWidth <= 0 || chartHeight <= 0 || measurements.isEmpty) return;

    double minVal = measurements.map((m) => m.value).reduce(math.min);
    double maxVal = measurements.map((m) => m.value).reduce(math.max);

    // Guard against zero difference / single value division by zero
    if ((maxVal - minVal).abs() < 0.0001) {
      final pad = minVal == 0 ? 1.0 : (minVal.abs() * 0.2);
      minVal -= pad;
      maxVal += pad;
    } else {
      // Add a 10% vertical padding so points don't hit exact edges
      final range = maxVal - minVal;
      minVal -= range * 0.1;
      maxVal += range * 0.1;
    }

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white12 : Colors.black12)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw horizontal grid lines and Y-axis labels
    const gridLines = 3;
    for (int i = 0; i <= gridLines; i++) {
      final y = paddingTop + (i / gridLines) * chartHeight;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      final val = maxVal - (i / gridLines) * (maxVal - minVal);
      textPainter.text = TextSpan(
        text: val.toStringAsFixed(1),
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 6, y - 6),
      );
    }

    // Compute coordinate points
    final points = <Offset>[];
    for (int i = 0; i < measurements.length; i++) {
      final m = measurements[i];
      final double x;
      if (measurements.length == 1) {
        x = paddingLeft + chartWidth / 2;
      } else {
        x = paddingLeft + (i / (measurements.length - 1)) * chartWidth;
      }
      final normY = (m.value - minVal) / (maxVal - minVal);
      final y = paddingTop + (1.0 - normY) * chartHeight;
      points.add(Offset(x, y));

      // Draw date on X-axis
      final dateStr = '${m.measuredAt.day}.${m.measuredAt.month}';
      textPainter.text = TextSpan(
        text: dateStr,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - paddingBottom + 8),
      );
    }

    // Draw Line and Gradient Area (if multiple points)
    if (points.length > 1) {
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        linePath.lineTo(points[i].dx, points[i].dy);
      }

      // Fill area under line
      final areaPath = Path.from(linePath);
      areaPath.lineTo(points.last.dx, paddingTop + chartHeight);
      areaPath.lineTo(points.first.dx, paddingTop + chartHeight);
      areaPath.close();

      final areaGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.bloodRed.withAlpha(isDark ? 60 : 40),
          AppColors.bloodRed.withAlpha(0),
        ],
      );

      final areaPaint = Paint()
        ..shader = areaGradient.createShader(
          Rect.fromLTRB(
            paddingLeft,
            paddingTop,
            size.width - paddingRight,
            paddingTop + chartHeight,
          ),
        )
        ..style = PaintingStyle.fill;
      canvas.drawPath(areaPath, areaPaint);

      final linePaint = Paint()
        ..color = isDark ? AppColors.vibrantRed : AppColors.bloodRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(linePath, linePaint);
    }

    // Draw point dots
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      final m = measurements[i];
      final isSelected = selectedMeasurement?.id == m.id;

      if (isSelected) {
        // Outer selection ring
        final ringPaint = Paint()
          ..color = AppColors.bloodRed.withAlpha(80)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 10, ringPaint);
      }

      final dotBgPaint = Paint()
        ..color = isDark ? AppColors.darkSurface : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt, isSelected ? 6 : 4.5, dotBgPaint);

      final dotPaint = Paint()
        ..color = isDark ? AppColors.vibrantRed : AppColors.bloodRed
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt, isSelected ? 4.5 : 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.measurements != measurements ||
        oldDelegate.selectedMeasurement != selectedMeasurement ||
        oldDelegate.isDark != isDark;
  }
}
