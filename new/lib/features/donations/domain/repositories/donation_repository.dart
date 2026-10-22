import '../entities/donation_package.dart';

abstract class DonationRepository {
  Future<List<DonationPackage>> getDonationPackages();
  Future<DonationPackage?> getPackageById(String id);
  Future<void> savePackage(DonationPackage package);
  Future<void> deletePackage(String id);
  Future<void> completePackage(String id);
  Future<void> addItemToPackage(String packageId, String foodItemId);
  Future<void> removeItemFromPackage(String packageId, String foodItemId);
}
