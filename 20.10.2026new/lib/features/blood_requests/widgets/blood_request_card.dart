import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/widgets/blood_group_chip.dart';
import '../../../../core/widgets/demo_label.dart';

class BloodRequestCard extends StatelessWidget {
  final BloodRequest request;
  final VoidCallback onTap;
  final VoidCallback onPlanDonation;

  const BloodRequestCard({
    super.key,
    required this.request,
    required this.onTap,
    required this.onPlanDonation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color urgencyColor;
    switch (request.urgency) {
      case RequestUrgency.emergency:
        urgencyColor = AppColors.urgent;
        break;
      case RequestUrgency.high:
        urgencyColor = AppColors.warning;
        break;
      case RequestUrgency.normal:
        urgencyColor = AppColors.info;
        break;
    }

    final isExpired = request.isExpired;
    final isFulfilled = request.status == RequestStatus.fulfilled;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top status and urgency row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: urgencyColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: urgencyColor.withAlpha(80),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.priority_high_rounded,
                              size: 12,
                              color: urgencyColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              request.urgency.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: urgencyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '#${request.id.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (isFulfilled)
                    const DemoLabel(text: 'Karşılandı')
                  else if (isExpired)
                    const DemoLabel(text: 'Süresi Doldu')
                  else
                    DemoLabel(
                      text:
                          '${request.demoDistanceKm} km (${AppStrings.sampleDistance})',
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Recipient alias and blood group
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BloodGroupChip(group: request.bloodGroup, size: 42),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.recipientAlias,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${request.district} • ${request.requiredUnits} Ünite İhtiyaç',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Expiry & action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: isExpired
                            ? AppColors.urgent
                            : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Son: ${request.expiresAt.day}.${request.expiresAt.month} ${request.expiresAt.hour.toString().padLeft(2, '0')}:${request.expiresAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isExpired
                              ? AppColors.urgent
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: request.canAcceptDonation
                        ? onPlanDonation
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'Bağış Planla',
                      style: TextStyle(fontSize: 12),
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
