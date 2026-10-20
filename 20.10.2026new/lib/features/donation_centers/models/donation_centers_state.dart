import '../../../../core/models/donation_center.dart';

class DonationCentersState {
  final List<DonationCenter> allCenters;
  final String searchQuery;
  final String? filterDistrict;

  const DonationCentersState({
    required this.allCenters,
    this.searchQuery = '',
    this.filterDistrict,
  });

  List<DonationCenter> get filteredCenters {
    return allCenters.where((c) {
      if (filterDistrict != null &&
          filterDistrict!.isNotEmpty &&
          filterDistrict != 'Tümü' &&
          c.district != filterDistrict) {
        return false;
      }
      if (searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase().trim();
        final matchName = c.name.toLowerCase().contains(q);
        final matchDistrict = c.district.toLowerCase().contains(q);
        final matchAddress = c.address.toLowerCase().contains(q);
        if (!matchName && !matchDistrict && !matchAddress) return false;
      }
      return true;
    }).toList();
  }

  DonationCentersState copyWith({
    List<DonationCenter>? allCenters,
    String? searchQuery,
    String? filterDistrict,
    bool clearFilterDistrict = false,
  }) {
    return DonationCentersState(
      allCenters: allCenters ?? this.allCenters,
      searchQuery: searchQuery ?? this.searchQuery,
      filterDistrict: clearFilterDistrict
          ? null
          : (filterDistrict ?? this.filterDistrict),
    );
  }
}
