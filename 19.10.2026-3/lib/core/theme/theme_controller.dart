import 'package:flutter/material.dart';

class ThemeController {
  final ValueNotifier<ThemeMode> state =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  ThemeMode get current => state.value;

  bool get isDarkMode => state.value == ThemeMode.dark;

  void toggleTheme() {
    state.value =
        state.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    state.value = mode;
  }

  void dispose() {
    state.dispose();
  }
}
