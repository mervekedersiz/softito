import '../../../../core/models/donation_record.dart';

class MonthlyDonationCount {
  final int month; // 1-12
  final int year;
  final int count;

  const MonthlyDonationCount({
    required this.month,
    required this.year,
    required this.count,
  });

  String get monthName {
    const months = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    if (month >= 1 && month <= 12) return months[month];
    return '$month';
  }
}

class DonationHistoryState {
  final List<DonationRecord> allDonations;
  final DonationStatus? filterStatus;
  final DonationRecord? selectedDonation;

  const DonationHistoryState({
    required this.allDonations,
    this.filterStatus,
    this.selectedDonation,
  });

  List<DonationRecord> get filteredDonations {
    if (filterStatus == null) return allDonations;
    return allDonations.where((d) => d.status == filterStatus).toList();
  }

  List<DonationRecord> get completedDonations =>
      allDonations.where((d) => d.isCompleted).toList();

  List<DonationRecord> get plannedDonations =>
      allDonations.where((d) => d.isPlanned).toList();

  List<DonationRecord> get cancelledDonations =>
      allDonations.where((d) => d.isCancelled).toList();

  /// Calculates monthly completed donation counts over the last 6 months for bar chart
  List<MonthlyDonationCount> get monthlyCompletedCounts {
    final now = DateTime.now();
    final result = <MonthlyDonationCount>[];

    // Build last 6 months list
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final count = completedDonations.where((d) {
        final dDate = d.completedAt ?? d.scheduledAt;
        return dDate.year == date.year && dDate.month == date.month;
      }).length;

      result.add(
        MonthlyDonationCount(month: date.month, year: date.year, count: count),
      );
    }

    return result;
  }

  DonationHistoryState copyWith({
    List<DonationRecord>? allDonations,
    DonationStatus? filterStatus,
    bool clearFilterStatus = false,
    DonationRecord? selectedDonation,
    bool clearSelectedDonation = false,
  }) {
    return DonationHistoryState(
      allDonations: allDonations ?? this.allDonations,
      filterStatus: clearFilterStatus
          ? null
          : (filterStatus ?? this.filterStatus),
      selectedDonation: clearSelectedDonation
          ? null
          : (selectedDonation ?? this.selectedDonation),
    );
  }
}
