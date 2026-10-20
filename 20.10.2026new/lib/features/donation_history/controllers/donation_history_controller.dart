import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/donation_record.dart';
import '../models/donation_history_state.dart';

class DonationHistoryController extends ValueNotifier<DonationHistoryState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  DonationHistoryController(this._store)
    : super(DonationHistoryState(allDonations: _store.donations.toList())) {
    _storeListener = () {
      value = value.copyWith(allDonations: _store.donations.toList());
      // Refresh selected donation if updated
      if (value.selectedDonation != null) {
        final updated = _store.donations
            .where((d) => d.id == value.selectedDonation!.id)
            .firstOrNull;
        if (updated != null) {
          value = value.copyWith(selectedDonation: updated);
        }
      }
    };
    _store.addListener(_storeListener);
  }

  void setFilterStatus(DonationStatus? status) {
    if (status == null) {
      value = value.copyWith(clearFilterStatus: true);
    } else {
      value = value.copyWith(filterStatus: status);
    }
  }

  void selectDonation(DonationRecord? record) {
    value = value.copyWith(
      selectedDonation: record,
      clearSelectedDonation: record == null,
    );
  }

  bool cancelDonation(String id) {
    return _store.cancelDonation(id);
  }

  bool completeDemoDonation(String id) {
    return _store.completeDemoDonation(id);
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
