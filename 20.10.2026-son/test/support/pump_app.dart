import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/app/app.dart';
import 'package:yol_ortagim/app/app_dependencies.dart';
import 'package:yol_ortagim/features/vehicles/data/repositories/mock_vehicle_repository.dart';
import 'package:yol_ortagim/features/vehicles/domain/entities/vehicle.dart';
import 'package:yol_ortagim/features/vehicles/domain/repositories/vehicle_repository.dart';

/// Pumps the whole app with zero-latency sample data on a tall phone-like
/// surface (so lazily built lists show all items) and returns its wiring.
Future<AppDependencies> pumpApp(
  WidgetTester tester, {
  VehicleRepository? vehicleRepository,
  Size size = const Size(800, 1600),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final dependencies = AppDependencies(
    vehicleRepository:
        vehicleRepository ??
        const MockVehicleRepository(latency: Duration.zero),
  );
  await tester.pumpWidget(YolOrtagimApp(dependencies: dependencies));
  await tester.pumpAndSettle();
  return dependencies;
}

/// A repository whose loading always fails (error-state tests).
class FailingVehicleRepository implements VehicleRepository {
  @override
  Future<List<Vehicle>> getVehicles() async => throw Exception('offline');
}

/// Taps a bottom-navigation destination by its label.
Future<void> openTab(WidgetTester tester, String label) async {
  final inBar = find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );
  if (inBar.evaluate().isNotEmpty) {
    await tester.tap(inBar);
  } else {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text(label),
      ),
    );
  }
  await tester.pumpAndSettle();
}
