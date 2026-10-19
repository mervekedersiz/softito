import 'package:flutter/material.dart';

class ThemeController {
  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  void setLightTheme() {
    themeMode.value = ThemeMode.light;
  }

  void setDarkTheme() {
    themeMode.value = ThemeMode.dark;
  }

  void dispose() {
    themeMode.dispose();
  }
}
