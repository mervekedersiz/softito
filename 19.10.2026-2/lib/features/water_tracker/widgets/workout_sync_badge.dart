import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutSyncBadge extends StatelessWidget {
  final int burnedCalories;
  final int workoutMinutes;
  final VoidCallback onLogQuickWorkout;

  const WorkoutSyncBadge({
    super.key,
    required this.burnedCalories,
    required this.workoutMinutes,
    required this.onLogQuickWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.cardBorderDark
              : AppColors.lightCardBorder,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.neonOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.neonOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fitness Hidrasyon Senkronu',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$workoutMinutes dk antrenman • $burnedCalories kcal',
                  style: const TextStyle(
                    color: AppColors.neonLime,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onLogQuickWorkout,
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.surfaceDark
                  : const Color(0xFFF1F5F9),
              foregroundColor: AppColors.neonCyan,
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            tooltip: '+15 dk Antrenman Ekle',
          ),
        ],
      ),
    );
  }
}
