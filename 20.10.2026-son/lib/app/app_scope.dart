import 'package:flutter/widgets.dart';

import 'app_dependencies.dart';

/// Makes [AppDependencies] available to the whole widget tree, including
/// routes pushed on the Navigator.
class AppScope extends InheritedWidget {
  const AppScope({required this.dependencies, required super.child, super.key});

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this context.');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}
