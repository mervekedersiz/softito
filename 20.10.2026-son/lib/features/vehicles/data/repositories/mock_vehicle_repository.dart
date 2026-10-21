import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

/// In-memory sample vehicles with optional multi-modal extension.
class MockVehicleRepository implements VehicleRepository {
  const MockVehicleRepository({
    this.latency = const Duration(milliseconds: 350),
    this.includeMultiModal = false,
  });

  final Duration latency;
  final bool includeMultiModal;

  @override
  Future<List<Vehicle>> getVehicles() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (!includeMultiModal) return _baseVehicles;
    return [..._baseVehicles, ..._extendedMultiModalVehicles];
  }
}

const List<Vehicle> _baseVehicles = [
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
    fuelLevelPercent: 92,
    rangeKm: 540,
    modelYear: 2024,
    mileageKm: 14200,
    bodyType: 'Sedan',
    locationDistrict: 'Kadıköy',
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
    fuelLevelPercent: 78,
    tankCapacityLiters: 45,
    rangeKm: 680,
    modelYear: 2023,
    mileageKm: 32000,
    bodyType: 'Sedan',
    locationDistrict: 'Beşiktaş',
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
    fuelLevelPercent: 65,
    tankCapacityLiters: 42,
    rangeKm: 580,
    modelYear: 2022,
    mileageKm: 48000,
    bodyType: 'Hatchback',
    locationDistrict: 'Üsküdar',
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
    fuelLevelPercent: 88,
    tankCapacityLiters: 50,
    rangeKm: 850,
    modelYear: 2023,
    mileageKm: 29000,
    bodyType: 'Sedan',
    locationDistrict: 'Ataşehir',
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
    fuelLevelPercent: 40,
    tankCapacityLiters: 66,
    rangeKm: 720,
    modelYear: 2022,
    mileageKm: 55000,
    bodyType: 'Sedan',
    locationDistrict: 'Bakırköy',
  ),
];

const List<Vehicle> _extendedMultiModalVehicles = [
  Vehicle(
    id: 'segway-ninebot-max',
    brand: 'Segway',
    model: 'Ninebot Max G2',
    category: VehicleCategory.scooter,
    transmission: Transmission.automatic,
    fuelType: FuelType.electric,
    seatCount: 1,
    dailyPrice: 380,
    imageAsset: null,
    description:
        'Yeni nesil süspansiyonlu elektrikli scooter. Şehir içi kısa mesafelerde '
        'trafikten kaçmak için harika bir mikro mobilite çözümü.',
    isAvailable: true,
    fuelLevelPercent: 95,
    rangeKm: 70,
    modelYear: 2024,
    mileageKm: 350,
    bodyType: 'Scooter',
    locationDistrict: 'Kadıköy Moda',
  ),
  Vehicle(
    id: 'specialized-turbo-vado',
    brand: 'Specialized',
    model: 'Turbo Vado 4.0',
    category: VehicleCategory.eBike,
    transmission: Transmission.automatic,
    fuelType: FuelType.electric,
    seatCount: 1,
    dailyPrice: 490,
    imageAsset: null,
    description:
        'Premium elektrik destekli şehir ve tur bisikleti. Entegre batarya '
        've güçlü motoruyla yokuşları zahmetsizce tırmanır.',
    isAvailable: true,
    fuelLevelPercent: 88,
    rangeKm: 110,
    modelYear: 2024,
    mileageKm: 620,
    bodyType: 'E-Bisiklet',
    locationDistrict: 'Beşiktaş Sahil',
  ),
  Vehicle(
    id: 'vw-california-ocean',
    brand: 'Volkswagen',
    model: 'California Ocean Karavan',
    category: VehicleCategory.camperVan,
    transmission: Transmission.automatic,
    fuelType: FuelType.diesel,
    seatCount: 4,
    dailyPrice: 3850,
    imageAsset: null,
    description:
        'Açılır tavan yataklı, mini mutfaklı ve buzdolaplı lüks karavan. '
        'Doğada özgürce konaklamak için tasarlanmıştır.',
    isAvailable: true,
    fuelLevelPercent: 90,
    tankCapacityLiters: 70,
    rangeKm: 890,
    modelYear: 2024,
    mileageKm: 18000,
    bodyType: 'Karavan',
    locationDistrict: 'Çekmeköy',
  ),
];
