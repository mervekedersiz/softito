import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../data/repositories/donation_location_repository_impl.dart';
import '../../data/services/geolocator_device_location_service.dart';
import '../../data/services/maps_navigation_service.dart';
import '../../domain/entities/donation_location.dart';
import '../../domain/repositories/device_location_service.dart';
import '../../domain/repositories/donation_location_repository.dart';
import '../../domain/usecases/save_donation_location.dart';

final donationLocationRepositoryProvider = Provider<DonationLocationRepository>(
  (ref) =>
      DonationLocationRepositoryImpl(ref.watch(localFoodDatasourceProvider)),
);
final deviceLocationServiceProvider = Provider<DeviceLocationService>(
  (ref) => GeolocatorDeviceLocationService(),
);
final locationNavigationServiceProvider = Provider<LocationNavigationService>(
  (ref) => MapsNavigationService(),
);

class DonationLocationsNotifier
    extends AsyncNotifier<Map<DonationLocationKind, DonationLocation>> {
  @override
  Future<Map<DonationLocationKind, DonationLocation>> build() =>
      ref.watch(donationLocationRepositoryProvider).getLocations();

  Future<void> save({
    required DonationLocationKind kind,
    required GeoPoint? point,
    required String label,
    required String address,
  }) async {
    final location = await SaveDonationLocation(
      ref.read(donationLocationRepositoryProvider),
    )(kind: kind, point: point, label: label, address: address);
    state = AsyncData({...?state.value, kind: location});
  }

  Future<void> remove(DonationLocationKind kind) async {
    await ref.read(donationLocationRepositoryProvider).remove(kind);
    state = AsyncData({...?state.value}..remove(kind));
  }
}

final donationLocationsProvider =
    AsyncNotifierProvider<
      DonationLocationsNotifier,
      Map<DonationLocationKind, DonationLocation>
    >(DonationLocationsNotifier.new);
