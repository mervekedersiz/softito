import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/widgets/demo_label.dart';

class DonationCenterCard extends StatelessWidget {
  final DonationCenter center;
  final VoidCallback onTap;
  final VoidCallback onPlanBooking;

  const DonationCenterCard({
    super.key,
    required this.center,
    required this.onTap,
    required this.onPlanBooking,
  });

  void _copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: center.address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.addressCopied),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              // Title and district tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      center.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DemoLabel(text: center.district),
                ],
              ),
              const SizedBox(height: 8),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.bloodRed,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      center.address,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    tooltip: AppStrings.copyAddress,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _copyAddress(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Working Hours
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 15,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    center.workingHours,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: onPlanBooking,
                    icon: const Icon(Icons.calendar_month_rounded, size: 16),
                    label: const Text(
                      'Bu Merkezde Randevu Al',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(180, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
