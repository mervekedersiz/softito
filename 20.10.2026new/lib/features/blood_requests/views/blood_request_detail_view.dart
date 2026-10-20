import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/widgets/blood_group_chip.dart';
import '../../../../core/widgets/demo_label.dart';

class BloodRequestDetailView extends StatelessWidget {
  final BloodRequest request;
  final DemoStore store;
  final VoidCallback onPlanDonation;

  const BloodRequestDetailView({
    super.key,
    required this.request,
    required this.store,
    required this.onPlanDonation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final center = store.getCenterById(request.centerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(request.recipientAlias),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Kurgusal Talep'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  BloodGroupChip(group: request.bloodGroup, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    request.recipientAlias,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Talep Kodu: #${request.id.toUpperCase()} • ${request.district}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DemoLabel(
                    text:
                        '${request.demoDistanceKm} km (${AppStrings.sampleDistance})',
                    isProminent: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Details List
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    icon: Icons.bloodtype_outlined,
                    label: 'İhtiyaç Miktarı',
                    value: '${request.requiredUnits} Ünite',
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    icon: Icons.priority_high_rounded,
                    label: 'Aciliyet Seviyesi',
                    value: request.urgency.label,
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    icon: Icons.access_time_rounded,
                    label: 'Geçerlilik Bitişi',
                    value:
                        '${request.expiresAt.day}.${request.expiresAt.month}.${request.expiresAt.year} ${request.expiresAt.hour.toString().padLeft(2, '0')}:${request.expiresAt.minute.toString().padLeft(2, '0')}',
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    icon: Icons.local_hospital_outlined,
                    label: 'Bağış Merkezi',
                    value: center?.name ?? 'Belirtilen Merkez',
                  ),
                  if (center != null) ...[
                    const Divider(height: 16),
                    _buildDetailRow(
                      context,
                      icon: Icons.location_on_outlined,
                      label: 'Adres',
                      value: center.address,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Fictional Disclaimer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: AppColors.bloodRed,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${AppStrings.fictionalNotice} Kamu güvenliği ve hasta mahremiyeti gereği gerçek hasta kimliği veya iletişim bilgileri yer almaz.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          ElevatedButton.icon(
            onPressed: request.canAcceptDonation ? onPlanDonation : null,
            icon: const Icon(Icons.calendar_month_rounded),
            label: Text(
              request.canAcceptDonation
                  ? AppStrings.planForThisRequest
                  : (request.isExpired
                        ? 'Talebin Süresi Dolmuştur'
                        : 'Talep Karşılanmıştır'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.bloodRed),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
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
