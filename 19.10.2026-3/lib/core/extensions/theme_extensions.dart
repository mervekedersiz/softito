import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  Color get cardBackground => isDarkMode
      ? AppColors.darkSurfaceCard
      : AppColors.lightSurfaceCard;

  Color get cardBackgroundLight => isDarkMode
      ? AppColors.darkSurfaceCardLight
      : AppColors.lightSurfaceCardLight;

  Color get borderColor => isDarkMode
      ? AppColors.darkSurfaceBorder
      : AppColors.lightSurfaceBorder;

  Color get textPrimaryColor => isDarkMode
      ? AppColors.darkTextPrimary
      : AppColors.lightTextPrimary;

  Color get textSecondaryColor => isDarkMode
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary;

  Color get textMutedColor => isDarkMode
      ? AppColors.darkTextMuted
      : AppColors.lightTextMuted;

  Color get accentWater => isDarkMode
      ? AppColors.neonCyan
      : AppColors.lightPrimary;

  Color get accentGym => isDarkMode
      ? AppColors.neonOrange
      : AppColors.lightOrange;

  Color get accentHabit => isDarkMode
      ? AppColors.neonLime
      : AppColors.lightLime;
}
