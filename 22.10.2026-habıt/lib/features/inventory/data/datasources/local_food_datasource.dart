import 'package:uuid/uuid.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/services/storage_service.dart';
import '../../../donations/data/models/donation_package_model.dart';
import '../../../donations/domain/entities/donation_package.dart';
import '../../../statistics/data/models/consumption_event_model.dart';
import '../../../statistics/domain/entities/consumption_event.dart';
import '../../domain/entities/food_item.dart';
import '../models/food_item_model.dart';

class LocalFoodDatasource {
  final StorageService _storageService;
  final Uuid _uuid;

  LocalFoodDatasource({StorageService? storageService, Uuid? uuid})
    : _storageService = storageService ?? StorageService(),
      _uuid = uuid ?? const Uuid();

  // Internal memory cache of state snapshot
  Map<String, dynamic>? _cachedSnapshot;
  Future<void> _snapshotWrites = Future<void>.value();

  Future<Map<String, dynamic>> getDonationLocationRecords() async {
    await _snapshotWrites;
    final snapshot = await _getOrInitSnapshot();
    return Map<String, dynamic>.from(
      snapshot['donationLocations'] as Map? ?? const {},
    );
  }

  Future<void> saveDonationLocationRecord(
    String kind,
    Map<String, dynamic>? record,
  ) {
    final write = _snapshotWrites.then((_) async {
      final snapshot = Map<String, dynamic>.from(await _getOrInitSnapshot());
      final locations = Map<String, dynamic>.from(
        snapshot['donationLocations'] as Map? ?? const {},
      );
      if (record == null) {
        locations.remove(kind);
      } else {
        locations[kind] = record;
      }
      snapshot['donationLocations'] = locations;
      await _storageService.saveSnapshotStrict(snapshot);
      _cachedSnapshot = snapshot;
    });
    _snapshotWrites = write.catchError((Object _, StackTrace __) {});
    return write;
  }

