import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freshtrack/features/donations/domain/entities/donation_location.dart';
import 'package:freshtrack/features/donations/domain/repositories/device_location_service.dart';
import 'package:freshtrack/features/donations/domain/repositories/donation_location_repository.dart';
import 'package:freshtrack/features/donations/presentation/providers/donation_location_providers.dart';
import 'package:freshtrack/features/donations/presentation/screens/donation_location_screen.dart';

class _Repository implements DonationLocationRepository {
  final Map<DonationLocationKind, DonationLocation> saved = {};
  bool fail = false;
  @override
  Future<Map<DonationLocationKind, DonationLocation>> getLocations() async =>
      Map.of(saved);
  @override
  Future<void> save(DonationLocation location) async {
    if (fail) throw StateError('Storage unavailable');
    saved[location.kind] = location;
  }

  @override
  Future<void> remove(DonationLocationKind kind) async => saved.remove(kind);
}

class _Device implements DeviceLocationService {
  int calls = 0;
  bool denied = false;
  @override
  Future<GeoPoint> currentPosition() async {
    calls++;
    if (denied) {
      throw const LocationFailure('Konum izni verilmedi. Haritadan pin seçin.');
    }
    return GeoPoint(41.01, 29.02);
  }
}

class _Navigation implements LocationNavigationService {
  GeoPoint? opened;
  @override
  Future<void> openDirections(GeoPoint point) async {
    opened = point;
  }

  @override
  Future<void> openAttribution() async {}
}

Future<void> _show(
  WidgetTester tester,
  _Repository repo,
  _Device device,
  _Navigation navigation,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        donationLocationRepositoryProvider.overrideWithValue(repo),
        deviceLocationServiceProvider.overrideWithValue(device),
        locationNavigationServiceProvider.overrideWithValue(navigation),
      ],
      child: const MaterialApp(
        home: DonationLocationScreen(kind: DonationLocationKind.pickup),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Map taps select a pin without requesting GPS permission', (
    tester,
  ) async {
    final repo = _Repository();
    final device = _Device();
    await _show(tester, repo, device, _Navigation());
    await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
    // flutter_map waits for the double-tap gesture window before onTap.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(device.calls, 0);
    expect(find.text('Henüz pin seçilmedi.'), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('save-location')));
    await tester.tap(find.byKey(const Key('save-location')));
    await tester.pumpAndSettle();
    expect(repo.saved.containsKey(DonationLocationKind.pickup), isTrue);
  });

  testWidgets('GPS is opt-in, saves pickup, and opens the chosen coordinates', (
    tester,
  ) async {
    final repo = _Repository();
    final device = _Device();
    final navigation = _Navigation();
    await _show(tester, repo, device, navigation);
    expect(device.calls, 0);
    expect(find.text('Henüz pin seçilmedi.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('gps-location')));
    await tester.pumpAndSettle();
    expect(device.calls, 1);
    expect(find.textContaining('41.010000, 29.020000'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('save-location')));
    await tester.tap(find.byKey(const Key('save-location')));
    await tester.pumpAndSettle();
    expect(repo.saved[DonationLocationKind.pickup]!.point.longitude, 29.02);
    expect(find.text('Konum bu cihazda kaydedildi.'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('route-location')));
    await tester.tap(find.byKey(const Key('route-location')));
    await tester.pumpAndSettle();
    expect(navigation.opened!.latitude, 41.01);
  });

  testWidgets(
    'Permission denial keeps manual entry available and storage failure is visible',
    (tester) async {
      final repo = _Repository()..fail = true;
      final device = _Device()..denied = true;
      await _show(tester, repo, device, _Navigation());
      await tester.tap(find.byKey(const Key('gps-location')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Konum izni verilmedi'), findsOneWidget);
      await tester.ensureVisible(find.text('Koordinat gir'));
      await tester.tap(find.text('Koordinat gir'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('location-latitude')),
        '40,5',
      );
      await tester.enterText(
        find.byKey(const Key('location-longitude')),
        '29.1',
      );
      await tester.ensureVisible(find.byKey(const Key('apply-coordinates')));
      await tester.tap(find.byKey(const Key('apply-coordinates')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('save-location')));
      await tester.tap(find.byKey(const Key('save-location')));
      await tester.pumpAndSettle();
      expect(repo.saved, isEmpty);
      expect(find.textContaining('Konum kaydedilemedi'), findsOneWidget);
      expect(find.text('Konum kaydedildi.'), findsNothing);
      repo.fail = false;
      await tester.tap(find.byKey(const Key('save-location')));
      await tester.pumpAndSettle();
      expect(repo.saved[DonationLocationKind.pickup]!.point.latitude, 40.5);
    },
  );
}
