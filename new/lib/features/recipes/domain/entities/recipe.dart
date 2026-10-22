import '../../../../core/models/enums.dart';

class RecipeIngredient {
  final String name;
  final double amount;
  final String unit;
  final FoodCategory category;
  final bool isOptional;
  final String? inventoryMatchId;

  const RecipeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    this.isOptional = false,
    this.inventoryMatchId,
  });

  RecipeIngredient copyWith({
    String? name,
    double? amount,
    String? unit,
    FoodCategory? category,
    bool? isOptional,
    String? inventoryMatchId,
  }) {
    return RecipeIngredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isOptional: isOptional ?? this.isOptional,
      inventoryMatchId: inventoryMatchId ?? this.inventoryMatchId,
    );
  }
}

class Recipe {
  final String id;
  final String name;
  final int cookingTimeMinutes;
  final int servings;
  final String difficulty;
  final String subtitle;
  final String rescuedDescription;
  final List<RecipeIngredient> ingredients;
  final List<String> instructions;
  final bool isBookmarked;
  final bool isPlannedForToday;

  const Recipe({
    required this.id,
    required this.name,
    required this.cookingTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.subtitle,
    required this.rescuedDescription,
    required this.ingredients,
    required this.instructions,
    this.isBookmarked = false,
    this.isPlannedForToday = false,
  });

  Recipe copyWith({
    String? id,
    String? name,
    int? cookingTimeMinutes,
    int? servings,
    String? difficulty,
    String? subtitle,
    String? rescuedDescription,
    List<RecipeIngredient>? ingredients,
    List<String>? instructions,
    bool? isBookmarked,
    bool? isPlannedForToday,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      cookingTimeMinutes: cookingTimeMinutes ?? this.cookingTimeMinutes,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      subtitle: subtitle ?? this.subtitle,
      rescuedDescription: rescuedDescription ?? this.rescuedDescription,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isPlannedForToday: isPlannedForToday ?? this.isPlannedForToday,
    );
  }
}
