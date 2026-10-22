import '../../../../core/models/enums.dart';

class ConsumptionEvent {
  final String id;
  final String foodItemId;
  final String foodName;
  final double quantity;
  final String unit;
  final FoodCategory category;
  final StorageLocation storageLocation;
  final double? price;
  final bool isWasted; // true: israf oldu, false: kurtarıldı (tüketildi)
  final DateTime timestamp;
  final String? note;

  const ConsumptionEvent({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.storageLocation,
    this.price,
    required this.isWasted,
    required this.timestamp,
    this.note,
  });
}
