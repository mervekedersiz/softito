import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../inventory/domain/entities/food_item.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../data/local_recipe_catalog.dart';
import '../../domain/entities/recipe.dart';

class RecipeMatch {
  final Recipe recipe;
  final List<FoodItem> matchedItems;
  final List<RecipeIngredient> missingIngredients;
  final int matchPercentage; // e.g. 100 or 75
  final bool isFullMatch;
  final bool isBookmarked;
  final bool isPlannedForToday;

  const RecipeMatch({
    required this.recipe,
    required this.matchedItems,
    required this.missingIngredients,
    required this.matchPercentage,
    required this.isFullMatch,
    required this.isBookmarked,
    required this.isPlannedForToday,
  });
}

class OnlyFullRecipesNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setVal(bool val) => state = val;
  void toggle() => state = !state;
}

final onlyFullRecipesFilterProvider =
    NotifierProvider<OnlyFullRecipesNotifier, bool>(
  OnlyFullRecipesNotifier.new,
);

class BookmarkedRecipeIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {
        'recipe_chicken_mushroom',
        'recipe_baked_mushroom_pasta',
      };

  void toggle(String id) {
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
  }
}

final bookmarkedRecipeIdsProvider =
    NotifierProvider<BookmarkedRecipeIdsNotifier, Set<String>>(
  BookmarkedRecipeIdsNotifier.new,
);

class TodayPlanRecipeIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {'recipe_chicken_mushroom'};

  void toggle(String id) {
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
  }
}

final todayPlanRecipeIdsProvider =
    NotifierProvider<TodayPlanRecipeIdsNotifier, Set<String>>(
  TodayPlanRecipeIdsNotifier.new,
);

final recipeMatchesProvider = Provider<List<RecipeMatch>>((ref) {
  final foodsAsync = ref.watch(foodsListProvider);
  final foods = foodsAsync.value ?? [];
  final onlyFull = ref.watch(onlyFullRecipesFilterProvider);
  final bookmarks = ref.watch(bookmarkedRecipeIdsProvider);
  final todayPlan = ref.watch(todayPlanRecipeIdsProvider);

  final allRecipes = LocalRecipeCatalog.recipes;
  final matches = <RecipeMatch>[];

  for (final recipe in allRecipes) {
    final matchedFoods = <FoodItem>[];
    final missing = <RecipeIngredient>[];

    for (final ing in recipe.ingredients) {
      final nameClean = ing.name.toLowerCase();
      // Match with inventory
      final found = foods.where((f) {
        if (f.isConsumed || f.isWasted) return false;
        final fName = f.name.toLowerCase();
        return fName.contains(nameClean) ||
            nameClean.contains(fName) ||
            (nameClean.contains('süt') && fName.contains('süt')) ||
            (nameClean.contains('tavuk') && fName.contains('tavuk')) ||
            (nameClean.contains('mantar') && fName.contains('mantar')) ||
            (nameClean.contains('kaşar') && fName.contains('kaşar')) ||
            (nameClean.contains('makarna') && fName.contains('makarna')) ||
            (nameClean.contains('mercimek') && fName.contains('mercimek'));
      }).toList();

      if (found.isNotEmpty) {
        matchedFoods.add(found.first);
      } else if (!ing.isOptional) {
        missing.add(ing);
      }
    }

    final totalReq = recipe.ingredients.where((i) => !i.isOptional).length;
    final matchedCount = matchedFoods.length;
    final percent = totalReq > 0
        ? ((matchedCount / totalReq) * 100).clamp(0, 100).round()
        : 100;
    final isFull = missing.isEmpty;

    if (onlyFull && !isFull) {
      continue;
    }

    matches.add(RecipeMatch(
      recipe: recipe,
      matchedItems: matchedFoods,
      missingIngredients: missing,
      matchPercentage: percent,
      isFullMatch: isFull,
      isBookmarked: bookmarks.contains(recipe.id),
      isPlannedForToday: todayPlan.contains(recipe.id),
    ));
  }

  // Sort by match percentage desc
  matches.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
  return matches;
});

class RecipeController {
  final Ref _ref;

  RecipeController(this._ref);

  void toggleBookmark(String recipeId) {
    _ref.read(bookmarkedRecipeIdsProvider.notifier).toggle(recipeId);
  }

  void toggleTodayPlan(String recipeId) {
    _ref.read(todayPlanRecipeIdsProvider.notifier).toggle(recipeId);
  }

  Future<void> cookRecipe(RecipeMatch match) async {
    final notifier = _ref.read(foodsListProvider.notifier);
    for (final food in match.matchedItems) {
      await notifier.consumeFood(food.id);
    }
  }

  Future<void> reserveIngredients(RecipeMatch match) async {
    final repo = _ref.read(foodRepositoryProvider);
    for (final food in match.matchedItems) {
      await repo.toggleReserveForRecipe(food.id, true);
    }
    await _ref.read(foodsListProvider.notifier).refresh();
  }
}

final recipeControllerProvider = Provider<RecipeController>((ref) {
  return RecipeController(ref);
});
