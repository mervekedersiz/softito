import 'package:flutter/material.dart';

/// Brand-specific colors that are not part of the Material [ColorScheme].
///
/// Hex values live only in the theme layer; widgets read them through
/// `context.brand`.
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
    required this.onHeroMuted,
    required this.sun,
    required this.gold,
    required this.silver,
    required this.successContainer,
    required this.onSuccessContainer,
  });

  final Color heroStart;
  final Color heroEnd;
  final Color onHero;
  final Color onHeroMuted;
  final Color sun;
  final Color gold;
  final Color silver;
  final Color successContainer;
  final Color onSuccessContainer;

  static const BrandColors light = BrandColors(
    heroStart: Color(0xFF0B1F4B),
    heroEnd: Color(0xFF1D3F86),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFC9D3EA),
    sun: Color(0xFFF28C28),
    gold: Color(0xFFF7B840),
    silver: Color(0xFFC5CCD6),
    successContainer: Color(0xFFD6F2E3),
    onSuccessContainer: Color(0xFF0B4A2A),
  );

  static const BrandColors dark = BrandColors(
    heroStart: Color(0xFF081533),
    heroEnd: Color(0xFF16306B),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFB4C0DD),
    sun: Color(0xFFF28C28),
    gold: Color(0xFFF7B840),
    silver: Color(0xFFAAB3C2),
    successContainer: Color(0xFF124A2D),
    onSuccessContainer: Color(0xFFBFEBD2),
  );

  @override
  BrandColors copyWith({
    Color? heroStart,
    Color? heroEnd,
    Color? onHero,
    Color? onHeroMuted,
    Color? sun,
    Color? gold,
    Color? silver,
    Color? successContainer,
    Color? onSuccessContainer,
  }) {
    return BrandColors(
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      onHero: onHero ?? this.onHero,
      onHeroMuted: onHeroMuted ?? this.onHeroMuted,
      sun: sun ?? this.sun,
      gold: gold ?? this.gold,
      silver: silver ?? this.silver,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      onHeroMuted: Color.lerp(onHeroMuted, other.onHeroMuted, t)!,
      sun: Color.lerp(sun, other.sun, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      silver: Color.lerp(silver, other.silver, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
    );
  }
}

extension BrandColorsContext on BuildContext {
  BrandColors get brand => Theme.of(this).extension<BrandColors>()!;
}
