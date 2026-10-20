import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_group.dart';
import '../../../../core/models/blood_request.dart';
import '../models/blood_requests_state.dart';

class BloodRequestsController extends ValueNotifier<BloodRequestsState> {
  final DemoStore _store;
  late VoidCallback _storeListener;

  BloodRequestsController(this._store)
    : super(BloodRequestsState(allRequests: _store.requests.toList())) {
    _storeListener = () {
      value = value.copyWith(allRequests: _store.requests.toList());
    };
    _store.addListener(_storeListener);
  }

  void setBloodGroupFilter(BloodGroup? group) {
    if (group == null || group == BloodGroup.unknown) {
      value = value.copyWith(clearFilterBloodGroup: true);
    } else {
      value = value.copyWith(filterBloodGroup: group);
    }
  }

  void setDistrictFilter(String? district) {
    if (district == null || district.isEmpty || district == 'Tümü') {
      value = value.copyWith(clearFilterDistrict: true);
    } else {
      value = value.copyWith(filterDistrict: district);
    }
  }

  void setUrgencyFilter(RequestUrgency? urgency) {
    if (urgency == null) {
      value = value.copyWith(clearFilterUrgency: true);
    } else {
      value = value.copyWith(filterUrgency: urgency);
    }
  }

  void setSortOption(RequestSortOption sort) {
    value = value.copyWith(sortOption: sort);
  }

  void resetFilters() {
    value = value.copyWith(
      clearFilterBloodGroup: true,
      clearFilterDistrict: true,
      clearFilterUrgency: true,
      sortOption: RequestSortOption.distance,
    );
  }

  @override
  void dispose() {
    _store.removeListener(_storeListener);
    super.dispose();
  }
}
