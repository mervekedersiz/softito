import '../entities/donation_location.dart';
import '../repositories/donation_location_repository.dart';

class SaveDonationLocation {
  final DonationLocationRepository repository;
  SaveDonationLocation(this.repository);

  Future<DonationLocation> call({
    required DonationLocationKind kind,
    required GeoPoint? point,
    required String label,
    required String address,
  }) async {
    if (point == null) {
      throw const FormatException(
        'Önce haritadan bir pin seçin veya konumunuzu alın.',
      );
    }
    final location = DonationLocation(
      kind: kind,
      point: point,
      label: label,
      address: address,
      updatedAt: DateTime.now(),
    );
    await repository.save(location);
    return location;
  }
}

Uri directionsUri(GeoPoint point) => Uri.https('www.google.com', '/maps/dir/', {
  'api': '1',
  'destination': '${point.latitude},${point.longitude}',
});
