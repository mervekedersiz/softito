import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/di/app_providers.dart';
import 'infrastructure/preferences/preferences_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final preferencesStore = PreferencesStore(sharedPrefs);

  runApp(
    ProviderScope(
      overrides: [preferencesStoreProvider.overrideWithValue(preferencesStore)],
      child: const KendimeSozApp(),
    ),
  );
}
