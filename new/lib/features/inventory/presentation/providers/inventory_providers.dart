import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/date_status.dart';
import '../../data/datasources/local_food_datasource.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/repositories/food_repository.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final localFoodDatasourceProvider = Provider<LocalFoodDatasource>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LocalFoodDatasource(storageService: storage);
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final ds = ref.watch(localFoodDatasourceProvider);
  return FoodRepositoryImpl(datasource: ds);
});

// Inventory filter state
class InventoryFilterState {
  final String query;
  final StorageLocation? storageLocation;
  final FoodCategory? category;
  final UrgencyStatus? urgency;
  final bool onlyUrgent;
  final String sortOrder; // 'expiry', 'name', 'created'

  const InventoryFilterState({
    this.query = '',
    this.storageLocation,
    this.category,
    this.urgency,
    this.onlyUrgent = false,
    this.sortOrder = 'expiry',
  });

  InventoryFilterState copyWith({
    String? query,
    StorageLocation? storageLocation,
    FoodCategory? category,
    UrgencyStatus? urgency,
    bool? onlyUrgent,
    String? sortOrder,
    bool clearLocation = false,
    bool clearCategory = false,
    bool clearUrgency = false,
  }) {
    return InventoryFilterState(
      query: query ?? this.query,
      storageLocation: clearLocation ? null : (storageLocation ?? this.storageLocation),
      category: clearCategory ? null : (category ?? this.category),
      urgency: clearUrgency ? null : (urgency ?? this.urgency),
      onlyUrgent: onlyUrgent ?? this.onlyUrgent,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class InventoryFilterNotifier extends Notifier<InventoryFilterState> {
  @override
  InventoryFilterState build() => const InventoryFilterState();

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setStorageLocation(StorageLocation? loc) {
    if (state.storageLocation == loc) {
      state = state.copyWith(clearLocation: true);
    } else {
      state = state.copyWith(storageLocation: loc);
    }
  }

  void setCategory(FoodCategory? cat) {
    if (state.category == cat) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(category: cat);
    }
  }

  void toggleOnlyUrgent() {
    state = state.copyWith(onlyUrgent: !state.onlyUrgent);
  }

  void setSortOrder(String sort) {
    state = state.copyWith(sortOrder: sort);
  }

  void reset() {
    state = const InventoryFilterState();
  }
}

final inventoryFilterProvider =
    NotifierProvider<InventoryFilterNotifier, InventoryFilterState>(
  InventoryFilterNotifier.new,
);

// All active foods notifier
class FoodsListNotifier extends AsyncNotifier<List<FoodItem>> {
  @override
  Future<List<FoodItem>> build() async {
    final repo = ref.watch(foodRepositoryProvider);
    final all = await repo.getFoods();
    // Return non-consumed, non-wasted items
    return all.where((f) => !f.isConsumed && !f.isWasted).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(foodRepositoryProvider);
      final all = await repo.getFoods();
      return all.where((f) => !f.isConsumed && !f.isWasted).toList();
    });
  }

  Future<void> addFood(FoodItem food) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.addFood(food);
    await refresh();
  }

  Future<void> updateFood(FoodItem food) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.updateFood(food);
    await refresh();
  }

  Future<void> deleteFood(String id) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.deleteFood(id);
    await refresh();
  }

  Future<void> consumeFood(String id, {double? quantity, double? customPrice}) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.consumeFood(id, consumedQuantity: quantity, customPrice: customPrice);
    await refresh();
  }

  Future<void> wasteFood(String id, {String? reason}) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.wasteFood(id, reason: reason);
    await refresh();
  }
}

final foodsListProvider =
    AsyncNotifierProvider<FoodsListNotifier, List<FoodItem>>(
  FoodsListNotifier.new,
);

// Derived filtered foods provider
final filteredFoodsProvider = Provider<AsyncValue<List<FoodItem>>>((ref) {
  final foodsAsync = ref.watch(foodsListProvider);
  final filter = ref.watch(inventoryFilterProvider);

  return foodsAsync.whenData((foods) {
    final now = DateTime.now();
    var list = foods.where((item) {
      // Query filter
      if (filter.query.isNotEmpty) {
        final q = filter.query.toLowerCase().trim();
        final matchesName = item.name.toLowerCase().contains(q);
        final matchesCat = item.category.label.toLowerCase().contains(q);
        final matchesLoc = item.storageLocation.label.toLowerCase().contains(q);
        if (!matchesName && !matchesCat && !matchesLoc) return false;
      }
      // Location filter
      if (filter.storageLocation != null &&
          item.storageLocation != filter.storageLocation) {
        return false;
      }
      // Category filter
      if (filter.category != null && item.category != filter.category) {
        return false;
      }
      // Urgent filter
      if (filter.onlyUrgent) {
        final urgency = classifyDate(now, item.expiryDate);
        if (urgency != UrgencyStatus.today &&
            urgency != UrgencyStatus.urgent &&
            urgency != UrgencyStatus.expired) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sort
    if (filter.sortOrder == 'name') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (filter.sortOrder == 'created') {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      // Default: expiry date
      list.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    }

    return list;
  });
});

// Kitchen Balance Summary (Kritik, Yaklaşan, Güvende)
class KitchenBalance {
  final int totalCount;
  final int criticalCount; // 1-2 gün / bugün / geçmiş
  final int upcomingCount; // 3-5 gün
  final int safeCount; // 6+ gün
  final int fridgeCount;
  final int freezerCount;
  final int pantryCount;

  const KitchenBalance({
    required this.totalCount,
    required this.criticalCount,
    required this.upcomingCount,
    required this.safeCount,
    required this.fridgeCount,
    required this.freezerCount,
    required this.pantryCount,
  });
}

final kitchenBalanceProvider = Provider<KitchenBalance>((ref) {
  final foodsAsync = ref.watch(foodsListProvider);
  final foods = foodsAsync.value ?? [];
  final now = DateTime.now();

  int crit = 0;
  int up = 0;
  int safe = 0;
  int fridge = 0;
  int freezer = 0;
  int pantry = 0;

  for (final f in foods) {
    final urg = classifyDate(now, f.expiryDate);
    if (urg == UrgencyStatus.today ||
        urg == UrgencyStatus.urgent ||
        urg == UrgencyStatus.expired) {
      crit++;
    } else if (urg == UrgencyStatus.upcoming) {
      up++;
    } else {
      safe++;
    }

    if (f.storageLocation == StorageLocation.fridge) fridge++;
    if (f.storageLocation == StorageLocation.freezer) freezer++;
    if (f.storageLocation == StorageLocation.pantry) pantry++;
  }

  return KitchenBalance(
    totalCount: foods.length,
    criticalCount: crit,
    upcomingCount: up,
    safeCount: safe,
    fridgeCount: fridge,
    freezerCount: freezer,
    pantryCount: pantry,
  );
});

// Single food detail provider family
final foodDetailProvider =
    FutureProvider.family<FoodItem?, String>((ref, id) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getFoodById(id);
});
