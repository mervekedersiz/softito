import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/models/donation_record.dart';

class RecipientForm extends StatelessWidget {
  final DonationSource source;
  final ValueChanged<DonationSource> onSourceChanged;
  final List<BloodRequest> availableRequests;
  final BloodRequest? selectedRequest;
  final ValueChanged<BloodRequest?> onRequestChanged;
  final String? patientReference;
  final ValueChanged<String> onReferenceChanged;

  const RecipientForm({
    super.key,
    required this.source,
    required this.onSourceChanged,
    required this.availableRequests,
    this.selectedRequest,
    required this.onRequestChanged,
    this.patientReference,
    required this.onReferenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Bağış Amacı ve Alıcı Bilgisi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Type selection radios / segments
        SegmentedButton<DonationSource>(
          segments: const [
            ButtonSegment(
              value: DonationSource.general,
              label: Text('Genel Bağış', style: TextStyle(fontSize: 11.5)),
            ),
            ButtonSegment(
              value: DonationSource.specificRequest,
              label: Text('Mevcut Talep', style: TextStyle(fontSize: 11.5)),
            ),
            ButtonSegment(
              value: DonationSource.patientRef,
              label: Text('Hasta Adına', style: TextStyle(fontSize: 11.5)),
            ),
          ],
          selected: {source},
          onSelectionChanged: (set) => onSourceChanged(set.first),
        ),
        const SizedBox(height: 12),

        // Conditional forms based on source
        if (source == DonationSource.specificRequest) ...[
          DropdownButtonFormField<BloodRequest>(
            initialValue: selectedRequest,
            decoration: const InputDecoration(
              labelText: 'İlgili Kan Talebini Seçin',
            ),
            items: availableRequests.where((r) => r.canAcceptDonation).map((r) {
              return DropdownMenuItem(
                value: r,
                child: Text(
                  '${r.recipientAlias} (${r.bloodGroup.label} - ${r.district})',
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: onRequestChanged,
          ),
          const SizedBox(height: 8),
        ] else if (source == DonationSource.patientRef) ...[
          TextFormField(
            initialValue: patientReference,
            decoration: const InputDecoration(
              labelText: 'Hasta / Başvuru Dosya Numarası',
              hintText: 'Örn: HST-2026-9812',
            ),
            onChanged: onReferenceChanged,
          ),
          const SizedBox(height: 8),
        ],

        // Transparency disclaimer about direct delivery vs pooled distribution
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceSubtle
                : AppColors.softRed.withAlpha(80),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder
                  : AppColors.bloodRed.withAlpha(60),
              width: 0.8,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.bloodRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.recipientNotice,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
