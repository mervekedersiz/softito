import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../models/profile_state.dart';

class ProfileController extends ValueNotifier<ProfileState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  ProfileController(this._store)
    : super(
        ProfileState(
          profile: _store.profile,
          badges: _store.badges.toList(),
          completedDonationsCount: _store.completedDonationsCount,
          lastDonationDate: _calculateLastDonationDate(_store),
        ),
      ) {
    _storeListener = () {
      value = value.copyWith(
        profile: _store.profile,
        badges: _store.badges.toList(),
        completedDonationsCount: _store.completedDonationsCount,
        lastDonationDate: _calculateLastDonationDate(_store),
      );
    };
    _store.addListener(_storeListener);
  }

  static DateTime? _calculateLastDonationDate(DemoStore store) {
    final completed = store.donations.where((d) => d.isCompleted).toList();
    if (completed.isEmpty) return null;
    completed.sort(
      (a, b) => (b.completedAt ?? b.scheduledAt).compareTo(
        a.completedAt ?? a.scheduledAt,
      ),
    );
    return completed.first.completedAt ?? completed.first.scheduledAt;
  }

  void updateNameAndDistrict(String name, String district) {
    final updated = _store.profile.copyWith(
      displayName: name.trim().isEmpty
          ? _store.profile.displayName
          : name.trim(),
      district: district.trim().isEmpty
          ? _store.profile.district
          : district.trim(),
    );
    _store.updateProfile(updated);
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
