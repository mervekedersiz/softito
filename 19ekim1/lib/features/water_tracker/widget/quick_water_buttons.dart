import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class QuickWaterButtons extends StatelessWidget {
  const QuickWaterButtons({
    super.key,
    required this.onAddWater,
  });

  final ValueChanged<int> onAddWater;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickButton(
          amount: 200,
          label: 'Bardak',
          icon: Icons.local_drink_rounded,
          onTap: () => onAddWater(200),
        ),
        _QuickButton(
          amount: 300,
          label: 'Kupa',
          icon: Icons.coffee_rounded,
          onTap: () => onAddWater(300),
        ),
        _QuickButton(
          amount: 500,
          label: 'Şişe',
          icon: Icons.sports_gymnastics_rounded,
          onTap: () => onAddWater(500),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          width: 95,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.neonCyan, size: 24),
              const SizedBox(height: 6),
              Text(
                '+$amount ml',
                style: const TextStyle(
                  color: AppColors.neonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
