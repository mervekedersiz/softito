import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/app/app.dart';
import 'package:yol_ortagim/app/app_dependencies.dart';
import 'package:yol_ortagim/app/app_destination.dart';
import 'package:yol_ortagim/app/app_scope.dart';
import 'package:yol_ortagim/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:yol_ortagim/features/auth/domain/entities/user.dart';
import 'package:yol_ortagim/features/map_pins/presentation/pages/interactive_map_page.dart';
import 'package:yol_ortagim/features/nfc_pass/presentation/pages/nfc_pass_page.dart';
import 'package:yol_ortagim/features/payment/presentation/pages/payment_checkout_page.dart';
import 'package:yol_ortagim/features/tracking/presentation/pages/live_tracking_page.dart';
import 'package:yol_ortagim/features/vehicles/presentation/pages/vehicle_detail_page.dart';

void main() {
  setUpAll(() {
    Directory('screenshots').createSync(recursive: true);
  });

  Future<void> saveScreenshot(WidgetTester tester, String filename) async {
    await tester.runAsync(() async {
      final boundary = tester.renderObject(find.byKey(const ValueKey('screenshot_boundary'))) as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      File('screenshots/$filename').writeAsBytesSync(bytes);
    });
  }

  testWidgets('Capture all application screens', (tester) async {
    tester.view.physicalSize = const Size(828, 1792);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final deps = AppDependencies();

    // 1. Home Page
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: YolOrtagimApp(dependencies: deps),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '01_home_screen.png');

    // 2. Vehicles Page (with "Depoyu söylüyor")
    deps.tab.value = AppDestination.vehicles;
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '02_vehicles_screen.png');

    // 3. Vehicle Detail Page
    final vehicle = deps.vehicles.all.first;
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: AppScope(
          dependencies: deps,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: VehicleDetailPage(vehicle: vehicle, heroTag: 'detail-hero'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '03_vehicle_detail_screen.png');

    // 4. Credit Card 3D Payment Page
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: AppScope(
          dependencies: deps,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: PaymentCheckoutPage(vehicle: vehicle, totalAmountTry: 2450),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '04_credit_card_payment_screen.png');

    // 5. Live Tracking Page (1080p Cockpit Radar HUD & Telemetry)
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: AppScope(
          dependencies: deps,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LiveTrackingPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '05_live_tracking_screen.png');

    // 6. Interactive Map Page (Pin addition)
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: AppScope(
          dependencies: deps,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: InteractiveMapPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '06_interactive_map_screen.png');

    // 7. NFC & Daily Ride Quota Page
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: AppScope(
          dependencies: deps,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: NfcPassPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '07_nfc_pass_screen.png');

    // 8. Admin Dashboard Page
    deps.auth.switchRole(UserRole.admin);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot_boundary'),
        child: AppScope(
          dependencies: deps,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AdminDashboardPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await saveScreenshot(tester, '08_admin_dashboard_screen.png');
  });
}
