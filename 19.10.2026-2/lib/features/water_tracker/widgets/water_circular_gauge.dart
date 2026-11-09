import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterCircularGauge extends StatelessWidget {
  final int currentMl;
  final int goalMl;
  final double progress;

  const WaterCircularGauge({
    super.key,
    required this.currentMl,
    required this.goalMl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final percentage = (progress * 100).toInt();

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundCircle(isDark),
          _buildProgressIndicator(isDark),
          _buildCenterContent(theme, percentage),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircle(bool isDark) {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.cardDark.withValues(alpha: 0.6)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.neonCyan.withValues(alpha: 0.15)
                : AppColors.neonCyan.withValues(alpha: 0.12),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return SizedBox(
      width: 190,
      height: 190,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 14,
        strokeCap: StrokeCap.round,
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : const Color(0xFFE2E8F0),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
      ),
    );
  }

  Widget _buildCenterContent(ThemeData theme, int percentage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop_rounded, color: AppColors.neonCyan, size: 28),
        const SizedBox(height: 4),
        Text(
          '$currentMl',
          style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        Text(
          '/ $goalMl ml ($percentage%)',
          style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
