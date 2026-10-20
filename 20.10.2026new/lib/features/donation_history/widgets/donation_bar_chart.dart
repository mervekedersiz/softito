import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/donation_history_state.dart';

class DonationBarChart extends StatelessWidget {
  final List<MonthlyDonationCount> monthlyData;
  final double height;

  const DonationBarChart({
    super.key,
    required this.monthlyData,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, height),
          painter: _BarChartPainter(monthlyData: monthlyData, isDark: isDark),
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MonthlyDonationCount> monthlyData;
  final bool isDark;

  _BarChartPainter({required this.monthlyData, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (monthlyData.isEmpty) return;

    const paddingLeft = 32.0;
    const paddingRight = 16.0;
    const paddingTop = 20.0;
    const paddingBottom = 28.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    // Find max value, minimum 2 for clear visual scale
    int maxCount = 2;
    for (final d in monthlyData) {
      if (d.count > maxCount) maxCount = d.count;
    }

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white12 : Colors.black12)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw 3 horizontal grid lines (0, max/2, max)
    for (int i = 0; i <= 2; i++) {
      final y = paddingTop + (i / 2) * chartHeight;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      final val = (maxCount - (i / 2) * maxCount).round();
      textPainter.text = TextSpan(
        text: '$val',
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

    // Draw Bars
    final barCount = monthlyData.length;
    final slotWidth = chartWidth / barCount;
    final barWidth = math.min(slotWidth * 0.45, 28.0);

    for (int i = 0; i < barCount; i++) {
      final item = monthlyData[i];
      final centerX = paddingLeft + i * slotWidth + slotWidth / 2;

      // Draw Month Label on X axis
      textPainter.text = TextSpan(
        text: item.monthName,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          size.height - paddingBottom + 8,
        ),
      );

      // Draw Bar
      if (item.count > 0) {
        final barHeight = (item.count / maxCount) * chartHeight;
        final barTop = paddingTop + (chartHeight - barHeight);
        final barRect = Rect.fromCenter(
          center: Offset(centerX, barTop + barHeight / 2),
          width: barWidth,
          height: barHeight,
        );

        final barGradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark ? AppColors.vibrantRed : AppColors.bloodRed,
            AppColors.deepCrimson,
          ],
        );

        final barPaint = Paint()
          ..shader = barGradient.createShader(barRect)
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
          RRect.fromRectAndCorners(
            barRect,
            topLeft: const Radius.circular(6),
            topRight: const Radius.circular(6),
          ),
          barPaint,
        );

        // Value text on top of bar
        textPainter.text = TextSpan(
          text: '${item.count}',
          style: TextStyle(
            color: isDark ? AppColors.vibrantRed : AppColors.bloodRed,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            centerX - textPainter.width / 2,
            barTop - textPainter.height - 3,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.monthlyData != monthlyData ||
        oldDelegate.isDark != isDark;
  }
}
