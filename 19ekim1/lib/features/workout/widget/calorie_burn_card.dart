import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class CalorieBurnCard extends StatelessWidget {
  const CalorieBurnCard({
    super.key,
    required this.caloriesBurned,
    required this.calorieGoal,
    required this.totalMinutes,
    required this.progress,
  });

  final int caloriesBurned;
  final int calorieGoal;
  final int totalMinutes;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalorieHeader(
            caloriesBurned: caloriesBurned,
            calorieGoal: calorieGoal,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCoral),
            ),
          ),
          const SizedBox(height: 12),
          _CalorieFooter(totalMinutes: totalMinutes, progress: progress),
        ],
      ),
    );
  }
}

class _CalorieHeader extends StatelessWidget {
  const _CalorieHeader({
    required this.caloriesBurned,
    required this.calorieGoal,
  });

  final int caloriesBurned;
  final int calorieGoal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yakılan Kalori',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              '$caloriesBurned kcal',
              style: const TextStyle(
                color: AppColors.neonCoral,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            'Hedef: $calorieGoal kcal',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CalorieFooter extends StatelessWidget {
  const _CalorieFooter({
    required this.totalMinutes,
    required this.progress,
  });

  final int totalMinutes;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Toplam Süre: $totalMinutes dk',
          style: const TextStyle(color: AppColors.neonLime, fontSize: 13),
        ),
        Text(
          '%$percentage tamamlandı',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}
