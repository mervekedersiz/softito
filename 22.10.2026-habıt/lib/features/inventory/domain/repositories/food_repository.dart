import '../../../statistics/domain/entities/consumption_event.dart';
import '../entities/food_item.dart';

abstract class FoodRepository {
  Future<List<FoodItem>> getFoods();
  Future<FoodItem?> getFoodById(String id);
  Future<void> addFood(FoodItem food);
  Future<void> updateFood(FoodItem food);
  Future<void> deleteFood(String id);
  Future<void> consumeFood(String id, {double? consumedQuantity, double? customPrice});
  Future<void> wasteFood(String id, {String? reason});
  Future<List<ConsumptionEvent>> getConsumptionEvents();
  Future<void> addConsumptionEvent(ConsumptionEvent event);
  Future<void> resetAllData();
  Future<void> toggleReserveForDonation(String id, bool isReserved);
  Future<void> toggleReserveForRecipe(String id, bool isReserved);
}
