import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuickAddBar extends StatelessWidget {
  final void Function(int amount) onAdd;

  const QuickAddBar({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HIZLI SU EKLE',
              style: theme.textTheme.titleSmall?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
            ),
            const Icon(Icons.flash_on_rounded, color: AppColors.neonLime, size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildItem(context, isDark, amount: 200, label: 'Bardak', icon: Icons.local_cafe_rounded),
            const SizedBox(width: 8),
            _buildItem(context, isDark, amount: 330, label: 'Küçük Şişe', icon: Icons.local_drink_rounded),
            const SizedBox(width: 8),
            _buildItem(context, isDark, amount: 500, label: 'Shaker', icon: Icons.sports_gymnastics_rounded),
            const SizedBox(width: 8),
            _buildItem(context, isDark, amount: 750, label: 'Matara', icon: Icons.fitness_center_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context,
    bool isDark, {
    required int amount,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onAdd(amount),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.lightCard,
            borderRadius: BorderRadius.circular(16),
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
          child: Column(
            children: [
              Icon(icon, color: AppColors.neonCyan, size: 22),
              const SizedBox(height: 6),
              Text(
                '+$amount',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ml',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
