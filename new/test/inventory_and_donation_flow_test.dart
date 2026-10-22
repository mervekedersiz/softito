import 'package:flutter_test/flutter_test.dart';
import 'package:freshtrack/core/models/enums.dart';
import 'package:freshtrack/features/donations/data/repositories/donation_repository_impl.dart';
import 'package:freshtrack/features/donations/domain/entities/donation_package.dart';
import 'package:freshtrack/features/inventory/data/datasources/local_food_datasource.dart';
import 'package:freshtrack/features/inventory/data/repositories/food_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Inventory and Donation Flow Integration Tests', () {
    late LocalFoodDatasource datasource;
    late FoodRepositoryImpl foodRepo;
    late DonationRepositoryImpl donationRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      datasource = LocalFoodDatasource();
      foodRepo = FoodRepositoryImpl(datasource: datasource);
      donationRepo = DonationRepositoryImpl(datasource: datasource);
    });

    test('Initial seeding loads 18 foods matching mockups', () async {
      final foods = await foodRepo.getFoods();
      expect(foods.length, 18);

      final fridgeCount = foods.where((f) => f.storageLocation == StorageLocation.fridge).length;
      final freezerCount = foods.where((f) => f.storageLocation == StorageLocation.freezer).length;
      final pantryCount = foods.where((f) => f.storageLocation == StorageLocation.pantry).length;

      expect(fridgeCount, 12);
      expect(freezerCount, 4);
      expect(pantryCount, 2);
    });

    test('Consuming food creates event and updates food state', () async {
      final foods = await foodRepo.getFoods();
      final target = foods.firstWhere((f) => f.id == 'food_milk_1');

      await foodRepo.consumeFood(target.id);

      final updated = await foodRepo.getFoodById(target.id);
      expect(updated?.isConsumed, true);

      final events = await foodRepo.getConsumptionEvents();
      expect(events.first.foodItemId, target.id);
      expect(events.first.isWasted, false);
    });

    test('Wasting food logs waste event with price', () async {
      final foods = await foodRepo.getFoods();
      final target = foods.firstWhere((f) => f.id == 'food_mushroom_1');

      await foodRepo.wasteFood(target.id, reason: 'Bozuldu');

      final updated = await foodRepo.getFoodById(target.id);
      expect(updated?.isWasted, true);

      final events = await foodRepo.getConsumptionEvents();
      expect(events.first.foodItemId, target.id);
      expect(events.first.isWasted, true);
    });

    test('Donation package draft lifecycle and item reservation', () async {
      final now = DateTime.now();
      final pkg = DonationPackage(
        id: 'test_pkg_custom',
        title: 'Öğrenci Dayanışma Paketi',
        description: 'Kuru bakliyat desteği',
        itemIds: ['food_lentils_1'],
        status: DonationStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await donationRepo.savePackage(pkg);

      // Verify item reserved
      final foodBefore = await foodRepo.getFoodById('food_lentils_1');
      expect(foodBefore?.isReservedForDonation, true);

      // Add second item to package
      await donationRepo.addItemToPackage('test_pkg_custom', 'food_pasta_1');
      final pkgUpdated = await donationRepo.getPackageById('test_pkg_custom');
      expect(pkgUpdated?.itemIds.contains('food_pasta_1'), true);

      // Complete package locally
      await donationRepo.completePackage('test_pkg_custom');
      final completedPkg = await donationRepo.getPackageById('test_pkg_custom');
      expect(completedPkg?.status, DonationStatus.completedLocally);

      // Items should be marked as consumed upon delivery completion
      final lentilsAfter = await foodRepo.getFoodById('food_lentils_1');
      expect(lentilsAfter?.isConsumed, true);
    });

    test('Deleting a food item updates active donation drafts automatically', () async {
      final now = DateTime.now();
      final pkg = DonationPackage(
        id: 'test_pkg_sync',
        title: 'Senkronizasyon Test Paketi',
        description: 'Test',
        itemIds: ['food_peas_1'],
        status: DonationStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await donationRepo.savePackage(pkg);

      // Delete food from inventory
      await foodRepo.deleteFood('food_peas_1');

      // Draft package should now have item removed automatically
      final pkgAfter = await donationRepo.getPackageById('test_pkg_sync');
      expect(pkgAfter?.itemIds.contains('food_peas_1'), false);
    });
  });
}
