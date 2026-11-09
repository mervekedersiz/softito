import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class WaterProgressIndicator extends StatelessWidget {
  const WaterProgressIndicator({
    super.key,
    required this.progress,
    required this.drankMl,
    required this.goalMl,
  });

  final double progress;
  final int drankMl;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 14,
                backgroundColor: AppColors.surfaceLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
                strokeCap: StrokeCap.round,
              ),
            ),
            _ProgressInfo(
              percentage: percentage,
              drankMl: drankMl,
              goalMl: goalMl,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  const _ProgressInfo({
    required this.percentage,
    required this.drankMl,
    required this.goalMl,
  });

  final int percentage;
  final int drankMl;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop_rounded, color: AppColors.neonCyan, size: 36),
        const SizedBox(height: 4),
        Text(
          '$drankMl ml',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Hedef: $goalMl ml (%$percentage)',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
