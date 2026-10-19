import 'package:flutter/material.dart';

/// Spor salonu ve hidrasyon estetiğine uygun
/// Dark Obsidian & Neon ile Ferah Atletik Aydınlık renk paleti
abstract final class AppColors {
  // --- Koyu Tema (Obsidian & Neon) ---
  static const Color obsidianBlack = Color(0xFF0A0D12);
  static const Color surfaceDark = Color(0xFF121721);
  static const Color cardDark = Color(0xFF1A2230);
  static const Color cardBorderDark = Color(0xFF263347);

  // --- Aydınlık Tema (Ferah Atletik Spor Salonu) ---
  static const Color lightBackground = Color(0xFFF4F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  // Neon & Atletik Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00C4D4); // Aydınlık ve koyu modda kontrastlı canlı cyan
  static const Color electricBlue = Color(0xFF0072F5);
  static const Color neonLime = Color(0xFF05C175);
  static const Color neonOrange = Color(0xFFFF6B2B);

  // Koyu Mod Metin Renkleri
  static const Color textPrimaryDark = Color(0xFFF3F6FB);
  static const Color textSecondaryDark = Color(0xFF8E9BAE);
  static const Color textMutedDark = Color(0xFF566376);

  // Aydınlık Mod Metin Renkleri
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Durum Renkleri
  static const Color success = Color(0xFF05C175);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFFF4D4F);

  // Gradientler
  static const LinearGradient cyanWaterGradient = LinearGradient(
    colors: [neonCyan, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient energyGradient = LinearGradient(
    colors: [neonLime, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
