import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/models/donation_record.dart';

class AppointmentSummary extends StatelessWidget {
  final DonationSource source;
  final DonationCenter? center;
  final DateTime? date;
  final String? slot;
  final VoidCallback onOpenEligibilityForm;

  const AppointmentSummary({
    super.key,
    required this.source,
    this.center,
    this.date,
    this.slot,
    required this.onOpenEligibilityForm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Randevu Özeti ve Ön Kontrol',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildRow('Bağış Türü', source.label, isDark),
            const SizedBox(height: 6),
            _buildRow('Merkez', center?.name ?? 'Henüz seçilmedi', isDark),
            const SizedBox(height: 6),
            _buildRow(
              'Tarih & Saat',
              (date != null && slot != null)
                  ? '${date!.day}.${date!.month}.${date!.year} — Saat $slot'
                  : 'Tarih/saat seçilmedi',
              isDark,
            ),
            const Divider(height: 20),
            OutlinedButton.icon(
              onPressed: onOpenEligibilityForm,
              icon: const Icon(Icons.assignment_outlined, size: 18),
              label: const Text('Bağış Ön Bilgi Formunu İncele (İsteğe Bağlı)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
