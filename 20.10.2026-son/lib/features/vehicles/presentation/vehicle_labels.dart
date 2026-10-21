import 'package:flutter/material.dart';

import '../domain/entities/vehicle.dart';

extension TransmissionLabel on Transmission {
  String get label => switch (this) {
    Transmission.manual => 'Manuel',
    Transmission.automatic => 'Otomatik',
  };

  IconData get icon => Icons.settings;
}

extension FuelTypeLabel on FuelType {
  String get label => switch (this) {
    FuelType.gasoline => 'Benzin',
    FuelType.diesel => 'Dizel',
    FuelType.electric => 'Elektrik',
    FuelType.hybrid => 'Hibrit',
  };

  IconData get icon => switch (this) {
    FuelType.gasoline || FuelType.diesel => Icons.local_gas_station,
    FuelType.electric => Icons.bolt,
    FuelType.hybrid => Icons.eco,
  };
}

extension VehicleCategoryLabel on VehicleCategory {
  String get label => switch (this) {
    VehicleCategory.car => 'Binek araç',
    VehicleCategory.electricSuv => 'Elektrikli SUV',
    VehicleCategory.scooter => 'E-Scooter',
    VehicleCategory.eBike => 'E-Bisiklet',
    VehicleCategory.camperVan => 'Karavan & Ticari',
  };
}
