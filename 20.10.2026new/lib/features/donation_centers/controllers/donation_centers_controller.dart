import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../models/donation_centers_state.dart';

class DonationCentersController extends ValueNotifier<DonationCentersState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  DonationCentersController(this._store)
    : super(DonationCentersState(allCenters: _store.centers.toList())) {
    _storeListener = () {
      value = value.copyWith(allCenters: _store.centers.toList());
    };
    _store.addListener(_storeListener);
  }

  void setSearchQuery(String query) {
    value = value.copyWith(searchQuery: query);
  }

  void setDistrictFilter(String? district) {
    if (district == null || district.isEmpty || district == 'Tümü') {
      value = value.copyWith(clearFilterDistrict: true);
    } else {
      value = value.copyWith(filterDistrict: district);
    }
  }

  void resetFilters() {
    value = value.copyWith(searchQuery: '', clearFilterDistrict: true);
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
