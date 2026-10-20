import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

@immutable
class KanBagiColors extends ThemeExtension<KanBagiColors> {
  final Color bloodRed;
  final Color deepCrimson;
  final Color bagBorder;
  final Color bagBackground;
  final Color fluidGradientTop;
  final Color fluidGradientBottom;
  final Color tubeColor;
  final Color cardBackground;
  final Color subtleBorder;
  final Color textMuted;

  const KanBagiColors({
    required this.bloodRed,
    required this.deepCrimson,
    required this.bagBorder,
    required this.bagBackground,
    required this.fluidGradientTop,
    required this.fluidGradientBottom,
    required this.tubeColor,
    required this.cardBackground,
    required this.subtleBorder,
    required this.textMuted,
  });

  static const light = KanBagiColors(
    bloodRed: AppColors.bloodRed,
    deepCrimson: AppColors.deepCrimson,
    bagBorder: AppColors.bagBorder,
    bagBackground: AppColors.bagBackgroundLight,
    fluidGradientTop: AppColors.fluidGradientTop,
    fluidGradientBottom: AppColors.fluidGradientBottom,
    tubeColor: AppColors.tubeColor,
    cardBackground: AppColors.lightSurface,
    subtleBorder: AppColors.lightBorder,
    textMuted: AppColors.lightTextSecondary,
  );

  static const dark = KanBagiColors(
    bloodRed: AppColors.vibrantRed,
    deepCrimson: AppColors.bloodRed,
    bagBorder: AppColors.bagBorderDark,
    bagBackground: AppColors.bagBackgroundDark,
    fluidGradientTop: AppColors.flowRedLight,
    fluidGradientBottom: AppColors.deepCrimson,
    tubeColor: AppColors.tubeColor,
    cardBackground: AppColors.darkSurface,
    subtleBorder: AppColors.darkBorder,
    textMuted: AppColors.darkTextSecondary,
  );

  @override
  KanBagiColors copyWith({
    Color? bloodRed,
    Color? deepCrimson,
    Color? bagBorder,
    Color? bagBackground,
    Color? fluidGradientTop,
    Color? fluidGradientBottom,
    Color? tubeColor,
    Color? cardBackground,
    Color? subtleBorder,
    Color? textMuted,
  }) {
    return KanBagiColors(
      bloodRed: bloodRed ?? this.bloodRed,
      deepCrimson: deepCrimson ?? this.deepCrimson,
      bagBorder: bagBorder ?? this.bagBorder,
      bagBackground: bagBackground ?? this.bagBackground,
      fluidGradientTop: fluidGradientTop ?? this.fluidGradientTop,
      fluidGradientBottom: fluidGradientBottom ?? this.fluidGradientBottom,
      tubeColor: tubeColor ?? this.tubeColor,
      cardBackground: cardBackground ?? this.cardBackground,
      subtleBorder: subtleBorder ?? this.subtleBorder,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  KanBagiColors lerp(ThemeExtension<KanBagiColors>? other, double t) {
    if (other is! KanBagiColors) return this;
    return KanBagiColors(
      bloodRed: Color.lerp(bloodRed, other.bloodRed, t) ?? bloodRed,
      deepCrimson: Color.lerp(deepCrimson, other.deepCrimson, t) ?? deepCrimson,
      bagBorder: Color.lerp(bagBorder, other.bagBorder, t) ?? bagBorder,
      bagBackground:
          Color.lerp(bagBackground, other.bagBackground, t) ?? bagBackground,
      fluidGradientTop:
          Color.lerp(fluidGradientTop, other.fluidGradientTop, t) ??
          fluidGradientTop,
      fluidGradientBottom:
          Color.lerp(fluidGradientBottom, other.fluidGradientBottom, t) ??
          fluidGradientBottom,
      tubeColor: Color.lerp(tubeColor, other.tubeColor, t) ?? tubeColor,
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      subtleBorder:
          Color.lerp(subtleBorder, other.subtleBorder, t) ?? subtleBorder,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
    );
  }
}

extension KanBagiThemeExtension on BuildContext {
  KanBagiColors get kanColors =>
      Theme.of(this).extension<KanBagiColors>() ?? KanBagiColors.light;
}
