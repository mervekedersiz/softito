import 'package:flutter/material.dart';

/// Gece spor salonu paleti (Dark Obsidian & Neon)
abstract final class AppColors {
  // Obsidian Arka Plan ve Yüzeyler
  static const Color background = Color(0xFF0D0F12);
  static const Color surface = Color(0xFF161A22);
  static const Color surfaceLight = Color(0xFF1F2430);
  static const Color border = Color(0xFF2B3240);

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF); // Su ve hidrasyon
  static const Color neonCyanDark = Color(0xFF0097A7);
  static const Color neonLime = Color(0xFFCCFF00); // Egzersiz & Enerji
  static const Color neonCoral = Color(0xFFFF3D71); // Kalori & Yakım
  static const Color neonPurple = Color(0xFF9D4EDD); // Başarı & Hedef

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Durum Renkleri
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);
}
