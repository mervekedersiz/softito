import 'vehicle.dart';

/// Immutable filter over the vehicle list.
class VehicleFilter {
  const VehicleFilter({
    this.transmission,
    this.fuelType,
    this.minPrice,
    this.maxPrice,
  });

  static const VehicleFilter none = VehicleFilter();

  final Transmission? transmission;
  final FuelType? fuelType;
  final int? minPrice;
  final int? maxPrice;

  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  bool get isActive =>
      transmission != null || fuelType != null || hasPriceFilter;

  /// Min must not exceed max when both are set.
  bool get hasValidPriceRange =>
      minPrice == null || maxPrice == null || minPrice! <= maxPrice!;

  VehicleFilter withTransmission(Transmission? value) => VehicleFilter(
    transmission: value,
    fuelType: fuelType,
    minPrice: minPrice,
    maxPrice: maxPrice,
  );

  VehicleFilter withFuelType(FuelType? value) => VehicleFilter(
    transmission: transmission,
    fuelType: value,
    minPrice: minPrice,
    maxPrice: maxPrice,
  );

  VehicleFilter withPriceRange(int? min, int? max) => VehicleFilter(
    transmission: transmission,
    fuelType: fuelType,
    minPrice: min,
    maxPrice: max,
  );

  bool matches(Vehicle vehicle) {
    if (transmission != null && vehicle.transmission != transmission) {
      return false;
    }
    if (fuelType != null && vehicle.fuelType != fuelType) return false;
    if (minPrice != null && vehicle.dailyPrice < minPrice!) return false;
    if (maxPrice != null && vehicle.dailyPrice > maxPrice!) return false;
    return true;
  }

  List<Vehicle> apply(List<Vehicle> vehicles) {
    if (!hasValidPriceRange) return const [];
    return vehicles.where(matches).toList();
  }
}
