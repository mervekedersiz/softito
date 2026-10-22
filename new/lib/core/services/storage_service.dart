import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService {
  final SharedPreferencesAsync? _prefs;
  final Map<String, dynamic> _memoryStore = {};

  StorageService([SharedPreferencesAsync? prefs]) : _prefs = prefs;

  SharedPreferencesAsync get _effectivePrefs =>
      _prefs ?? SharedPreferencesAsync();

  Future<Map<String, dynamic>?> loadSnapshot() async {
    try {
      final raw = await _effectivePrefs.getString(StorageKeys.stateSnapshot);
      if (raw == null || raw.isEmpty) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      // Fallback to in-memory store in unit test environments without platform channels
      final raw = _memoryStore[StorageKeys.stateSnapshot] as String?;
      if (raw == null || raw.isEmpty) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    }
  }

  Future<void> saveSnapshot(Map<String, dynamic> data) async {
    final raw = jsonEncode(data);
    _memoryStore[StorageKeys.stateSnapshot] = raw;
    try {
      await _effectivePrefs.setString(StorageKeys.stateSnapshot, raw);
    } catch (_) {
      // Preserved in _memoryStore for test run
    }
  }

  // Location saves must report a persistent-storage failure to the user.
  Future<void> saveSnapshotStrict(Map<String, dynamic> data) async {
    final raw = jsonEncode(data);
    await _effectivePrefs.setString(StorageKeys.stateSnapshot, raw);
    _memoryStore[StorageKeys.stateSnapshot] = raw;
  }

  Future<bool> isOnboardingCompleted() async {
    try {
      final val = await _effectivePrefs.getBool(
        StorageKeys.onboardingCompleted,
      );
      return val ?? false;
    } catch (_) {
      return (_memoryStore[StorageKeys.onboardingCompleted] as bool?) ?? false;
    }
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    _memoryStore[StorageKeys.onboardingCompleted] = completed;
    try {
      await _effectivePrefs.setBool(StorageKeys.onboardingCompleted, completed);
    } catch (_) {
      // Preserved in _memoryStore
    }
  }

  Future<void> clearAll() async {
    _memoryStore.clear();
    try {
      await _effectivePrefs.remove(StorageKeys.stateSnapshot);
      await _effectivePrefs.remove(StorageKeys.onboardingCompleted);
    } catch (_) {
      // In-memory cleared
    }
  }
}
