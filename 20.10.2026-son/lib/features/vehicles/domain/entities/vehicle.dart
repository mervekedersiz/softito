enum VehicleCategory {
  car('Otomobil'),
  electricSuv('Elektrikli SUV'),
  scooter('E-Scooter'),
  eBike('E-Bisiklet'),
  camperVan('Karavan & Ticari');

  const VehicleCategory([this.label = 'Otomobil']);
  final String label;
}

enum Transmission { manual, automatic }

enum FuelType { gasoline, diesel, electric, hybrid }

/// A rentable vehicle with multi-modal specs and Sahibinden-style details.
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
    this.fuelLevelPercent = 85,
    this.tankCapacityLiters = 55,
    this.rangeKm = 520,
    this.modelYear = 2024,
    this.mileageKm = 24500,
    this.bodyType = 'Sedan',
    this.expertStatus = 'Hatasız / Ekspertiz Onaylı',
    this.locationDistrict = 'Kadıköy',
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

  // Sahibinden & Multi-modal attributes
  final int fuelLevelPercent;
  final int tankCapacityLiters;
  final int rangeKm;
  final int modelYear;
  final int mileageKm;
  final String bodyType;
  final String expertStatus;
  final String locationDistrict;

  String get name => '$brand $model';

  /// Depoyu ve şarjı net bildiren durum metni ("Depoyu Söylüyor")
  String get fuelOrBatteryDescription {
    if (fuelType == FuelType.electric) {
      return '%$fuelLevelPercent Batarya • $rangeKm km Menzil';
    } else {
      final currentLiters = (tankCapacityLiters * fuelLevelPercent / 100).round();
      return '%$fuelLevelPercent Depo ($currentLiters/$tankCapacityLiters L) • $rangeKm km';
    }
  }
}
