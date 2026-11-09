import '../../../inventory/data/datasources/local_food_datasource.dart';
import '../../domain/entities/donation_location.dart';
import '../../domain/repositories/donation_location_repository.dart';
import '../models/donation_location_model.dart';

class DonationLocationRepositoryImpl implements DonationLocationRepository {
  final LocalFoodDatasource datasource;
  DonationLocationRepositoryImpl(this.datasource);

  @override
  Future<Map<DonationLocationKind, DonationLocation>> getLocations() async {
    final records = await datasource.getDonationLocationRecords();
    final locations = <DonationLocationKind, DonationLocation>{};
    for (final kind in DonationLocationKind.values) {
      final record = records[kind.name];
      if (record != null) {
        locations[kind] = DonationLocationModel.fromJson(
          kind,
          Map<String, dynamic>.from(record as Map),
        );
      }
    }
    return locations;
  }

  @override
  Future<void> save(DonationLocation location) =>
      datasource.saveDonationLocationRecord(
        location.kind.name,
        DonationLocationModel.toJson(location),
      );

  @override
  Future<void> remove(DonationLocationKind kind) =>
      datasource.saveDonationLocationRecord(kind.name, null);
}
