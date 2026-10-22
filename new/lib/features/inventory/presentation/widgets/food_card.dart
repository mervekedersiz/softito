import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_status.dart';
import '../../../../core/widgets/food_thumbnail.dart';
import '../../domain/entities/food_item.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onConsume;
  final VoidCallback onWaste;

  const FoodCard({
    super.key,
    required this.food,
    required this.onConsume,
    required this.onWaste,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final urgency = classifyDate(now, food.expiryDate);
    final daysLeft = daysRemaining(now, food.expiryDate);

    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    switch (urgency) {
      case UrgencyStatus.expired:
        badgeBg = AppColors.dangerBg;
        badgeText = AppColors.danger;
        badgeLabel = 'Tarihi Geçti';
        break;
      case UrgencyStatus.today:
        badgeBg = AppColors.dangerBg;
        badgeText = AppColors.danger;
        badgeLabel = 'Bugün (Son Gün)';
        break;
      case UrgencyStatus.urgent:
        badgeBg = AppColors.warningBg;
        badgeText = AppColors.warning;
        badgeLabel = '$daysLeft Gün Kaldı';
        break;
      case UrgencyStatus.upcoming:
        badgeBg = AppColors.warningBg;
        badgeText = AppColors.warning;
        badgeLabel = '$daysLeft Gün Kaldı';
        break;
      case UrgencyStatus.safe:
        badgeBg = AppColors.safeBg;
        badgeText = AppColors.safe;
        badgeLabel = '6+ Gün Var';
        break;
    }

    Color borderAccent;
    IconData locIcon;
    switch (food.storageLocation) {
      case StorageLocation.fridge:
        borderAccent = const Color(0xFF007A4D);
        locIcon = Icons.kitchen;
        break;
      case StorageLocation.freezer:
        borderAccent = const Color(0xFF0A84FF);
        locIcon = Icons.ac_unit;
        break;
      case StorageLocation.pantry:
        borderAccent = const Color(0xFFC86D24);
        locIcon = Icons.shelves;
        break;
    }

    IconData foodTypeIcon;
    switch (food.category) {
      case FoodCategory.dairy:
        foodTypeIcon = Icons.water_drop_outlined;
        break;
      case FoodCategory.meat:
        foodTypeIcon = Icons.set_meal_outlined;
        break;
      case FoodCategory.produce:
        foodTypeIcon = Icons.eco_outlined;
        break;
      case FoodCategory.pantry:
        foodTypeIcon = Icons.inventory_2_outlined;
        break;
      case FoodCategory.other:
        foodTypeIcon = Icons.restaurant_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left color strip
              Container(
                width: 5,
                color: borderAccent,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.push('/products/${food.id}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FoodThumbnail(
                              foodName: food.name,
                              category: food.category,
                              size: 44,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(locIcon,
                                          size: 13,
                                          color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${food.storageLocation.label} • ${food.subLocation.isNotEmpty ? food.subLocation : '${food.quantity.toStringAsFixed(0)} ${food.unit}'}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (urgency == UrgencyStatus.today ||
                                      urgency == UrgencyStatus.expired)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Icon(Icons.error_outline,
                                          size: 12, color: badgeText),
                                    )
                                  else if (urgency == UrgencyStatus.urgent)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Icon(Icons.access_time,
                                          size: 12, color: badgeText),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Icon(Icons.shield_outlined,
                                          size: 12, color: badgeText),
                                    ),
                                  Text(
                                    badgeLabel,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: badgeText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Icon(
                                foodTypeIcon,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceMuted,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          food.dateType.label,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormatter.toTurkishDate(
                                            food.expiryDate),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: urgency == UrgencyStatus.today
                                              ? AppColors.danger
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    food.note?.isNotEmpty == true
                                        ? food.note!
                                        : (food.packageStatus ==
                                                PackageStatus.opened
                                            ? 'Açılmış Paket'
                                            : 'Kapalı Ambalaj'),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Consume button
                                InkWell(
                                  onTap: onConsume,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF005A36),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Waste button
                                InkWell(
                                  onTap: onWaste,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.dangerBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: AppColors.danger,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
