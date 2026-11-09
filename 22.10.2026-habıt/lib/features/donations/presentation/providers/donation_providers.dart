import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/enums.dart';
import '../../../inventory/domain/entities/food_item.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../data/repositories/donation_repository_impl.dart';
import '../../domain/entities/donation_package.dart';
import '../../domain/repositories/donation_repository.dart';
import '../../domain/usecases/check_donation_eligibility.dart';

final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  final ds = ref.watch(localFoodDatasourceProvider);
  return DonationRepositoryImpl(datasource: ds);
});

// Donation packages list notifier
class DonationPackagesNotifier extends AsyncNotifier<List<DonationPackage>> {
  @override
  Future<List<DonationPackage>> build() async {
    final repo = ref.watch(donationRepositoryProvider);
    return repo.getDonationPackages();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(donationRepositoryProvider);
      return repo.getDonationPackages();
    });
  }

  Future<void> savePackage(DonationPackage package) async {
    final repo = ref.read(donationRepositoryProvider);
    await repo.savePackage(package);
    ref.invalidate(foodsListProvider);
    await refresh();
  }

  Future<void> deletePackage(String id) async {
    final repo = ref.read(donationRepositoryProvider);
    await repo.deletePackage(id);
    ref.invalidate(foodsListProvider);
    await refresh();
  }

  Future<void> completePackage(String id) async {
    final repo = ref.read(donationRepositoryProvider);
    await repo.completePackage(id);
    ref.invalidate(foodsListProvider);
    await refresh();
  }

  Future<void> addItem(String packageId, String foodItemId) async {
    final repo = ref.read(donationRepositoryProvider);
    await repo.addItemToPackage(packageId, foodItemId);
    ref.invalidate(foodsListProvider);
    await refresh();
  }

  Future<void> removeItem(String packageId, String foodItemId) async {
    final repo = ref.read(donationRepositoryProvider);
    await repo.removeItemFromPackage(packageId, foodItemId);
    ref.invalidate(foodsListProvider);
    await refresh();
  }
}

final donationPackagesProvider =
    AsyncNotifierProvider<DonationPackagesNotifier, List<DonationPackage>>(
  DonationPackagesNotifier.new,
);

// Active drafts
final activeDonationDraftsProvider = Provider<List<DonationPackage>>((ref) {
  final listAsync = ref.watch(donationPackagesProvider);
  final all = listAsync.value ?? [];
  return all.where((p) => p.status == DonationStatus.draft).toList();
});

// Completed donations history
final completedDonationsProvider = Provider<List<DonationPackage>>((ref) {
  final listAsync = ref.watch(donationPackagesProvider);
  final all = listAsync.value ?? [];
  return all.where((p) => p.status == DonationStatus.completedLocally).toList();
});

// Eligible food items with eligibility details
class EligibleFoodWrapper {
  final FoodItem food;
  final DonationEligibilityResult eligibility;

  const EligibleFoodWrapper({
    required this.food,
    required this.eligibility,
  });
}

final eligibleDonationFoodsProvider =
    Provider<AsyncValue<List<EligibleFoodWrapper>>>((ref) {
  final foodsAsync = ref.watch(foodsListProvider);

  return foodsAsync.whenData((foods) {
    final now = DateTime.now();
    final results = <EligibleFoodWrapper>[];

    for (final food in foods) {
      final eligibility = DonationEligibilityChecker.check(food, now);
      if (eligibility.isEligible) {
        results.add(EligibleFoodWrapper(food: food, eligibility: eligibility));
      }
    }

    return results;
  });
});

// Featured campaign package ("Kış Dayanışması Erzak Paketi")
final campaignDonationPackageProvider = Provider<DonationPackage?>((ref) {
  final list = ref.watch(activeDonationDraftsProvider);
  try {
    return list.firstWhere((p) => p.id == 'winter_donation_campaign_1');
  } catch (_) {
    return list.isNotEmpty ? list.first : null;
  }
});

// Single package detail provider
final donationPackageDetailProvider =
    FutureProvider.family<DonationPackage?, String>((ref, id) async {
  final repo = ref.watch(donationRepositoryProvider);
  return repo.getPackageById(id);
});

// Donation Controller class for high-level UI actions
class DonationController {
  final Ref _ref;
  final Uuid _uuid;

  DonationController(this._ref, [Uuid? uuid]) : _uuid = uuid ?? const Uuid();

  Future<String> createDraft({
    required String title,
    required String description,
    required List<String> itemIds,
    String? targetCenterId,
    String? targetCenterName,
    String? notes,
  }) async {
    final now = DateTime.now();
    final newPackage = DonationPackage(
      id: _uuid.v4(),
      title: title,
      description: description,
      itemIds: itemIds,
      targetCenterId: targetCenterId,
      targetCenterName: targetCenterName,
      status: DonationStatus.draft,
      createdAt: now,
      updatedAt: now,
      notes: notes,
    );

    await _ref.read(donationPackagesProvider.notifier).savePackage(newPackage);
    return newPackage.id;
  }

  Future<void> toggleItemInDraft(String draftId, String foodId) async {
    final packages = _ref.read(donationPackagesProvider).value ?? [];
    final draft = packages.firstWhere((p) => p.id == draftId);

    if (draft.itemIds.contains(foodId)) {
      await _ref.read(donationPackagesProvider.notifier).removeItem(draftId, foodId);
    } else {
      await _ref.read(donationPackagesProvider.notifier).addItem(draftId, foodId);
    }
  }

  Future<void> completeDraft(String draftId) async {
    await _ref.read(donationPackagesProvider.notifier).completePackage(draftId);
  }

  Future<void> deleteDraft(String draftId) async {
    await _ref.read(donationPackagesProvider.notifier).deletePackage(draftId);
  }
}

final donationControllerProvider = Provider<DonationController>((ref) {
  return DonationController(ref);
});
