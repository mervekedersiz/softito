import '../entities/donation_location.dart';

abstract class DonationLocationRepository {
  Future<Map<DonationLocationKind, DonationLocation>> getLocations();
  Future<void> save(DonationLocation location);
  Future<void> remove(DonationLocationKind kind);
}
