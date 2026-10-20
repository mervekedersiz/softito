import '../../../../core/models/blood_group.dart';
import '../../../../core/models/blood_request.dart';

enum RequestSortOption {
  distance('Mesafe (En Yakın)'),
  urgency('Aciliyet'),
  expiry('Son Tarih');

  final String label;
  const RequestSortOption(this.label);
}

class BloodRequestsState {
  final List<BloodRequest> allRequests;
  final BloodGroup? filterBloodGroup;
  final String? filterDistrict;
  final RequestUrgency? filterUrgency;
  final RequestSortOption sortOption;

  const BloodRequestsState({
    required this.allRequests,
    this.filterBloodGroup,
    this.filterDistrict,
    this.filterUrgency,
    this.sortOption = RequestSortOption.distance,
  });

  List<BloodRequest> get filteredSortedRequests {
    var list = allRequests.where((req) {
      if (filterBloodGroup != null &&
          filterBloodGroup != BloodGroup.unknown &&
          req.bloodGroup != filterBloodGroup) {
        return false;
      }
      if (filterDistrict != null &&
          filterDistrict!.isNotEmpty &&
          req.district != filterDistrict) {
        return false;
      }
      if (filterUrgency != null && req.urgency != filterUrgency) {
        return false;
      }
      return true;
    }).toList();

    switch (sortOption) {
      case RequestSortOption.distance:
        list.sort((a, b) => a.demoDistanceKm.compareTo(b.demoDistanceKm));
        break;
      case RequestSortOption.urgency:
        // emergency first, then high, then normal
        final urgencyOrder = {
          RequestUrgency.emergency: 0,
          RequestUrgency.high: 1,
          RequestUrgency.normal: 2,
        };
        list.sort(
          (a, b) => (urgencyOrder[a.urgency] ?? 2).compareTo(
            urgencyOrder[b.urgency] ?? 2,
          ),
        );
        break;
      case RequestSortOption.expiry:
        list.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
        break;
    }

    return list;
  }

  BloodRequestsState copyWith({
    List<BloodRequest>? allRequests,
    BloodGroup? filterBloodGroup,
    bool clearFilterBloodGroup = false,
    String? filterDistrict,
    bool clearFilterDistrict = false,
    RequestUrgency? filterUrgency,
    bool clearFilterUrgency = false,
    RequestSortOption? sortOption,
  }) {
    return BloodRequestsState(
      allRequests: allRequests ?? this.allRequests,
      filterBloodGroup: clearFilterBloodGroup
          ? null
          : (filterBloodGroup ?? this.filterBloodGroup),
      filterDistrict: clearFilterDistrict
          ? null
          : (filterDistrict ?? this.filterDistrict),
      filterUrgency: clearFilterUrgency
          ? null
          : (filterUrgency ?? this.filterUrgency),
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
