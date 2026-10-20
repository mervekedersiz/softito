import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/models/donor_badge.dart';
import '../../donation_history/models/donation_history_state.dart';
import '../models/dashboard_state.dart';

class DashboardController extends ValueNotifier<DashboardState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  DashboardController(this._store)
    : super(
        DashboardState(
          profile: _store.profile,
          nextAppointment: _store.upcomingAppointment,
          completedDonationsCount: _store.completedDonationsCount,
          nearbyRequests: _extractNearbyRequests(_store),
          lastEarnedBadge: _findLastEarnedBadge(_store),
          monthlyDonations: _extractMonthlyDonations(_store),
        ),
      ) {
    _storeListener = () {
      value = value.copyWith(
        profile: _store.profile,
        nextAppointment: _store.upcomingAppointment,
        clearNextAppointment: _store.upcomingAppointment == null,
        completedDonationsCount: _store.completedDonationsCount,
        nearbyRequests: _extractNearbyRequests(_store),
        lastEarnedBadge: _findLastEarnedBadge(_store),
        clearLastEarnedBadge: _findLastEarnedBadge(_store) == null,
        monthlyDonations: _extractMonthlyDonations(_store),
      );
    };
    _store.addListener(_storeListener);
  }

  static List<BloodRequest> _extractNearbyRequests(DemoStore store) {
    // Show active requests, sorted by demo distance, take top 3
    final list = store.requests.where((r) => r.canAcceptDonation).toList();
    list.sort((a, b) => a.demoDistanceKm.compareTo(b.demoDistanceKm));
    return list.take(3).toList();
  }

  static DonorBadge? _findLastEarnedBadge(DemoStore store) {
    final earned = store.badges.where((b) => b.isEarned).toList();
    if (earned.isEmpty) return null;
    earned.sort(
      (a, b) => (b.earnedAt ?? DateTime(2000)).compareTo(
        a.earnedAt ?? DateTime(2000),
      ),
    );
    return earned.first;
  }

  static List<MonthlyDonationCount> _extractMonthlyDonations(DemoStore store) {
    final now = DateTime.now();
    final completed = store.donations.where((d) => d.isCompleted).toList();
    final result = <MonthlyDonationCount>[];

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final count = completed.where((d) {
        final dDate = d.completedAt ?? d.scheduledAt;
        return dDate.year == date.year && dDate.month == date.month;
      }).length;

      result.add(
        MonthlyDonationCount(month: date.month, year: date.year, count: count),
      );
    }
    return result;
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
