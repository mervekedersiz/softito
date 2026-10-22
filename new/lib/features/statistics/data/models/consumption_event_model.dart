import '../../../../core/models/enums.dart';
import '../../domain/entities/consumption_event.dart';

class ConsumptionEventModel {
  static Map<String, dynamic> toJson(ConsumptionEvent event) {
    return {
      'id': event.id,
      'foodItemId': event.foodItemId,
      'foodName': event.foodName,
      'quantity': event.quantity,
      'unit': event.unit,
      'category': event.category.name,
      'storageLocation': event.storageLocation.name,
      'price': event.price,
      'isWasted': event.isWasted,
      'timestamp': event.timestamp.toIso8601String(),
      'note': event.note,
    };
  }

  static ConsumptionEvent fromJson(Map<String, dynamic> json) {
    return ConsumptionEvent(
      id: json['id'] as String,
      foodItemId: json['foodItemId'] as String,
      foodName: json['foodName'] as String,
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
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      isWasted: json['isWasted'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
    );
  }
}
