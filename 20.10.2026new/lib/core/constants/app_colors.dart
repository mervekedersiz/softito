import 'package:flutter/material.dart';

/// Application color palette designed for blood donation theme.
/// Features warm, dignified crimson/burgundy primary tones,
/// gentle surface backgrounds, and distinct semantic cues.
abstract class AppColors {
  // Primary blood accents
  static const Color bloodRed = Color(0xFFC62828);
  static const Color deepCrimson = Color(0xFF8E0000);
  static const Color burgundy = Color(0xFF6B0E14);
  static const Color darkBlood = Color(0xFF4A0006);
  static const Color softRed = Color(0xFFFFEBEE);
  static const Color vibrantRed = Color(0xFFE53935);
  static const Color flowRedLight = Color(0xFFFF5252);

  // Bag and fluid simulation colors
  static const Color bagBorder = Color(0xFF90A4AE);
  static const Color bagBorderDark = Color(0xFF546E7A);
  static const Color bagBackgroundLight = Color(0x14000000);
  static const Color bagBackgroundDark = Color(0x22FFFFFF);
  static const Color fluidGradientTop = Color(0xFFE53935);
  static const Color fluidGradientBottom = Color(0xFF7F0000);
  static const Color tubeColor = Color(0x33B0BEC5);

  // Light theme neutrals
  static const Color lightBackground = Color(0xFFF9F9FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F3F5);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Dark theme neutrals
  static const Color darkBackground = Color(0xFF121417);
  static const Color darkSurface = Color(0xFF1E2228);
  static const Color darkSurfaceSubtle = Color(0xFF262C34);
  static const Color darkBorder = Color(0xFF333B44);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Status / semantic colors
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF0284C7);
  static const Color infoContainer = Color(0xFFE0F2FE);
  static const Color urgent = Color(0xFFDC2626);
  static const Color urgentContainer = Color(0xFFFEE2E2);
}
