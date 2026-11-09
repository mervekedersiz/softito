import '../entities/donation_location.dart';

class LocationFailure implements Exception {
  final String message;
  const LocationFailure(this.message);
  @override
  String toString() => message;
}

abstract class DeviceLocationService {
  Future<GeoPoint> currentPosition();
}

abstract class LocationNavigationService {
  Future<void> openDirections(GeoPoint point);
  Future<void> openAttribution();
}
