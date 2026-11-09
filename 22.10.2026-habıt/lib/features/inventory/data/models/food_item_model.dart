import '../../../../core/models/enums.dart';
import '../../domain/entities/food_item.dart';

class FoodItemModel {
  static Map<String, dynamic> toJson(FoodItem item) {
    return {
      'id': item.id,
      'name': item.name,
      'quantity': item.quantity,
      'unit': item.unit,
      'category': item.category.name,
      'storageLocation': item.storageLocation.name,
      'subLocation': item.subLocation,
      'dateType': item.dateType.name,
      'expiryDate': item.expiryDate.toIso8601String(),
      'purchasePrice': item.purchasePrice,
      'note': item.note,
      'packageStatus': item.packageStatus.name,
      'openedDaysAgo': item.openedDaysAgo,
      'isConsumed': item.isConsumed,
      'isWasted': item.isWasted,
      'isReservedForDonation': item.isReservedForDonation,
      'isReservedForRecipe': item.isReservedForRecipe,
      'createdAt': item.createdAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
    };
  }

  static FoodItem fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'adet',
      category: FoodCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => FoodCategory.other,
      ),
      storageLocation: StorageLocation.values.firstWhere(
        (e) => e.name == json['storageLocation'],
        orElse: () => StorageLocation.fridge,
      ),
      subLocation: json['subLocation'] as String? ?? '',
      dateType: DateType.values.firstWhere(
        (e) => e.name == json['dateType'],
        orElse: () => DateType.stt,
      ),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      purchasePrice: json['purchasePrice'] != null
          ? (json['purchasePrice'] as num).toDouble()
          : null,
      note: json['note'] as String?,
      packageStatus: PackageStatus.values.firstWhere(
        (e) => e.name == json['packageStatus'],
        orElse: () => PackageStatus.unopened,
      ),
      openedDaysAgo: json['openedDaysAgo'] as int?,
      isConsumed: json['isConsumed'] as bool? ?? false,
      isWasted: json['isWasted'] as bool? ?? false,
      isReservedForDonation: json['isReservedForDonation'] as bool? ?? false,
      isReservedForRecipe: json['isReservedForRecipe'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}
