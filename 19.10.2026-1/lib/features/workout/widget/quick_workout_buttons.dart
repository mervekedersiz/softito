import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class QuickWorkoutButtons extends StatelessWidget {
  const QuickWorkoutButtons({
    super.key,
    required this.onAddQuickWorkout,
  });

  final void Function({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) onAddQuickWorkout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Antrenman Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _QuickWorkoutChip(
                label: '15 dk HIIT',
                category: 'Kardiyo',
                calories: 150,
                duration: 15,
                icon: Icons.flash_on_rounded,
                accentColor: AppColors.neonCoral,
                onTap: () => onAddQuickWorkout(
                  title: 'Hızlı HIIT',
                  category: 'Kardiyo',
                  durationMinutes: 15,
                  caloriesBurned: 150,
                ),
              ),
              const SizedBox(width: 10),
              _QuickWorkoutChip(
                label: '30 dk Ağırlık',
                category: 'Ağırlık',
                calories: 220,
                duration: 30,
                icon: Icons.fitness_center_rounded,
                accentColor: AppColors.neonLime,
                onTap: () => onAddQuickWorkout(
                  title: 'Kuvvet Antrenmanı',
                  category: 'Ağırlık',
                  durationMinutes: 30,
                  caloriesBurned: 220,
                ),
              ),
              const SizedBox(width: 10),
              _QuickWorkoutChip(
                label: '20 dk Koşu',
                category: 'Kardiyo',
                calories: 190,
                duration: 20,
                icon: Icons.directions_run_rounded,
                accentColor: AppColors.neonCyan,
                onTap: () => onAddQuickWorkout(
                  title: 'Tempolu Koşu',
                  category: 'Kardiyo',
                  durationMinutes: 20,
                  caloriesBurned: 190,
                ),
              ),
              const SizedBox(width: 10),
              _QuickWorkoutChip(
                label: '15 dk Esneme',
                category: 'Esneme',
                calories: 70,
                duration: 15,
                icon: Icons.self_improvement_rounded,
                accentColor: AppColors.neonPurple,
                onTap: () => onAddQuickWorkout(
                  title: 'Mobilite & Esneme',
                  category: 'Esneme',
                  durationMinutes: 15,
                  caloriesBurned: 70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickWorkoutChip extends StatelessWidget {
  const _QuickWorkoutChip({
    required this.label,
    required this.category,
    required this.calories,
    required this.duration,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final String category;
  final int calories;
  final int duration;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: accentColor, size: 18),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '+$calories kcal',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
