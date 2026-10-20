import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController([super.value = ThemeMode.light]);

  bool get isDarkMode => value == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    if (value != mode) {
      value = mode;
    }
  }

  void toggleTheme() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
