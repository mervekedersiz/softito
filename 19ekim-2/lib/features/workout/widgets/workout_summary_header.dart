import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutSummaryHeader extends StatelessWidget {
  final int completedWorkouts;
  final int totalCalories;
  final int totalMinutes;

  const WorkoutSummaryHeader({
    super.key,
    required this.completedWorkouts,
    required this.totalCalories,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center_rounded, color: AppColors.neonLime, size: 22),
              const SizedBox(width: 8),
              Text(
                'GÜNLÜK ANTRENMAN ÖZETİ',
                style: theme.textTheme.titleSmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.neonLime : AppColors.neonLime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(context, isDark, label: 'Antrenman', value: '$completedWorkouts Seans'),
              Container(width: 1, height: 35, color: isDark ? AppColors.cardBorderDark : AppColors.lightCardBorder),
              _buildMetric(context, isDark, label: 'Süre', value: '$totalMinutes dk'),
              Container(width: 1, height: 35, color: isDark ? AppColors.cardBorderDark : AppColors.lightCardBorder),
              _buildMetric(context, isDark, label: 'Yakılan', value: '$totalCalories kcal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    bool isDark, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
