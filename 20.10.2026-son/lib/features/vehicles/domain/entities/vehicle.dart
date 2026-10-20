enum VehicleCategory { car }

enum Transmission { manual, automatic }

enum FuelType { gasoline, diesel, electric, hybrid }

/// A rentable vehicle. Pure Dart: no Flutter imports in the domain layer.
class Vehicle {
  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.transmission,
    required this.fuelType,
    required this.seatCount,
    required this.dailyPrice,
    required this.description,
    required this.isAvailable,
    this.category = VehicleCategory.car,
    this.imageAsset,
  });

  final String id;
  final String brand;
  final String model;
  final VehicleCategory category;
  final Transmission transmission;
  final FuelType fuelType;
  final int seatCount;

  /// Daily price in Turkish lira. Sample value, always positive.
  final int dailyPrice;
  final String? imageAsset;
  final String description;
  final bool isAvailable;

  String get name => '$brand $model';
}
