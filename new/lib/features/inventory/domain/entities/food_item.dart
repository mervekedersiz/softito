import '../../../../core/models/enums.dart';

class FoodItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final FoodCategory category;
  final StorageLocation storageLocation;
  final String subLocation;
  final DateType dateType;
  final DateTime expiryDate;
  final double? purchasePrice;
  final String? note;
  final PackageStatus packageStatus;
  final int? openedDaysAgo;
  final bool isConsumed;
  final bool isWasted;
  final bool isReservedForDonation;
  final bool isReservedForRecipe;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.storageLocation,
    this.subLocation = '',
    required this.dateType,
    required this.expiryDate,
    this.purchasePrice,
    this.note,
    this.packageStatus = PackageStatus.unopened,
    this.openedDaysAgo,
    this.isConsumed = false,
    this.isWasted = false,
    this.isReservedForDonation = false,
    this.isReservedForRecipe = false,
    required this.createdAt,
    required this.updatedAt,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    FoodCategory? category,
    StorageLocation? storageLocation,
    String? subLocation,
    DateType? dateType,
    DateTime? expiryDate,
    double? purchasePrice,
    String? note,
    PackageStatus? packageStatus,
    int? openedDaysAgo,
    bool? isConsumed,
    bool? isWasted,
    bool? isReservedForDonation,
    bool? isReservedForRecipe,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      storageLocation: storageLocation ?? this.storageLocation,
      subLocation: subLocation ?? this.subLocation,
      dateType: dateType ?? this.dateType,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      note: note ?? this.note,
      packageStatus: packageStatus ?? this.packageStatus,
      openedDaysAgo: openedDaysAgo ?? this.openedDaysAgo,
      isConsumed: isConsumed ?? this.isConsumed,
      isWasted: isWasted ?? this.isWasted,
      isReservedForDonation: isReservedForDonation ?? this.isReservedForDonation,
      isReservedForRecipe: isReservedForRecipe ?? this.isReservedForRecipe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
