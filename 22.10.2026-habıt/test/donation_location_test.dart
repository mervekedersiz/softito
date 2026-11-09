import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:freshtrack/core/services/storage_service.dart';
import 'package:freshtrack/core/models/enums.dart';
import 'package:freshtrack/features/inventory/domain/entities/food_item.dart';
import 'package:freshtrack/features/donations/data/repositories/donation_location_repository_impl.dart';
import 'package:freshtrack/features/donations/domain/entities/donation_location.dart';
import 'package:freshtrack/features/donations/domain/usecases/save_donation_location.dart';
import 'package:freshtrack/features/inventory/data/datasources/local_food_datasource.dart';

class _Storage extends StorageService {
  Map<String, dynamic> snapshot = {
    'schemaVersion': 1,
    'foods': [],
    'events': [
      {'id': 'existing-event'},
    ],
    'donationPackages': [
      {'id': 'existing-package'},
    ],
  };
  bool failWrites = false;
  Completer<void>? strictStarted;
  Completer<void>? strictRelease;

  Map<String, dynamic> _copy(Map<String, dynamic> value) =>
      jsonDecode(jsonEncode(value)) as Map<String, dynamic>;

  @override
  Future<Map<String, dynamic>?> loadSnapshot() async => _copy(snapshot);

  @override
  Future<void> saveSnapshotStrict(Map<String, dynamic> data) async {
    if (failWrites) throw StateError('Disk write failed');
    strictStarted?.complete();
    await strictRelease?.future;
    snapshot = _copy(data);
  }

  @override
  Future<void> saveSnapshot(Map<String, dynamic> data) async {
    snapshot = _copy(data);
  }
}

DonationLocation _location(DonationLocationKind kind, String label) =>
    DonationLocation(
      kind: kind,
      point: GeoPoint(41.01, 29.02),
      label: label,
      address: 'Kat 2, kapı 4',
      updatedAt: DateTime(2026, 10, 22),
    );

void main() {
  test(
    'Inventory edits during a location write preserve both changes',
    () async {
      final storage = _Storage()
        ..strictStarted = Completer<void>()
        ..strictRelease = Completer<void>();
      final ds = LocalFoodDatasource(storageService: storage);
      final repo = DonationLocationRepositoryImpl(ds);
      final pinWrite = repo.save(_location(DonationLocationKind.pickup, 'Ev'));
      await storage.strictStarted!.future;
      final now = DateTime.now();
      final foodWrite = ds.saveFood(
        FoodItem(
          id: 'new-food',
          name: 'Elma',
          quantity: 2,
          unit: 'adet',
          category: FoodCategory.produce,
          storageLocation: StorageLocation.fridge,
          dateType: DateType.tett,
          expiryDate: now.add(const Duration(days: 3)),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      storage.strictRelease!.complete();
      await Future.wait([pinWrite, foodWrite]);
      final reopened = LocalFoodDatasource(storageService: storage);
      expect((await reopened.getFoods()).single.id, 'new-food');
      expect(
        (await DonationLocationRepositoryImpl(
          reopened,
        ).getLocations())[DonationLocationKind.pickup]!.label,
        'Ev',
      );
    },
  );

  test('Coordinates reject non-finite and out-of-range input', () {
    for (final pair in [
      [double.nan, 0.0],
      [0.0, double.infinity],
      [90.1, 0.0],
      [-90.1, 0.0],
      [0.0, 180.1],
      [0.0, -180.1],
    ]) {
      expect(() => GeoPoint(pair[0], pair[1]), throwsFormatException);
    }
    expect(GeoPoint(0, 0).coordinates, '0.000000, 0.000000');
    expect(GeoPoint(-90, 180).longitude, 180);
  });

  test('Older snapshots without location records remain readable', () async {
    final repo = DonationLocationRepositoryImpl(
      LocalFoodDatasource(storageService: _Storage()),
    );
    expect(await repo.getLocations(), isEmpty);
  });

  test(
    'Both pins persist after datasource recreation and preserve other state',
    () async {
      final storage = _Storage();
      final repo = DonationLocationRepositoryImpl(
        LocalFoodDatasource(storageService: storage),
      );
      await Future.wait([
        repo.save(_location(DonationLocationKind.destination, 'Teslimat')),
        repo.save(_location(DonationLocationKind.pickup, 'Ev')),
      ]);
      final reopened = DonationLocationRepositoryImpl(
        LocalFoodDatasource(storageService: storage),
      );
      final locations = await reopened.getLocations();
      expect(locations.length, 2);
      expect(locations[DonationLocationKind.pickup]!.label, 'Ev');
      expect(
        locations[DonationLocationKind.destination]!.point.latitude,
        41.01,
      );
      expect(storage.snapshot['events'], [
        {'id': 'existing-event'},
      ]);
      expect(storage.snapshot['donationPackages'], [
        {'id': 'existing-package'},
      ]);
    },
  );

  test(
    'Failed saves preserve the previous pin and a retry can succeed',
    () async {
      final storage = _Storage();
      final repo = DonationLocationRepositoryImpl(
        LocalFoodDatasource(storageService: storage),
      );
      await repo.save(_location(DonationLocationKind.pickup, 'Eski adres'));
      storage.failWrites = true;
      await expectLater(
        repo.save(_location(DonationLocationKind.pickup, 'Yeni adres')),
        throwsStateError,
      );
      expect(
        (await repo.getLocations())[DonationLocationKind.pickup]!.label,
        'Eski adres',
      );
      storage.failWrites = false;
      await repo.save(_location(DonationLocationKind.pickup, 'Yeni adres'));
      expect(
        (await repo.getLocations())[DonationLocationKind.pickup]!.label,
        'Yeni adres',
      );
    },
  );

  test('Removing pickup retains destination and inventory state', () async {
    final storage = _Storage();
    final repo = DonationLocationRepositoryImpl(
      LocalFoodDatasource(storageService: storage),
    );
    await repo.save(_location(DonationLocationKind.destination, 'Kurum'));
    await repo.save(_location(DonationLocationKind.pickup, 'Ev'));
    await repo.remove(DonationLocationKind.pickup);
    expect((await repo.getLocations()).keys, [
      DonationLocationKind.destination,
    ]);
    expect(storage.snapshot['foods'], isEmpty);
    expect(storage.snapshot['events'], isNotEmpty);
  });

  test(
    'Save requires an explicitly selected pin and routes to its coordinates',
    () async {
      final repo = DonationLocationRepositoryImpl(
        LocalFoodDatasource(storageService: _Storage()),
      );
      await expectLater(
        SaveDonationLocation(repo)(
          kind: DonationLocationKind.pickup,
          point: null,
          label: 'Ev',
          address: '',
        ),
        throwsFormatException,
      );
      expect(await repo.getLocations(), isEmpty);
      final uri = directionsUri(GeoPoint(41.01, 29.02));
      expect(uri.scheme, 'https');
      expect(uri.host, 'www.google.com');
      expect(uri.queryParameters['destination'], '41.01,29.02');
      expect(uri.queryParameters.containsKey('origin'), isFalse);
    },
  );
}
