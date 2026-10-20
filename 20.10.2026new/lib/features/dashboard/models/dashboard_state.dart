import '../../../../core/models/blood_request.dart';
import '../../../../core/models/donation_record.dart';
import '../../../../core/models/donor_badge.dart';
import '../../../../core/models/donor_profile.dart';
import '../../donation_history/models/donation_history_state.dart';

class DashboardState {
  final DonorProfile profile;
  final DonationRecord? nextAppointment;
  final int completedDonationsCount;
  final List<BloodRequest> nearbyRequests;
  final DonorBadge? lastEarnedBadge;
  final List<MonthlyDonationCount> monthlyDonations;

  const DashboardState({
    required this.profile,
    this.nextAppointment,
    required this.completedDonationsCount,
    required this.nearbyRequests,
    this.lastEarnedBadge,
    required this.monthlyDonations,
  });

  DashboardState copyWith({
    DonorProfile? profile,
    DonationRecord? nextAppointment,
    bool clearNextAppointment = false,
    int? completedDonationsCount,
    List<BloodRequest>? nearbyRequests,
    DonorBadge? lastEarnedBadge,
    bool clearLastEarnedBadge = false,
    List<MonthlyDonationCount>? monthlyDonations,
  }) {
    return DashboardState(
      profile: profile ?? this.profile,
      nextAppointment: clearNextAppointment
          ? null
          : (nextAppointment ?? this.nextAppointment),
      completedDonationsCount:
          completedDonationsCount ?? this.completedDonationsCount,
      nearbyRequests: nearbyRequests ?? this.nearbyRequests,
      lastEarnedBadge: clearLastEarnedBadge
          ? null
          : (lastEarnedBadge ?? this.lastEarnedBadge),
      monthlyDonations: monthlyDonations ?? this.monthlyDonations,
    );
  }
}
