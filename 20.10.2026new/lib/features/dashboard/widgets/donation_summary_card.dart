import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/donation_record.dart';
import '../../../../core/widgets/demo_label.dart';

class DonationSummaryCard extends StatelessWidget {
  final DonationRecord? nextAppointment;
  final DemoStore store;
  final VoidCallback onBookTap;
  final VoidCallback onManageTap;

  const DonationSummaryCard({
    super.key,
    this.nextAppointment,
    required this.store,
    required this.onBookTap,
    required this.onManageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (nextAppointment == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.nextAppointment,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const DemoLabel(text: 'Randevu'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.noUpcomingAppointment,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onBookTap,
                icon: const Icon(Icons.calendar_month_rounded, size: 18),
                label: const Text(AppStrings.bookDonation),
              ),
            ],
          ),
        ),
      );
    }

    final center = store.getCenterById(nextAppointment!.centerId);
    final d = nextAppointment!.scheduledAt;

    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.softRed.withAlpha(90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.bloodRed, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.event_available_rounded,
                      color: AppColors.bloodRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.nextAppointment,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const DemoLabel(text: 'Aktif Plan'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              center?.name ?? 'Bağış Merkezi',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${d.day}.${d.month}.${d.year} — Saat ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} (${nextAppointment!.source.label})',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onManageTap,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 38),
              ),
              child: const Text('Randevuyu Yönet / İptal Et'),
            ),
          ],
        ),
      ),
    );
  }
}
