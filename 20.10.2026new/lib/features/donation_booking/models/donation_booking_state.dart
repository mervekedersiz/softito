import '../../../../core/models/blood_request.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/models/donation_record.dart';

class DonationBookingState {
  final DonationSource source;
  final BloodRequest? selectedRequest;
  final String? patientReference;
  final DonationCenter? selectedCenter;
  final DateTime? scheduledDate;
  final String? selectedSlot;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  const DonationBookingState({
    this.source = DonationSource.general,
    this.selectedRequest,
    this.patientReference,
    this.selectedCenter,
    this.scheduledDate,
    this.selectedSlot,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  bool get canSubmit {
    if (isSubmitting) {
      return false;
    }
    if (selectedCenter == null) {
      return false;
    }
    if (scheduledDate == null) {
      return false;
    }
    if (selectedSlot == null || selectedSlot!.isEmpty) {
      return false;
    }
    if (source == DonationSource.specificRequest && selectedRequest == null) {
      return false;
    }
    if (source == DonationSource.patientRef &&
        (patientReference == null || patientReference!.trim().isEmpty)) {
      return false;
    }
    return true;
  }

  DonationBookingState copyWith({
    DonationSource? source,
    BloodRequest? selectedRequest,
    bool clearSelectedRequest = false,
    String? patientReference,
    bool clearPatientReference = false,
    DonationCenter? selectedCenter,
    bool clearSelectedCenter = false,
    DateTime? scheduledDate,
    bool clearScheduledDate = false,
    String? selectedSlot,
    bool clearSelectedSlot = false,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSuccess,
  }) {
    return DonationBookingState(
      source: source ?? this.source,
      selectedRequest: clearSelectedRequest
          ? null
          : (selectedRequest ?? this.selectedRequest),
      patientReference: clearPatientReference
          ? null
          : (patientReference ?? this.patientReference),
      selectedCenter: clearSelectedCenter
          ? null
          : (selectedCenter ?? this.selectedCenter),
      scheduledDate: clearScheduledDate
          ? null
          : (scheduledDate ?? this.scheduledDate),
      selectedSlot: clearSelectedSlot
          ? null
          : (selectedSlot ?? this.selectedSlot),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
