import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/data/demo_store.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/navigation/views/main_navigation_shell.dart';

class KanBagiApp extends StatefulWidget {
  final DemoStore? initialStore;

  const KanBagiApp({super.key, this.initialStore});

  @override
  State<KanBagiApp> createState() => _KanBagiAppState();
}

class _KanBagiAppState extends State<KanBagiApp> {
  late final DemoStore _store;
  late final ThemeController _themeController;
  bool _ownsStore = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialStore != null) {
      _store = widget.initialStore!;
      _ownsStore = false;
    } else {
      _store = DemoStore();
      _ownsStore = true;
    }
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    if (_ownsStore) {
      _store.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MainNavigationShell(
            store: _store,
            themeController: _themeController,
          ),
        );
      },
    );
  }
}
