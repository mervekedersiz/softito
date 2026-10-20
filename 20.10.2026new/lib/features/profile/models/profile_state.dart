import '../../../../core/models/donor_badge.dart';
import '../../../../core/models/donor_profile.dart';

class ProfileState {
  final DonorProfile profile;
  final List<DonorBadge> badges;
  final int completedDonationsCount;
  final DateTime? lastDonationDate;

  const ProfileState({
    required this.profile,
    required this.badges,
    required this.completedDonationsCount,
    this.lastDonationDate,
  });

  ProfileState copyWith({
    DonorProfile? profile,
    List<DonorBadge>? badges,
    int? completedDonationsCount,
    DateTime? lastDonationDate,
    bool clearLastDonationDate = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      badges: badges ?? this.badges,
      completedDonationsCount:
          completedDonationsCount ?? this.completedDonationsCount,
      lastDonationDate: clearLastDonationDate
          ? null
          : (lastDonationDate ?? this.lastDonationDate),
    );
  }
}
