import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/widgets/demo_label.dart';

class DonationCenterDetailView extends StatelessWidget {
  final DonationCenter center;
  final VoidCallback onPlanBooking;

  const DonationCenterDetailView({
    super.key,
    required this.center,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(center.name),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Kurgusal Merkez'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBlood
                              : AppColors.softRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          color: AppColors.bloodRed,
                          size: 28,
                        ),
                      ),
                      DemoLabel(text: center.district, isProminent: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    center.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Address with Copy Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.bloodRed,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          center.address,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        tooltip: AppStrings.copyAddress,
                        onPressed: () => _copyAddress(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Working Hours
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${AppStrings.workingHours}: ${center.workingHours}',
                        style: TextStyle(
                          fontSize: 13,
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
          ),
          const SizedBox(height: 16),

          // Available Slots Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.availableSlots,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: center.availableSlots.map((slot) {
                      return Chip(
                        label: Text(slot, style: const TextStyle(fontSize: 12)),
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Accepted Donation Types
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kabul Edilen Bağış Türleri',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDonationTypeRow(
                    'Tam Kan Bağışı',
                    'Standart eritrosit ve tam kan alımı',
                  ),
                  const Divider(height: 16),
                  _buildDonationTypeRow(
                    'Trombosit Aferezi',
                    'Özel aferez cihazıyla trombosit alımı',
                  ),
                  const Divider(height: 16),
                  _buildDonationTypeRow(
                    'Plazma Bağışı',
                    'Plazmafraksiyonel bağış kabulü',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: onPlanBooking,
            icon: const Icon(Icons.calendar_month_rounded),
            label: const Text('Bu Merkezde Randevu Al'),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationTypeRow(String title, String desc) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.bloodRed,
          size: 18,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              desc,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
