import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/models/workout_item.dart';

class WorkoutListItem extends StatelessWidget {
  const WorkoutListItem({
    super.key,
    required this.workout,
    required this.onDelete,
  });

  final WorkoutItem workout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _WorkoutIcon(category: workout.category),
          const SizedBox(width: 14),
          Expanded(
            child: _WorkoutDetails(
              title: workout.title,
              category: workout.category,
              durationMinutes: workout.durationMinutes,
            ),
          ),
          _WorkoutStats(
            calories: workout.caloriesBurned,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _WorkoutIcon extends StatelessWidget {
  const _WorkoutIcon({required this.category});

  final String category;

  IconData _resolveIcon() {
    return switch (category.toLowerCase()) {
      'kardiyo' => Icons.directions_run_rounded,
      'ağırlık' => Icons.fitness_center_rounded,
      'esneme' => Icons.self_improvement_rounded,
      _ => Icons.sports_gymnastics_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(_resolveIcon(), color: AppColors.neonLime, size: 24),
    );
  }
}

class _WorkoutDetails extends StatelessWidget {
  const _WorkoutDetails({
    required this.title,
    required this.category,
    required this.durationMinutes,
  });

  final String title;
  final String category;
  final int durationMinutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$category • $durationMinutes dk',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

class _WorkoutStats extends StatelessWidget {
  const _WorkoutStats({
    required this.calories,
    required this.onDelete,
  });

  final int calories;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '-$calories kcal',
          style: const TextStyle(
            color: AppColors.neonCoral,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 18),
          color: AppColors.textMuted,
          visualDensity: VisualDensity.compact,
          onPressed: onDelete,
        ),
      ],
    );
  }
}
