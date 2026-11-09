import '../../domain/entities/donation_package.dart';
import '../../domain/repositories/donation_repository.dart';
import '../../../inventory/data/datasources/local_food_datasource.dart';

class DonationRepositoryImpl implements DonationRepository {
  final LocalFoodDatasource _datasource;

  DonationRepositoryImpl({LocalFoodDatasource? datasource})
      : _datasource = datasource ?? LocalFoodDatasource();

  @override
  Future<List<DonationPackage>> getDonationPackages() => _datasource.getDonationPackages();

  @override
  Future<DonationPackage?> getPackageById(String id) =>
      _datasource.getDonationPackageById(id);

  @override
  Future<void> savePackage(DonationPackage package) =>
      _datasource.saveDonationPackage(package);

  @override
  Future<void> deletePackage(String id) => _datasource.deleteDonationPackage(id);

  @override
  Future<void> completePackage(String id) =>
      _datasource.completeDonationPackage(id);

  @override
  Future<void> addItemToPackage(String packageId, String foodItemId) =>
      _datasource.addItemToDonationPackage(packageId, foodItemId);

  @override
  Future<void> removeItemFromPackage(String packageId, String foodItemId) =>
      _datasource.removeItemFromDonationPackage(packageId, foodItemId);
}
