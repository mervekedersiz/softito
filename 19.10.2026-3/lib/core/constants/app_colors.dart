import 'package:flutter/material.dart';

/// Dark Obsidian & Light Sport Studio color palette for Susadım v1
abstract final class AppColors {
  // --- Dark Mode Palette (Dark Obsidian & Neon) ---
  static const Color obsidianBlack = Color(0xFF080C14);
  static const Color darkObsidian = Color(0xFF0F172A);
  static const Color darkSurfaceCard = Color(0xFF141D30);
  static const Color darkSurfaceCardLight = Color(0xFF1E293B);
  static const Color darkSurfaceBorder = Color(0xFF25334D);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // --- Light Mode Palette (Clean Athletic Studio) ---
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceCardLight = Color(0xFFF1F5F9);
  static const Color lightSurfaceBorder = Color(0xFFE2E8F0);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // --- Brand & Neon Accents ---
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color lightPrimary = Color(0xFF0284C7);
  static const Color neonBlue = Color(0xFF2979FF);

  static const Color neonLime = Color(0xFF00E676);
  static const Color lightLime = Color(0xFF16A34A);

  static const Color neonOrange = Color(0xFFFF6D00);
  static const Color lightOrange = Color(0xFFEA580C);

  static const Color neonPurple = Color(0xFF7C4DFF);
  static const Color lightPurple = Color(0xFF6D28D9);

  // Backward-compatible aliases for Dark Mode defaults
  static const Color surfaceCard = darkSurfaceCard;
  static const Color surfaceCardLight = darkSurfaceCardLight;
  static const Color surfaceBorder = darkSurfaceBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;

  // Functional
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFFF5252);
  static const Color transparent = Colors.transparent;
}
