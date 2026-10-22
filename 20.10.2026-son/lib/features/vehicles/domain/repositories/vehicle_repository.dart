import '../entities/vehicle.dart';

/// Source of vehicles. Implemented by a mock now, a real API later.
abstract interface class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
}
