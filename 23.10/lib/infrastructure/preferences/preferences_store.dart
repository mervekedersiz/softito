import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStore {
  const PreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyOnboardingDone = 'onboarding_done';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyDefaultSection = 'default_section';
  static const String _keyHideNotificationTitle = 'hide_notification_title';

  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;
  Future<bool> setOnboardingDone(bool value) =>
      _prefs.setBool(_keyOnboardingDone, value);

  ThemeMode get themeMode {
    final val = _prefs.getString(_keyThemeMode);
    return switch (val) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<bool> setThemeMode(ThemeMode mode) {
    final str = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _prefs.setString(_keyThemeMode, str);
  }

  String get defaultSection => _prefs.getString(_keyDefaultSection) ?? 'study';
  Future<bool> setDefaultSection(String section) =>
      _prefs.setString(_keyDefaultSection, section);

  bool get hideNotificationTitle =>
      _prefs.getBool(_keyHideNotificationTitle) ?? false;
  Future<bool> setHideNotificationTitle(bool value) =>
      _prefs.setBool(_keyHideNotificationTitle, value);
}
