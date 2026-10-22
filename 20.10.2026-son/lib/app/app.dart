import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_dependencies.dart';
import 'app_navigation.dart';
import 'app_scope.dart';
import 'app_theme.dart';

/// Root widget of the YolOrtağım application.
class YolOrtagimApp extends StatefulWidget {
  /// Pass [dependencies] to inject fakes (tests); otherwise demo data is used.
  const YolOrtagimApp({this.dependencies, super.key});

  final AppDependencies? dependencies;

  @override
  State<YolOrtagimApp> createState() => _YolOrtagimAppState();
}

class _YolOrtagimAppState extends State<YolOrtagimApp> {
  late final AppDependencies _dependencies;
  late final bool _ownsDependencies;

  @override
  void initState() {
    super.initState();
    _ownsDependencies = widget.dependencies == null;
    _dependencies = widget.dependencies ?? AppDependencies();
    _dependencies.vehicles.load();
  }

  @override
  void dispose() {
    if (_ownsDependencies) _dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      dependencies: _dependencies,
      child: ListenableBuilder(
        listenable: _dependencies.theme,
        builder: (context, _) => MaterialApp(
          title: 'YolOrtağım',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _dependencies.theme.mode,
          locale: const Locale('tr', 'TR'),
          supportedLocales: const [Locale('tr', 'TR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: const AppShell(),
        ),
      ),
    );
  }
}
