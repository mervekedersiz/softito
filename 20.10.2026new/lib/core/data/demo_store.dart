import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/blood_group.dart';
import '../models/donor_profile.dart';
import '../models/blood_request.dart';
import '../models/donation_center.dart';
import '../models/donation_record.dart';
import '../models/blood_measurement.dart';
import '../models/eligibility_answer.dart';
import '../models/donor_badge.dart';
import 'demo_seed.dart';

class DemoStore extends ChangeNotifier {
  late DonorProfile _profile;
  late List<BloodRequest> _requests;
  late List<DonationCenter> _centers;
  late List<DonationRecord> _donations;
  late List<BloodMeasurement> _measurements;
  late Map<String, EligibilityAnswer> _eligibilityAnswers;
  late List<DonorBadge> _badges;

  DemoStore({DateTime? baseTime}) {
    reset(baseTime: baseTime);
  }

  void reset({DateTime? baseTime}) {
    _profile = DemoSeed.createInitialProfile();
    _requests = DemoSeed.createInitialRequests(baseTime);
    _centers = DemoSeed.createInitialCenters();
    _donations = DemoSeed.createInitialDonations(baseTime);
    _measurements = DemoSeed.createInitialMeasurements(baseTime);
    _eligibilityAnswers = {};
    _badges = DemoSeed.createInitialBadges(baseTime);
    notifyListeners();
  }

  // Immutable accessors
  DonorProfile get profile => _profile;
  UnmodifiableListView<BloodRequest> get requests =>
      UnmodifiableListView(_requests);
  UnmodifiableListView<DonationCenter> get centers =>
      UnmodifiableListView(_centers);
  UnmodifiableListView<DonationRecord> get donations =>
      UnmodifiableListView(_donations);
  UnmodifiableListView<BloodMeasurement> get measurements =>
      UnmodifiableListView(_measurements);
  Map<String, EligibilityAnswer> get eligibilityAnswers =>
      Map.unmodifiable(_eligibilityAnswers);
  UnmodifiableListView<DonorBadge> get badges => UnmodifiableListView(_badges);

  // Derived helpers
  DonationRecord? get upcomingAppointment {
    for (final d in _donations) {
      if (d.isPlanned) return d;
    }
    return null;
  }

  int get completedDonationsCount =>
      _donations.where((d) => d.isCompleted).length;

  DonationCenter? getCenterById(String centerId) {
    for (final c in _centers) {
      if (c.id == centerId) return c;
    }
    return null;
  }

  BloodRequest? getRequestById(String requestId) {
    for (final r in _requests) {
      if (r.id == requestId) return r;
    }
    return null;
  }

  // Mutations
  void updateProfile(DonorProfile newProfile) {
    if (_profile != newProfile) {
      _profile = newProfile;
      notifyListeners();
    }
  }

  void updateBloodGroup(BloodGroup group) {
    if (_profile.bloodGroup != group) {
      _profile = _profile.copyWith(bloodGroup: group);
      notifyListeners();
    }
  }

  bool addDonationRecord(DonationRecord record) {
    // Check if there is already an active planned appointment
    final hasActive = _donations.any((d) => d.isPlanned);
    if (hasActive) {
      return false;
    }

    _donations = [record, ..._donations];
    notifyListeners();
    return true;
  }

  bool cancelDonation(String donationId) {
    final index = _donations.indexWhere((d) => d.id == donationId);
    if (index == -1) return false;

    final existing = _donations[index];
    if (existing.isCompleted) return false; // completed cannot be cancelled

    final updated = existing.copyWith(status: DonationStatus.cancelled);
    final newList = List<DonationRecord>.from(_donations);
    newList[index] = updated;
    _donations = newList;
    notifyListeners();
    return true;
  }

  bool completeDemoDonation(String donationId) {
    final index = _donations.indexWhere((d) => d.id == donationId);
    if (index == -1) return false;

    final existing = _donations[index];
    if (existing.status != DonationStatus.planned) return false;

    final now = DateTime.now();
    final updated = existing.copyWith(
      status: DonationStatus.completed,
      completedAt: now,
      trackingEvents: [
        TrackingEvent(
          stage: TrackingStage.donated,
          timestamp: now,
          note: 'Demo bağış işlemi gerçekleştirildi.',
        ),
        TrackingEvent(
          stage: TrackingStage.tested,
          timestamp: now.add(const Duration(minutes: 5)),
          note: 'Kontrol testleri simüle edildi.',
        ),
        TrackingEvent(
          stage: TrackingStage.ready,
          timestamp: now.add(const Duration(minutes: 10)),
          note: 'Ulusal kan deposuna transfer hazırlandı.',
        ),
        TrackingEvent(
          stage: TrackingStage.delivered,
          timestamp: now.add(const Duration(minutes: 15)),
          note: 'Dağıtıma yönlendirildi.',
        ),
      ],
    );

    final newList = List<DonationRecord>.from(_donations);
    newList[index] = updated;
    _donations = newList;

    // Check badge rewards idempotently
    _evaluateBadges();

    notifyListeners();
    return true;
  }

  void addMeasurement(BloodMeasurement measurement) {
    _measurements = [measurement, ..._measurements];
    notifyListeners();
  }

  bool deleteMeasurement(String measurementId) {
    final countBefore = _measurements.length;
    _measurements = _measurements.where((m) => m.id != measurementId).toList();
    if (_measurements.length != countBefore) {
      notifyListeners();
      return true;
    }
    return false;
  }

  void saveEligibilityAnswers(Map<String, EligibilityAnswer> answers) {
    _eligibilityAnswers = Map.from(answers);
    notifyListeners();
  }

  bool awardBadge(String badgeId) {
    final index = _badges.indexWhere((b) => b.id == badgeId);
    if (index == -1) return false;
    final badge = _badges[index];
    if (badge.isEarned) return false; // Already earned, idempotent

    final updated = badge.copyWith(earnedAt: DateTime.now());
    final newBadges = List<DonorBadge>.from(_badges);
    newBadges[index] = updated;
    _badges = newBadges;
    notifyListeners();
    return true;
  }

  void _evaluateBadges() {
    final completed = completedDonationsCount;
    if (completed >= 1) {
      awardBadge('badge_first_step');
    }
    if (completed >= 3) {
      awardBadge('badge_regular_donor');
    }
  }
}