  Future<Map<String, dynamic>> _getOrInitSnapshot() async {
    if (_cachedSnapshot != null) return _cachedSnapshot!;

    final loaded = await _storageService.loadSnapshot();
    if (loaded != null && loaded['foods'] != null) {
      _cachedSnapshot = loaded;
      return _cachedSnapshot!;
    }

    // Seed default dataset matching UI designs
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final seedFoods = <FoodItem>[
      // Buzdolabı (12 items)
      FoodItem(
        id: 'food_milk_1',
        name: 'Organik Köy Sütü',
        quantity: 1,
        unit: 'L',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Üst Raf (1L)',
        dateType: DateType.stt,
        expiryDate: today, // Bugün son gün
        purchasePrice: 35.0,
        packageStatus: PackageStatus.unopened,
        note: 'Tam Şişe',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_cheese_1',
        name: 'Taze Kaşar Peyniri',
        quantity: 400,
        unit: 'g',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Kahvaltılık (400g)',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 3)), // 3 gün kaldı
        purchasePrice: 95.0,
        packageStatus: PackageStatus.opened,
        openedDaysAgo: 2,
        note: 'Açıldı: 2 gün önce',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_chicken_1',
        name: 'Tavuk Göğsü',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.meat,
        storageLocation: StorageLocation.fridge,
        subLocation: '0-4°C Rafında',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 1)), // Yarın (1 gün)
        purchasePrice: 85.0,
        packageStatus: PackageStatus.unopened,
        note: '0-4°C Rafında',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_mushroom_1',
        name: 'Kültür Mantarı',
        quantity: 300,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Sebzelik Çekmecesi',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 2)), // 2 gün kaldı
        purchasePrice: 42.0,
        packageStatus: PackageStatus.unopened,
        note: 'Sebzelik',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_yogurt_1',
        name: 'Süzme Yoğurt',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Orta Raf',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 5)),
        purchasePrice: 45.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_eggs_1',
        name: 'Organik Yumurta',
        quantity: 10,
        unit: 'adet',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Kapak Rafı',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 10)),
        purchasePrice: 55.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_butter_1',
        name: 'Köy Tereyağı',
        quantity: 250,
        unit: 'g',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Kahvaltılık',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 15)),
        purchasePrice: 80.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_tomatoes_1',
        name: 'Salkım Domates',
        quantity: 1,
        unit: 'kg',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Sebzelik',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 4)),
        purchasePrice: 30.0,
        packageStatus: PackageStatus.opened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_cucumbers_1',
        name: 'Çengelköy Salatalık',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Sebzelik',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 4)),
        purchasePrice: 20.0,
        packageStatus: PackageStatus.opened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_lemon_1',
        name: 'Limon',
        quantity: 4,
        unit: 'adet',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Kapak Rafı',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 14)),
        purchasePrice: 15.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_carrots_1',
        name: 'Havuç',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Sebzelik',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 8)),
        purchasePrice: 18.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_cream_1',
        name: 'Sıvı Krema',
        quantity: 200,
        unit: 'ml',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        subLocation: 'Kapak Rafı',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 7)),
        purchasePrice: 28.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),

      // Dondurucu (4 items)
      FoodItem(
        id: 'food_salmon_1',
        name: 'Somon Fileto',
        quantity: 350,
        unit: 'g',
        category: FoodCategory.meat,
        storageLocation: StorageLocation.freezer,
        subLocation: 'Üst Çekmece (350g)',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 20)),
        purchasePrice: 160.0,
        packageStatus: PackageStatus.unopened,
        note: 'Vakumlu Paket',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_peas_1',
        name: 'Dondurulmuş Bezelye',
        quantity: 450,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.freezer,
        subLocation: 'Orta Çekmece',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 60)),
        purchasePrice: 35.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_spinach_1',
        name: 'Dondurulmuş Ispanak',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.freezer,
        subLocation: 'Orta Çekmece',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 45)),
        purchasePrice: 32.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_mince_1',
        name: 'Dana Kıyma',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.meat,
        storageLocation: StorageLocation.freezer,
        subLocation: 'Alt Çekmece',
        dateType: DateType.stt,
        expiryDate: today.add(const Duration(days: 30)),
        purchasePrice: 210.0,
        packageStatus: PackageStatus.unopened,
        createdAt: now,
        updatedAt: now,
      ),

      // Kiler (2 items)
      FoodItem(
        id: 'food_lentils_1',
        name: 'Kırmızı Mercimek',
        quantity: 1,
        unit: 'kg',
        category: FoodCategory.pantry,
        storageLocation: StorageLocation.pantry,
        subLocation: 'Bakliyat Kavanozu (1kg)',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 180)),
        purchasePrice: 45.0,
        packageStatus: PackageStatus.unopened,
        note: 'Kavanoz Açılmadı',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      FoodItem(
        id: 'food_pasta_1',
        name: 'Burgu Makarna',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.pantry,
        storageLocation: StorageLocation.pantry,
        subLocation: 'Kuru Gıda Rafı',
        dateType: DateType.tett,
        expiryDate: today.add(const Duration(days: 210)),
        purchasePrice: 22.0,
        packageStatus: PackageStatus.unopened,
        note: 'Kapalı Ambalaj',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
    ];

    final seedEvents = <ConsumptionEvent>[
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_milk_prev',
        foodName: 'Köy Sütü (1L)',
        quantity: 1,
        unit: 'L',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        price: 35.0,
        isWasted: false,
        timestamp: now.subtract(const Duration(hours: 2)),
        note: 'Bugün 14:20 • Buzdolabı',
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_mushroom_prev',
        foodName: 'Mantar (300g)',
        quantity: 300,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        price: 42.0,
        isWasted: false,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        note: 'Dün 19:10 • Buzdolabı',
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_parsley_prev',
        foodName: 'Maydanoz (1 Demet)',
        quantity: 1,
        unit: 'demet',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        price: 15.0,
        isWasted: true,
        timestamp: now.subtract(const Duration(days: 2)),
        note: '2 gün önce • Sebzelik',
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_beef_prev',
        foodName: 'Kuşbaşı Et (400g)',
        quantity: 400,
        unit: 'g',
        category: FoodCategory.meat,
        storageLocation: StorageLocation.fridge,
        price: 180.0,
        isWasted: false,
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_cheese_prev',
        foodName: 'Beyaz Peynir (500g)',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.dairy,
        storageLocation: StorageLocation.fridge,
        price: 120.0,
        isWasted: false,
        timestamp: now.subtract(const Duration(days: 4)),
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_spinach_prev',
        foodName: 'Taze Ispanak',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.produce,
        storageLocation: StorageLocation.fridge,
        price: 47.0,
        isWasted: true,
        timestamp: now.subtract(const Duration(days: 5)),
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_pasta_prev',
        foodName: 'Fiyonk Makarna',
        quantity: 500,
        unit: 'g',
        category: FoodCategory.pantry,
        storageLocation: StorageLocation.pantry,
        price: 22.0,
        isWasted: false,
        timestamp: now.subtract(const Duration(days: 6)),
      ),
      ConsumptionEvent(
        id: _uuid.v4(),
        foodItemId: 'seed_fish_prev',
        foodName: 'Levrek Fileto',
        quantity: 400,
        unit: 'g',
        category: FoodCategory.meat,
        storageLocation: StorageLocation.freezer,
        price: 86.5,
        isWasted: false,
        timestamp: now.subtract(const Duration(days: 7)),
      ),
    ];

    // Initial campaign donation draft (2/3 items)
    final seedDonationPackages = <DonationPackage>[
      DonationPackage(
        id: 'winter_donation_campaign_1',
        title: 'Kış Dayanışması Erzak Paketi',
        description:
            'Kilerindeki kullanılmayan 3 kuru bakliyatı birleştirerek yerel öğrenci evleri ve dayanışma mutfaklarına doğrudan ulaştır.',
        itemIds: ['food_lentils_1', 'food_pasta_1'], // 2 of 3 items
        targetCenterId: 'kadikoy_asevi',
        targetCenterName: 'Kadıköy Aşevi & Gıda Bankası',
        status: DonationStatus.draft,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
        notes: 'Nohut veya Pirinç eklenirse hazır',
      ),
    ];

    final initialSnapshot = {
      'schemaVersion': 1,
      'foods': seedFoods.map(FoodItemModel.toJson).toList(),
      'events': seedEvents.map(ConsumptionEventModel.toJson).toList(),
      'donationPackages': seedDonationPackages
          .map(DonationPackageModel.toJson)
          .toList(),
      'reservedRecipeIds': <String>[],
      'todayMealRecipeIds': <String>['recipe_chicken_mushroom'],
      'savedBookmarks': <String>['recipe_chicken_mushroom'],
    };

    _cachedSnapshot = initialSnapshot;
    await _storageService.saveSnapshot(initialSnapshot);
    return _cachedSnapshot!;
  }

  Future<void> _commit(Map<String, dynamic> snapshot) {
    final write = _snapshotWrites.then((_) async {
      final next = Map<String, dynamic>.from(snapshot);
      // A food/package operation may have started before a location save.
      // Carry the latest committed pins into that operation's snapshot.
      final locations = _cachedSnapshot?['donationLocations'];
      if (locations != null) next['donationLocations'] = locations;
      await _storageService.saveSnapshot(next);
      _cachedSnapshot = next;
    });
    _snapshotWrites = write.catchError((Object _, StackTrace __) {});
    return write;
  }

  Future<List<FoodItem>> getFoods() async {
    final snap = await _getOrInitSnapshot();
    final list = snap['foods'] as List<dynamic>? ?? [];
    return list
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FoodItem?> getFoodById(String id) async {
    final foods = await getFoods();
    try {
      return foods.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveFood(FoodItem food) async {
    final snap = await _getOrInitSnapshot();
    final list = (snap['foods'] as List<dynamic>? ?? [])
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final idx = list.indexWhere((e) => e.id == food.id);
    if (idx >= 0) {
      list[idx] = food;
    } else {
      list.add(food);
    }

    snap['foods'] = list.map(FoodItemModel.toJson).toList();
    await _commit(snap);
  }

  Future<void> deleteFood(String id) async {
    final snap = await _getOrInitSnapshot();
    final list = (snap['foods'] as List<dynamic>? ?? [])
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    list.removeWhere((e) => e.id == id);
    snap['foods'] = list.map(FoodItemModel.toJson).toList();

    // Also remove item from any active donation package draft
    final packages = (snap['donationPackages'] as List<dynamic>? ?? [])
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();
    for (var i = 0; i < packages.length; i++) {
      if (packages[i].itemIds.contains(id)) {
        final updatedIds = List<String>.from(packages[i].itemIds)..remove(id);
        packages[i] = packages[i].copyWith(
          itemIds: updatedIds,
          updatedAt: DateTime.now(),
        );
      }
    }
    snap['donationPackages'] = packages
        .map(DonationPackageModel.toJson)
        .toList();

    await _commit(snap);
  }

  Future<void> recordConsumption(
    String id, {
    required bool isWasted,
    double? consumedQuantity,
    double? customPrice,
    String? note,
  }) async {
    final snap = await _getOrInitSnapshot();
    final foods = (snap['foods'] as List<dynamic>? ?? [])
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final idx = foods.indexWhere((e) => e.id == id);
    if (idx < 0) return;

    final target = foods[idx];
    final qty = consumedQuantity ?? target.quantity;
    final price = customPrice ?? target.purchasePrice;

    // Create event
    final event = ConsumptionEvent(
      id: _uuid.v4(),
      foodItemId: target.id,
      foodName:
          '${target.name} (${target.quantity.toStringAsFixed(0)}${target.unit})',
      quantity: qty,
      unit: target.unit,
      category: target.category,
      storageLocation: target.storageLocation,
      price: price,
      isWasted: isWasted,
      timestamp: DateTime.now(),
      note: note,
    );

    // Update food item
    if (qty >= target.quantity) {
      foods[idx] = target.copyWith(
        isConsumed: !isWasted,
        isWasted: isWasted,
        updatedAt: DateTime.now(),
      );
    } else {
      // Partial consumption: decrease remaining quantity
      foods[idx] = target.copyWith(
        quantity: target.quantity - qty,
        updatedAt: DateTime.now(),
      );
    }

    final events = (snap['events'] as List<dynamic>? ?? [])
        .map((e) => ConsumptionEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    events.insert(0, event);

    snap['foods'] = foods.map(FoodItemModel.toJson).toList();
    snap['events'] = events.map(ConsumptionEventModel.toJson).toList();
    await _commit(snap);
  }

  Future<List<ConsumptionEvent>> getEvents() async {
    final snap = await _getOrInitSnapshot();
    final list = snap['events'] as List<dynamic>? ?? [];
    return list
        .map((e) => ConsumptionEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addEvent(ConsumptionEvent event) async {
    final snap = await _getOrInitSnapshot();
    final events = (snap['events'] as List<dynamic>? ?? [])
        .map((e) => ConsumptionEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    events.insert(0, event);
    snap['events'] = events.map(ConsumptionEventModel.toJson).toList();
    await _commit(snap);
  }

  // --- Donation Packages ---
  Future<List<DonationPackage>> getDonationPackages() async {
    final snap = await _getOrInitSnapshot();
    final list = snap['donationPackages'] as List<dynamic>? ?? [];
    return list
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DonationPackage?> getDonationPackageById(String id) async {
    final list = await getDonationPackages();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDonationPackage(DonationPackage package) async {
    final snap = await _getOrInitSnapshot();
    final packages = (snap['donationPackages'] as List<dynamic>? ?? [])
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final idx = packages.indexWhere((e) => e.id == package.id);
    if (idx >= 0) {
      packages[idx] = package;
    } else {
      packages.add(package);
    }

    // Update foods reservation status
    final foods = (snap['foods'] as List<dynamic>? ?? [])
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    for (var i = 0; i < foods.length; i++) {
      if (package.itemIds.contains(foods[i].id)) {
        foods[i] = foods[i].copyWith(isReservedForDonation: true);
      }
    }

    snap['foods'] = foods.map(FoodItemModel.toJson).toList();
    snap['donationPackages'] = packages
        .map(DonationPackageModel.toJson)
        .toList();
    await _commit(snap);
  }

  Future<void> deleteDonationPackage(String id) async {
    final snap = await _getOrInitSnapshot();
    final packages = (snap['donationPackages'] as List<dynamic>? ?? [])
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final target = packages.firstWhere(
      (e) => e.id == id,
      orElse: () => DonationPackage(
        id: '',
        title: '',
        description: '',
        itemIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    packages.removeWhere((e) => e.id == id);

    // Unreserve items
    final foods = (snap['foods'] as List<dynamic>? ?? [])
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    for (var i = 0; i < foods.length; i++) {
      if (target.itemIds.contains(foods[i].id)) {
        foods[i] = foods[i].copyWith(isReservedForDonation: false);
      }
    }

    snap['foods'] = foods.map(FoodItemModel.toJson).toList();
    snap['donationPackages'] = packages
        .map(DonationPackageModel.toJson)
        .toList();
    await _commit(snap);
  }

  Future<void> completeDonationPackage(String id) async {
    final snap = await _getOrInitSnapshot();
    final packages = (snap['donationPackages'] as List<dynamic>? ?? [])
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final idx = packages.indexWhere((e) => e.id == id);
    if (idx < 0) return;

    final target = packages[idx];
    final updated = target.copyWith(
      status: DonationStatus.completedLocally,
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    packages[idx] = updated;

    // Mark items as consumed / donated
    final foods = (snap['foods'] as List<dynamic>? ?? [])
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    for (var i = 0; i < foods.length; i++) {
      if (target.itemIds.contains(foods[i].id)) {
        foods[i] = foods[i].copyWith(
          isConsumed: true,
          isReservedForDonation: false,
          updatedAt: DateTime.now(),
        );
      }
    }

    snap['foods'] = foods.map(FoodItemModel.toJson).toList();
    snap['donationPackages'] = packages
        .map(DonationPackageModel.toJson)
        .toList();
    await _commit(snap);
  }

  Future<void> addItemToDonationPackage(
    String packageId,
    String foodItemId,
  ) async {
    final snap = await _getOrInitSnapshot();
    final packages = (snap['donationPackages'] as List<dynamic>? ?? [])
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final idx = packages.indexWhere((e) => e.id == packageId);
    if (idx < 0) return;

    final target = packages[idx];
    if (!target.itemIds.contains(foodItemId)) {
      final updatedIds = List<String>.from(target.itemIds)..add(foodItemId);
      packages[idx] = target.copyWith(
        itemIds: updatedIds,
        updatedAt: DateTime.now(),
      );

      // Reserve item in foods
      final foods = (snap['foods'] as List<dynamic>? ?? [])
          .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final foodIdx = foods.indexWhere((e) => e.id == foodItemId);
      if (foodIdx >= 0) {
        foods[foodIdx] = foods[foodIdx].copyWith(isReservedForDonation: true);
      }
      snap['foods'] = foods.map(FoodItemModel.toJson).toList();
      snap['donationPackages'] = packages
          .map(DonationPackageModel.toJson)
          .toList();
      await _commit(snap);
    }
  }

  Future<void> removeItemFromDonationPackage(
    String packageId,
    String foodItemId,
  ) async {
    final snap = await _getOrInitSnapshot();
    final packages = (snap['donationPackages'] as List<dynamic>? ?? [])
        .map((e) => DonationPackageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final idx = packages.indexWhere((e) => e.id == packageId);
    if (idx < 0) return;

    final target = packages[idx];
    if (target.itemIds.contains(foodItemId)) {
      final updatedIds = List<String>.from(target.itemIds)..remove(foodItemId);
      packages[idx] = target.copyWith(
        itemIds: updatedIds,
        updatedAt: DateTime.now(),
      );

      // Unreserve item in foods
      final foods = (snap['foods'] as List<dynamic>? ?? [])
          .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final foodIdx = foods.indexWhere((e) => e.id == foodItemId);
      if (foodIdx >= 0) {
        foods[foodIdx] = foods[foodIdx].copyWith(isReservedForDonation: false);
      }
      snap['foods'] = foods.map(FoodItemModel.toJson).toList();
      snap['donationPackages'] = packages
          .map(DonationPackageModel.toJson)
          .toList();
      await _commit(snap);
    }
  }

  Future<void> resetAll() async {
    _cachedSnapshot = null;
    await _storageService.clearAll();
    await _getOrInitSnapshot();
  }
}
