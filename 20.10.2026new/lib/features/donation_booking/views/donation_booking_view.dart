import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/widgets/demo_label.dart';
import '../../eligibility/views/eligibility_view.dart';
import '../controllers/donation_booking_controller.dart';
import '../models/donation_booking_state.dart';
import '../widgets/appointment_summary.dart';
import '../widgets/recipient_form.dart';

class DonationBookingView extends StatelessWidget {
  final DonationBookingController controller;
  final DemoStore store;

  const DonationBookingView({
    super.key,
    required this.controller,
    required this.store,
  });

  Future<void> _pickDate(
    BuildContext context,
    DonationBookingState state,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.scheduledDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookingTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Demo Randevu'),
          ),
        ],
      ),
      body: ValueListenableBuilder<DonationBookingState>(
        valueListenable: controller,
        builder: (context, state, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Step 1: Recipient Form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: RecipientForm(
                    source: state.source,
                    onSourceChanged: (s) => controller.setSource(s),
                    availableRequests: store.requests.toList(),
                    selectedRequest: state.selectedRequest,
                    onRequestChanged: (r) => controller.selectRequest(r),
                    patientReference: state.patientReference,
                    onReferenceChanged: (ref) =>
                        controller.setPatientReference(ref),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Step 2: Center Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2. Bağış Noktası Seçimi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<DonationCenter>(
                        initialValue: state.selectedCenter,
                        decoration: const InputDecoration(
                          labelText: 'Bağış Merkezi',
                        ),
                        items: store.centers.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(
                              '${c.name} (${c.district})',
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectCenter(val);
                        },
                      ),
                      if (state.selectedCenter != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Adres: ${state.selectedCenter!.address}',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Step 3 & 4: Date & Available Slot Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3. Tarih ve Saat Seçimi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Date picker trigger
                      InkWell(
                        onTap: () => _pickDate(context, state),
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Randevu Tarihi',
                            suffixIcon: Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                            ),
                          ),
                          child: Text(
                            state.scheduledDate != null
                                ? '${state.scheduledDate!.day}.${state.scheduledDate!.month}.${state.scheduledDate!.year}'
                                : 'Tarih seçiniz',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Müsait Randevu Saatleri',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (state.selectedCenter == null)
                        Text(
                          'Saatleri görmek için önce bağış merkezi seçiniz.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.selectedCenter!.availableSlots.map((
                            slot,
                          ) {
                            final isSelected = state.selectedSlot == slot;
                            return ChoiceChip(
                              label: Text(slot),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) controller.selectSlot(slot);
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Step 5: Summary & Eligibility Access
              AppointmentSummary(
                source: state.source,
                center: state.selectedCenter,
                date: state.scheduledDate,
                slot: state.selectedSlot,
                onOpenEligibilityForm: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => EligibilityView(store: store),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Error display
              if (state.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.urgentContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.urgent.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.urgent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.urgent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Submit Button
              ElevatedButton.icon(
                onPressed: state.isSubmitting
                    ? null
                    : () async {
                        final success = await controller.submitBooking();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.bookingConfirmed),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                icon: state.isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  state.isSubmitting
                      ? 'Kaydediliyor...'
                      : 'Demo Randevuyu Kaydet',
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
