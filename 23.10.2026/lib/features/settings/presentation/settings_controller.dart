import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.defaultSection,
    required this.hideNotificationTitle,
  });

  final ThemeMode themeMode;
  final String defaultSection;
  final bool hideNotificationTitle;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? defaultSection,
    bool? hideNotificationTitle,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      defaultSection: defaultSection ?? this.defaultSection,
      hideNotificationTitle:
          hideNotificationTitle ?? this.hideNotificationTitle,
    );
  }
}

class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final prefs = ref.watch(preferencesStoreProvider);
    return SettingsState(
      themeMode: prefs.themeMode,
      defaultSection: prefs.defaultSection,
      hideNotificationTitle: prefs.hideNotificationTitle,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(preferencesStoreProvider);
    await prefs.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setDefaultSection(String section) async {
    final prefs = ref.read(preferencesStoreProvider);
    await prefs.setDefaultSection(section);
    state = state.copyWith(defaultSection: section);
  }

  Future<void> setHideNotificationTitle(bool value) async {
    final prefs = ref.read(preferencesStoreProvider);
    await prefs.setHideNotificationTitle(value);
    state = state.copyWith(hideNotificationTitle: value);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);
