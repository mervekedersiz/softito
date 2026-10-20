import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/features/vehicles/data/repositories/mock_vehicle_repository.dart';
import 'package:yol_ortagim/features/vehicles/domain/entities/vehicle.dart';
import 'package:yol_ortagim/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:yol_ortagim/features/vehicles/domain/services/demo_availability.dart';

void main() {
  late List<Vehicle> vehicles;

  setUp(() async {
    vehicles = await const MockVehicleRepository(latency: Duration.zero)
        .getVehicles();
  });

  List<String> ids(VehicleFilter filter) =>
      filter.apply(vehicles).map((v) => v.id).toList();

  test('mock data has at least 4 vehicles with positive prices', () {
    expect(vehicles.length, greaterThanOrEqualTo(4));
    expect(vehicles.every((v) => v.dailyPrice > 0), isTrue);
  });

  test('no filter keeps every vehicle', () {
    expect(VehicleFilter.none.isActive, isFalse);
    expect(VehicleFilter.none.apply(vehicles), hasLength(vehicles.length));
  });

  test('filters by transmission', () {
    expect(ids(const VehicleFilter(transmission: Transmission.manual)), [
      'renault-clio',
      'fiat-egea',
    ]);
    expect(ids(const VehicleFilter(transmission: Transmission.automatic)), [
      'tesla-model-3',
      'toyota-corolla',
      'vw-passat',
    ]);
  });

  test('filters electric vehicles', () {
    expect(ids(const VehicleFilter(fuelType: FuelType.electric)), [
      'tesla-model-3',
    ]);
  });

  test('filters by price range inclusively', () {
    expect(ids(const VehicleFilter(minPrice: 1050, maxPrice: 1950)), [
      'toyota-corolla',
      'fiat-egea',
      'vw-passat',
    ]);
    expect(ids(const VehicleFilter(maxPrice: 950)), ['renault-clio']);
  });

  test('combines filters', () {
    const filter = VehicleFilter(
      transmission: Transmission.automatic,
      fuelType: FuelType.diesel,
    );
    expect(ids(filter), ['vw-passat']);
  });

  test('min greater than max is invalid and matches nothing', () {
    const filter = VehicleFilter(minPrice: 2000, maxPrice: 1000);
    expect(filter.hasValidPriceRange, isFalse);
    expect(filter.apply(vehicles), isEmpty);
  });

  test('with* helpers keep the other criteria', () {
    final filter = const VehicleFilter(fuelType: FuelType.diesel)
        .withTransmission(Transmission.manual)
        .withPriceRange(500, 1500);
    expect(filter.fuelType, FuelType.diesel);
    expect(filter.transmission, Transmission.manual);
    expect(filter.minPrice, 500);
    expect(ids(filter), ['fiat-egea']);
  });

  group('demo availability', () {
    test('unavailable vehicles are never available', () {
      final passat = vehicles.firstWhere((v) => !v.isAvailable);
      expect(
        List.generate(7, (day) => isDemoDayAvailable(passat, day)),
        everyElement(isFalse),
      );
    });

    test('is deterministic and not all days are available', () {
      final tesla = vehicles.first;
      final first = List.generate(7, (d) => isDemoDayAvailable(tesla, d));
      final second = List.generate(7, (d) => isDemoDayAvailable(tesla, d));
      expect(first, second);
      expect(first, contains(true));
    });
  });
}
