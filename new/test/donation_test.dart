import 'package:flutter_test/flutter_test.dart';
import 'package:freshtrack/core/models/enums.dart';
import 'package:freshtrack/features/donations/domain/entities/donation_package.dart';
import 'package:freshtrack/features/donations/domain/usecases/check_donation_eligibility.dart';
import 'package:freshtrack/features/inventory/domain/entities/food_item.dart';

void main() {
  group('DonationEligibilityChecker Tests', () {
    final now = DateTime(2026, 10, 22, 12, 0);

    test('Opened packaging is ineligible for donation', () {
      final item = FoodItem(
        id: 'test_1',
        name: 'Açık Kaşar Peyniri',
        quantity: 200,
        unit: 'g',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        dateType: DateType.stt,
        expiryDate: now.add(const Duration(days: 5)),
        packageStatus: PackageStatus.opened,
        createdAt: now,
        updatedAt: now,
      );

      final result = DonationEligibilityChecker.check(item, now);
      expect(result.isEligible, false);
      expect(result.statusTag, 'Açılmış Ambalaj');
    });

    test('Expired item is ineligible for donation', () {
      final item = FoodItem(
        id: 'test_2',
        name: 'Tarihi Geçmiş Süt',
        quantity: 1,
        unit: 'L',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        dateType: DateType.stt,
        expiryDate: now.subtract(const Duration(days: 1)),
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      );

      final result = DonationEligibilityChecker.check(item, now);
      expect(result.isEligible, false);
      expect(result.statusTag, 'Tarihi Geçmiş');
    });

    test('Cold chain item with less than 2 days shelf life is ineligible', () {
      final item = FoodItem(
        id: 'test_3',
        name: 'Kritik Tavuk',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.meat,
        storageLocation: StorageLocation.fridge,
        dateType: DateType.stt,
        expiryDate: now.add(const Duration(days: 1)),
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      );

      final result = DonationEligibilityChecker.check(item, now);
      expect(result.isEligible, false);
      expect(result.statusTag, 'Kritik Soğuk Zincir');
    });

    test('Pantry item with unopened package and long shelf life is eligible', () {
      final item = FoodItem(
        id: 'test_4',
        name: 'Kırmızı Mercimek',
        quantity: 1,
        unit: 'kg',
        category: FoodCategory.pantry,
        storageLocation: StorageLocation.pantry,
        dateType: DateType.tett,
        expiryDate: now.add(const Duration(days: 200)),
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      );

      final result = DonationEligibilityChecker.check(item, now);
      expect(result.isEligible, true);
      expect(result.statusTag, '6 Ay Güvende');
    });

    test('Unopened dairy with 4 days shelf life is eligible', () {
      final item = FoodItem(
        id: 'test_5',
        name: 'Organik Köy Sütü',
        quantity: 1,
        unit: 'L',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        dateType: DateType.stt,
        expiryDate: now.add(const Duration(days: 4)),
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      );

      final result = DonationEligibilityChecker.check(item, now);
      expect(result.isEligible, true);
      expect(result.statusTag, 'Son 4 Gün');
    });
  });

  group('DonationPackage Entity Tests', () {
    test('DonationPackage copyWith updates fields correctly', () {
      final now = DateTime.now();
      final package = DonationPackage(
        id: 'pkg_1',
        title: 'Kış Dayanışması',
        description: 'Öğrenciler için',
        itemIds: ['item_1', 'item_2'],
        status: DonationStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      final updated = package.copyWith(
        status: DonationStatus.completedLocally,
        completedAt: now,
      );

      expect(updated.status, DonationStatus.completedLocally);
      expect(updated.completedAt, now);
      expect(updated.itemIds.length, 2);
    });
  });
}
