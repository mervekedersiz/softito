import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary greens
  static const Color primary = Color(0xFF005A36); // Dark forest green
  static const Color primaryDark = Color(0xFF003822);
  static const Color primaryLight = Color(0xFF0A7E4F);
  static const Color primaryMint = Color(0xFFD7F4E5);
  static const Color mintAccent = Color(0xFF6CE5B1);

  // Backgrounds & Neutrals
  static const Color background = Color(0xFFF7F9F8);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF0F4F2);
  static const Color border = Color(0xFFE2E8E5);
  static const Color borderLight = Color(0xFFEEF2F0);

  // Typography
  static const Color textPrimary = Color(0xFF13221C);
  static const Color textSecondary = Color(0xFF5A6B63);
  static const Color textMuted = Color(0xFF8B9D95);

  // Status colors (SKT & warnings)
  static const Color danger = Color(0xFFD9383A); // Red: Son gün / Geçmiş
  static const Color dangerBg = Color(0xFFFFECEB);
  static const Color warning = Color(0xFFE58A1F); // Amber / Yellow: 1-2 gün
  static const Color warningBg = Color(0xFFFFF6E5);
  static const Color safe = Color(0xFF28A745); // Green: 6+ gün
  static const Color safeBg = Color(0xFFE7F7ED);

  // Storage location accents
  static const Color fridge = Color(0xFF0A84FF);
  static const Color freezer = Color(0xFF00B4D8);
  static const Color pantry = Color(0xFFC86D24);
}
