import 'package:flutter/material.dart';

class AppColors {
  // Brand palette
  static const Color primaryLilac = Color(0xFF7965A8);
  static const Color creamBackground = Color(0xFFFFF9F2);
  static const Color peachAccent = Color(0xFFF2B6A0);
  static const Color sageAccent = Color(0xFFA3BFA8);

  // Spiritual / Maneviyat specific soft tint
  static const Color spiritualTone = Color(0xFF6B728E);
  // Study / Ders specific soft tint
  static const Color studyTone = Color(0xFF3F72AF);
  // Reward / Kendime Zaman specific warm tint
  static const Color rewardTone = Color(0xFFD67D3E);

  // Light color scheme
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primaryLilac,
    brightness: Brightness.light,
    primary: primaryLilac,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFEADBFF),
    onPrimaryContainer: const Color(0xFF28114E),
    secondary: const Color(0xFF625B71),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFE8DEF8),
    onSecondaryContainer: const Color(0xFF1E192B),
    tertiary: sageAccent,
    onTertiary: const Color(0xFF0F2C18),
    tertiaryContainer: const Color(0xFFD7E8DC),
    onTertiaryContainer: const Color(0xFF0D2816),
    surface: creamBackground,
    onSurface: const Color(0xFF201A18),
    surfaceContainerHighest: const Color(0xFFF3ECE4),
    outlineVariant: const Color(0xFFD8D0C5),
    error: const Color(0xFFBA1A1A),
    onError: Colors.white,
  );

  // Dark color scheme
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryLilac,
    brightness: Brightness.dark,
    primary: const Color(0xFFD2BCFF),
    onPrimary: const Color(0xFF3C206D),
    primaryContainer: const Color(0xFF553B86),
    onPrimaryContainer: const Color(0xFFEADBFF),
    secondary: const Color(0xFFCCC2DC),
    onSecondary: const Color(0xFF332D41),
    secondaryContainer: const Color(0xFF4A4458),
    onSecondaryContainer: const Color(0xFFE8DEF8),
    tertiary: const Color(0xFFB9D4BE),
    onTertiary: const Color(0xFF203B26),
    tertiaryContainer: const Color(0xFF36523C),
    onTertiaryContainer: const Color(0xFFD7E8DC),
    surface: const Color(0xFF1A171D),
    onSurface: const Color(0xFFEBE0E8),
    surfaceContainerHighest: const Color(0xFF36323B),
    outlineVariant: const Color(0xFF4D4853),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
  );
}
