import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/donor_badge.dart';

class DonorBadgeCard extends StatelessWidget {
  final DonorBadge badge;

  const DonorBadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEarned = badge.isEarned;

    IconData icon;
    switch (badge.iconCode) {
      case 'share':
        icon = Icons.campaign_rounded;
        break;
      case 'stars':
        icon = Icons.military_tech_rounded;
        break;
      case 'favorite':
      default:
        icon = Icons.volunteer_activism_rounded;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isEarned
          ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
          : (isDark
                ? AppColors.darkSurfaceSubtle
                : AppColors.lightSurfaceSubtle),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isEarned
              ? AppColors.bloodRed.withAlpha(100)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isEarned ? 1.2 : 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isEarned
                    ? AppColors.bloodRed
                    : (isDark ? Colors.white12 : Colors.black12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isEarned ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        badge.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isEarned
                              ? AppColors.successContainer
                              : (isDark ? Colors.white10 : Colors.black12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isEarned ? 'Kazanıldı' : 'Kilitli',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isEarned ? AppColors.success : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Koşul: ${badge.criteria}',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  if (isEarned && badge.earnedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Kazanılma Tarihi: ${badge.earnedAt!.day}.${badge.earnedAt!.month}.${badge.earnedAt!.year}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bloodRed,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
