import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/models/donation_record.dart';
import '../models/donation_booking_state.dart';

class DonationBookingController extends ValueNotifier<DonationBookingState> {
  final DemoStore _store;

  DonationBookingController(
    this._store, {
    BloodRequest? initialRequest,
    DonationCenter? initialCenter,
  }) : super(
         DonationBookingState(
           source: initialRequest != null
               ? DonationSource.specificRequest
               : DonationSource.general,
           selectedRequest: initialRequest,
           selectedCenter:
               initialCenter ??
               (initialRequest != null
                   ? _store.getCenterById(initialRequest.centerId)
                   : null),
           scheduledDate: DateTime.now().add(const Duration(days: 1)),
         ),
       );

  void setSource(DonationSource source) {
    value = value.copyWith(source: source, clearErrorMessage: true);
  }

  void selectRequest(BloodRequest? req) {
    if (req != null) {
      final center = _store.getCenterById(req.centerId);
      value = value.copyWith(
        selectedRequest: req,
        selectedCenter: center ?? value.selectedCenter,
        clearSelectedSlot: true, // Reset slot if center changes
        clearErrorMessage: true,
      );
    } else {
      value = value.copyWith(
        clearSelectedRequest: true,
        clearErrorMessage: true,
      );
    }
  }

  void setPatientReference(String ref) {
    value = value.copyWith(patientReference: ref, clearErrorMessage: true);
  }

  void selectCenter(DonationCenter center) {
    if (value.selectedCenter?.id != center.id) {
      value = value.copyWith(
        selectedCenter: center,
        clearSelectedSlot: true, // Center changed -> clear slot
        clearErrorMessage: true,
      );
    }
  }

  void selectDate(DateTime date) {
    value = value.copyWith(
      scheduledDate: date,
      clearSelectedSlot: true, // Date changed -> clear slot
      clearErrorMessage: true,
    );
  }

  void selectSlot(String slot) {
    value = value.copyWith(selectedSlot: slot, clearErrorMessage: true);
  }

  Future<bool> submitBooking() async {
    if (value.isSubmitting) return false;

    // Check if there is already an active planned appointment
    if (_store.upcomingAppointment != null) {
      value = value.copyWith(
        errorMessage:
            'Zaten aktif bir demo randevunuz bulunmaktadır. Yeni randevu almadan önce mevcut randevuyu tamamlayabilir veya iptal edebilirsiniz.',
      );
      return false;
    }

    if (!value.canSubmit) {
      value = value.copyWith(
        errorMessage:
            'Lütfen merkez, tarih ve saat seçimlerini eksiksiz yapınız.',
      );
      return false;
    }

    value = value.copyWith(isSubmitting: true, clearErrorMessage: true);

    // Parse hour and minute from selected slot (e.g. "10:30")
    int hour = 9;
    int minute = 0;
    if (value.selectedSlot != null && value.selectedSlot!.contains(':')) {
      final parts = value.selectedSlot!.split(':');
      hour = int.tryParse(parts[0]) ?? 9;
      minute = int.tryParse(parts[1]) ?? 0;
    }

    final d = value.scheduledDate!;
    final combinedDateTime = DateTime(d.year, d.month, d.day, hour, minute);

    final record = DonationRecord(
      id: 'donation_${DateTime.now().millisecondsSinceEpoch}',
      centerId: value.selectedCenter!.id,
      requestId: value.source == DonationSource.specificRequest
          ? value.selectedRequest?.id
          : null,
      recipientReference: value.source == DonationSource.patientRef
          ? value.patientReference
          : null,
      scheduledAt: combinedDateTime,
      status: DonationStatus.planned,
      source: value.source,
      trackingEvents: [],
    );

    final added = _store.addDonationRecord(record);
    if (!added) {
      value = value.copyWith(
        isSubmitting: false,
        errorMessage: 'Randevu kaydedilemedi. Zaten aktif bir randevunuz var.',
      );
      return false;
    }

    value = value.copyWith(isSubmitting: false, isSuccess: true);
    return true;
  }
}
