import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/app/app_theme.dart';
import 'package:yol_ortagim/app/brand_colors.dart';

void main() {
  test('light and dark themes use Material 3 with matching brightness', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.light.colorScheme.brightness, Brightness.light);
    expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
  });

  test('text and background keep a readable contrast in both themes', () {
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final scheme = theme.colorScheme;
      expect(_contrast(scheme.onSurface, scheme.surface), greaterThan(4.5));
      expect(_contrast(scheme.onPrimary, scheme.primary), greaterThan(4.5));
      expect(_contrast(scheme.onSecondary, scheme.secondary), greaterThan(4.5));
      expect(
        _contrast(scheme.onSecondaryContainer, scheme.secondaryContainer),
        greaterThan(4.5),
      );
    }
  });

  test('brand colors keep a readable contrast in both themes', () {
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final brand = theme.extension<BrandColors>()!;
      expect(_contrast(brand.onHero, brand.heroStart), greaterThan(4.5));
      expect(_contrast(brand.onHero, brand.heroEnd), greaterThan(4.5));
      expect(_contrast(brand.onHeroMuted, brand.heroEnd), greaterThan(4.5));
      expect(_contrast(brand.gold, brand.heroStart), greaterThan(4.5));
      expect(
        _contrast(brand.onSuccessContainer, brand.successContainer),
        greaterThan(4.5),
      );
      expect(
        _contrast(
          theme.colorScheme.onErrorContainer,
          theme.colorScheme.errorContainer,
        ),
        greaterThan(4.5),
      );
    }
  });
}

double _contrast(Color a, Color b) {
  final l1 = a.computeLuminance();
  final l2 = b.computeLuminance();
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}
