import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../models/enums.dart';

class FoodThumbnail extends StatelessWidget {
  final String foodName;
  final FoodCategory category;
  final double size;

  const FoodThumbnail({
    super.key,
    required this.foodName,
    required this.category,
    this.size = 46,
  });

  String? get _assetPath {
    final nameLower = foodName.toLowerCase();
    if (nameLower.contains('süt') || nameLower.contains('yoğurt') || nameLower.contains('ayran') || nameLower.contains('krema')) {
      return 'assets/images/food_milk.jpg';
    } else if (nameLower.contains('kaşar') || nameLower.contains('peynir') || nameLower.contains('lor') || nameLower.contains('tereyağ')) {
      return 'assets/images/food_cheese.jpg';
    } else if (nameLower.contains('somon') || nameLower.contains('balık') || nameLower.contains('tavuk') || nameLower.contains('et') || nameLower.contains('kıyma')) {
      return 'assets/images/food_salmon.jpg';
    } else if (nameLower.contains('mercimek') || nameLower.contains('makarna') || nameLower.contains('nohut') || nameLower.contains('pirinç') || nameLower.contains('bulgur')) {
      return 'assets/images/food_lentils.jpg';
    } else if (nameLower.contains('yemek') || nameLower.contains('çorba') || nameLower.contains('sote') || nameLower.contains('güveç')) {
      return 'assets/images/recipe_dish.jpg';
    }
    return null;
  }

  IconData get _fallbackIcon {
    switch (category) {
      case FoodCategory.dairy:
        return Icons.water_drop_outlined;
      case FoodCategory.meat:
        return Icons.set_meal_outlined;
      case FoodCategory.produce:
        return Icons.eco_outlined;
      case FoodCategory.pantry:
        return Icons.shelves;
      case FoodCategory.other:
        return Icons.restaurant_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = _assetPath;

    if (asset != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            asset,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallback(),
          ),
        ),
      );
    }

    return _buildFallback();
  }

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(
        _fallbackIcon,
        color: AppColors.primary,
        size: size * 0.5,
      ),
    );
  }
}
