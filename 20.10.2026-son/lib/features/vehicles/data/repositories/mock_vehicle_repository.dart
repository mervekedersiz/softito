import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

/// In-memory sample vehicles. Prices and availability are fictional.
class MockVehicleRepository implements VehicleRepository {
  const MockVehicleRepository({
    this.latency = const Duration(milliseconds: 350),
  });

  /// Simulated network delay so loading states are visible.
  final Duration latency;

  @override
  Future<List<Vehicle>> getVehicles() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return _vehicles;
  }
}

const List<Vehicle> _vehicles = [
  Vehicle(
    id: 'tesla-model-3',
    brand: 'Tesla',
    model: 'Model 3',
    transmission: Transmission.automatic,
    fuelType: FuelType.electric,
    seatCount: 5,
    dailyPrice: 2450,
    imageAsset: 'assets/images/electric_sedan.jpg',
    description:
        'Sessiz ve hızlı elektrikli sedan. Şehir içi ve uzun '
        'yolculuklar için ideal, geniş cam tavanlı ferah bir iç mekân sunar.',
    isAvailable: true,
  ),
  Vehicle(
    id: 'toyota-corolla',
    brand: 'Toyota',
    model: 'Corolla',
    transmission: Transmission.automatic,
    fuelType: FuelType.hybrid,
    seatCount: 5,
    dailyPrice: 1650,
    imageAsset: 'assets/images/hybrid_sedan.jpg',
    description:
        'Düşük yakıt tüketimli hibrit sedan. Konforlu sürüşü ve '
        'geniş bagajıyla aile ve iş seyahatleri için uygundur.',
    isAvailable: true,
  ),
  Vehicle(
    id: 'renault-clio',
    brand: 'Renault',
    model: 'Clio',
    transmission: Transmission.manual,
    fuelType: FuelType.gasoline,
    seatCount: 5,
    dailyPrice: 950,
    imageAsset: 'assets/images/city_hatchback.jpg',
    description:
        'Kompakt ve ekonomik şehir aracı. Dar sokaklarda kolay '
        'park edilir, bütçe dostu bir seçenektir.',
    isAvailable: true,
  ),
  Vehicle(
    id: 'fiat-egea',
    brand: 'Fiat',
    model: 'Egea',
    transmission: Transmission.manual,
    fuelType: FuelType.diesel,
    seatCount: 5,
    dailyPrice: 1050,
    imageAsset: 'assets/images/family_sedan.jpg',
    description:
        'Dizel motoruyla uzun yolda ekonomik giden pratik sedan. '
        'Geniş bagaj hacmi tatil yolculukları için yeterlidir.',
    isAvailable: true,
  ),
  Vehicle(
    id: 'vw-passat',
    brand: 'Volkswagen',
    model: 'Passat',
    transmission: Transmission.automatic,
    fuelType: FuelType.diesel,
    seatCount: 5,
    dailyPrice: 1950,
    imageAsset: 'assets/images/executive_sedan.jpg',
    description:
        'Üst sınıf konfor arayanlar için geniş ve sakin bir sedan. '
        'Bu demo listede şu an müsait değil.',
    isAvailable: false,
  ),
];
