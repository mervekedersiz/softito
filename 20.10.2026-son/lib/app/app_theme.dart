import 'package:flutter/material.dart';

import 'brand_colors.dart';

/// Material 3 themes built from the YolOrtağım brand palette.
///
/// Raw hex values live only in the theme layer; screens must read colors from
/// `Theme.of(context).colorScheme` or `context.brand`.
abstract final class AppTheme {
  static const Color _navy = Color(0xFF0B1F4B);
  static const Color _orange = Color(0xFFF28C28);

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme =
        ColorScheme.fromSeed(seedColor: _navy, brightness: brightness).copyWith(
          primary: isLight ? _navy : null,
          onPrimary: isLight ? Colors.white : null,
          secondary: _orange,
          onSecondary: _navy,
          secondaryContainer: isLight
              ? const Color(0xFFFFE3C2)
              : const Color(0xFF5A3300),
          onSecondaryContainer: isLight ? _navy : const Color(0xFFFFDDB8),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [isLight ? BrandColors.light : BrandColors.dark],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
