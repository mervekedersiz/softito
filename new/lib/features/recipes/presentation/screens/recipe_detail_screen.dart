import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../data/local_recipe_catalog.dart';
import '../providers/recipe_providers.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(recipeMatchesProvider);
    final ctrl = ref.read(recipeControllerProvider);

    final match = matches.firstWhere(
      (m) => m.recipe.id == recipeId,
      orElse: () => RecipeMatch(
        recipe: LocalRecipeCatalog.recipes.first,
        matchedItems: [],
        missingIngredients: [],
        matchPercentage: 0,
        isFullMatch: false,
        isBookmarked: false,
        isPlannedForToday: false,
      ),
    );

    final recipe = match.recipe;

    return Scaffold(
      appBar: AppHeader(
        subtitle: recipe.name,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: match.isFullMatch
                              ? AppColors.primaryMint
                              : AppColors.warningBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          match.isFullMatch
                              ? '%100 Dolaptan'
                              : '%${match.matchPercentage} Dolaptan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: match.isFullMatch
                                ? AppColors.primary
                                : AppColors.warning,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text('${recipe.cookingTimeMinutes} dk'),
                          const SizedBox(width: 12),
                          const Icon(Icons.people_outline,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text('${recipe.servings} Porsiyon'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${recipe.difficulty} • ${recipe.subtitle}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Malzemeler
            const Text(
              'Gerekli Malzemeler',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: recipe.ingredients.map((ing) {
                  final isMatched = match.matchedItems.any((m) =>
                      m.name.toLowerCase().contains(ing.name.toLowerCase()) ||
                      ing.name.toLowerCase().contains(m.name.toLowerCase()));

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isMatched
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isMatched ? AppColors.primary : AppColors.textMuted,
                      size: 20,
                    ),
                    title: Text(
                      ing.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isMatched
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Text(
                      '${ing.amount.toStringAsFixed(0)} ${ing.unit}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Hazırlama Adımları
            const Text(
              'Hazırlama Adımları',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: List.generate(recipe.instructions.length, (idx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primaryMint,
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            recipe.instructions[idx],
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Working Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      await ctrl.reserveIngredients(match);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Malzemeler envanterde rezerve edildi.'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    label: const Text('Malzemeleri Ayır', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ctrl.toggleTodayPlan(recipe.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bugün Pişir planına eklendi.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.playlist_add_check, size: 18),
                    label: const Text("Bugün Pişir'e Ekle", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  await ctrl.cookRecipe(match);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${recipe.name} pişirildi, malzemeler envanterden düşüldü!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    context.pop();
                  }
                },
                icon: const Icon(Icons.check, size: 20),
                label: const Text(
                  'Pişirdim (Malzemeleri Düş)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
