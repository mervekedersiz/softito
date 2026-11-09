import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HydrationStatsRow extends StatelessWidget {
  final int streakDays;
  final int remainingMl;
  final int intakeCount;

  const HydrationStatsRow({
    super.key,
    required this.streakDays,
    required this.remainingMl,
    required this.intakeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          context,
          label: 'Seri',
          value: '$streakDays Gün',
          icon: Icons.bolt_rounded,
          color: AppColors.neonLime,
        ),
        const SizedBox(width: 8),
        _buildStatCard(
          context,
          label: 'Kalan',
          value: '$remainingMl ml',
          icon: Icons.hourglass_bottom_rounded,
          color: AppColors.neonCyan,
        ),
        const SizedBox(width: 8),
        _buildStatCard(
          context,
          label: 'Yudum',
          value: '$intakeCount Kez',
          icon: Icons.emoji_events_rounded,
          color: AppColors.neonOrange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 15),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
