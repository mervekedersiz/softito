import '../../../statistics/domain/entities/consumption_event.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/local_food_datasource.dart';

class FoodRepositoryImpl implements FoodRepository {
  final LocalFoodDatasource _datasource;

  FoodRepositoryImpl({LocalFoodDatasource? datasource})
      : _datasource = datasource ?? LocalFoodDatasource();

  @override
  Future<List<FoodItem>> getFoods() => _datasource.getFoods();

  @override
  Future<FoodItem?> getFoodById(String id) => _datasource.getFoodById(id);

  @override
  Future<void> addFood(FoodItem food) => _datasource.saveFood(food);

  @override
  Future<void> updateFood(FoodItem food) => _datasource.saveFood(food);

  @override
  Future<void> deleteFood(String id) => _datasource.deleteFood(id);

  @override
  Future<void> consumeFood(String id, {double? consumedQuantity, double? customPrice}) =>
      _datasource.recordConsumption(
        id,
        isWasted: false,
        consumedQuantity: consumedQuantity,
        customPrice: customPrice,
      );

  @override
  Future<void> wasteFood(String id, {String? reason}) => _datasource.recordConsumption(
        id,
        isWasted: true,
        note: reason,
      );

  @override
  Future<List<ConsumptionEvent>> getConsumptionEvents() => _datasource.getEvents();

  @override
  Future<void> addConsumptionEvent(ConsumptionEvent event) => _datasource.addEvent(event);

  @override
  Future<void> resetAllData() => _datasource.resetAll();

  @override
  Future<void> toggleReserveForDonation(String id, bool isReserved) async {
    final food = await getFoodById(id);
    if (food != null) {
      await updateFood(food.copyWith(isReservedForDonation: isReserved));
    }
  }

  @override
  Future<void> toggleReserveForRecipe(String id, bool isReserved) async {
    final food = await getFoodById(id);
    if (food != null) {
      await updateFood(food.copyWith(isReservedForRecipe: isReserved));
    }
  }
}
