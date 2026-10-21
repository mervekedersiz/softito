import 'vehicle.dart';

/// Immutable filter over the vehicle list with Sahibinden-style criteria.
class VehicleFilter {
  const VehicleFilter({
    this.transmission,
    this.fuelType,
    this.minPrice,
    this.maxPrice,
    this.category,
    this.minFuelPercent,
    this.minYear,
    this.maxMileage,
    this.bodyType,
  });

  static const VehicleFilter none = VehicleFilter();

  final Transmission? transmission;
  final FuelType? fuelType;
  final int? minPrice;
  final int? maxPrice;
  final VehicleCategory? category;
  final int? minFuelPercent;
  final int? minYear;
  final int? maxMileage;
  final String? bodyType;

  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  bool get isActive =>
      transmission != null ||
      fuelType != null ||
      hasPriceFilter ||
      category != null ||
      minFuelPercent != null ||
      minYear != null ||
      maxMileage != null ||
      bodyType != null;

  /// Min must not exceed max when both are set.
  bool get hasValidPriceRange =>
      minPrice == null || maxPrice == null || minPrice! <= maxPrice!;

  VehicleFilter withTransmission(Transmission? value) => VehicleFilter(
        transmission: value,
        fuelType: fuelType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: category,
        minFuelPercent: minFuelPercent,
        minYear: minYear,
        maxMileage: maxMileage,
        bodyType: bodyType,
      );

  VehicleFilter withFuelType(FuelType? value) => VehicleFilter(
        transmission: transmission,
        fuelType: value,
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: category,
        minFuelPercent: minFuelPercent,
        minYear: minYear,
        maxMileage: maxMileage,
        bodyType: bodyType,
      );

  VehicleFilter withPriceRange(int? min, int? max) => VehicleFilter(
        transmission: transmission,
        fuelType: fuelType,
        minPrice: min,
        maxPrice: max,
        category: category,
        minFuelPercent: minFuelPercent,
        minYear: minYear,
        maxMileage: maxMileage,
        bodyType: bodyType,
      );

  VehicleFilter withCategory(VehicleCategory? cat) => VehicleFilter(
        transmission: transmission,
        fuelType: fuelType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: cat,
        minFuelPercent: minFuelPercent,
        minYear: minYear,
        maxMileage: maxMileage,
        bodyType: bodyType,
      );

  VehicleFilter withMinFuelPercent(int? percent) => VehicleFilter(
        transmission: transmission,
        fuelType: fuelType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: category,
        minFuelPercent: percent,
        minYear: minYear,
        maxMileage: maxMileage,
        bodyType: bodyType,
      );

  bool matches(Vehicle vehicle) {
    if (transmission != null && vehicle.transmission != transmission) {
      return false;
    }
    if (fuelType != null && vehicle.fuelType != fuelType) return false;
    if (minPrice != null && vehicle.dailyPrice < minPrice!) return false;
    if (maxPrice != null && vehicle.dailyPrice > maxPrice!) return false;
    if (category != null && vehicle.category != category) return false;
    if (minFuelPercent != null && vehicle.fuelLevelPercent < minFuelPercent!) {
      return false;
    }
    if (minYear != null && vehicle.modelYear < minYear!) return false;
    if (maxMileage != null && vehicle.mileageKm > maxMileage!) return false;
    if (bodyType != null && vehicle.bodyType != bodyType) return false;
    return true;
  }

  List<Vehicle> apply(List<Vehicle> vehicles) {
    if (!hasValidPriceRange) return const [];
    return vehicles.where(matches).toList();
  }
}
