import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HeaderLogoBar extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onToggleTheme;
  final bool isDark;

  const HeaderLogoBar({
    super.key,
    required this.onReset,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/logo.png',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Susadım v1',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.neonLime,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Fitness Hidrasyon Aktif',
                  style: TextStyle(
                    color: AppColors.neonLime,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        // Tema Değiştirme Butonu (Güneş / Ay)
        IconButton.outlined(
          onPressed: onToggleTheme,
          style: IconButton.styleFrom(
            side: BorderSide(
              color: isDarkMode
                  ? AppColors.cardBorderDark
                  : AppColors.lightCardBorder,
            ),
            backgroundColor: isDarkMode
                ? AppColors.cardDark
                : AppColors.lightCard,
          ),
          icon: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDarkMode ? AppColors.neonLime : AppColors.neonCyan,
            size: 20,
          ),
          tooltip: isDarkMode ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
        ),
        const SizedBox(width: 8),
        // Sıfırlama Butonu
        IconButton.outlined(
          onPressed: onReset,
          style: IconButton.styleFrom(
            side: BorderSide(
              color: isDarkMode
                  ? AppColors.cardBorderDark
                  : AppColors.lightCardBorder,
            ),
            backgroundColor: isDarkMode
                ? AppColors.cardDark
                : AppColors.lightCard,
          ),
          icon: Icon(
            Icons.refresh_rounded,
            color: isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            size: 20,
          ),
          tooltip: 'Bugünü Sıfırla',
        ),
      ],
    );
  }
}
