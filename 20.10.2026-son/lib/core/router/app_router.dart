import 'package:flutter/material.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/currency/presentation/controllers/currency_controller.dart';
import '../../features/currency/presentation/widgets/currency_selector_sheet.dart';
import '../../features/map_pins/presentation/pages/interactive_map_page.dart';
import '../../features/nfc_pass/presentation/pages/nfc_pass_page.dart';
import '../../features/payment/presentation/pages/payment_checkout_page.dart';
import '../../features/tracking/presentation/pages/live_tracking_page.dart';
import '../../features/vehicles/domain/entities/vehicle.dart';

/// Clean Architecture App Router & Navigation Manager.
class AppRouter {
  AppRouter._();

  static Future<void> pushLogin(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
    );
  }

  static Future<void> pushRegister(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RegisterPage()),
    );
  }

  static Future<bool?> pushPayment(
    BuildContext context, {
    required Vehicle vehicle,
    required int totalAmountTry,
    int rentalDays = 1,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PaymentCheckoutPage(
          vehicle: vehicle,
          totalAmountTry: totalAmountTry,
          rentalDays: rentalDays,
        ),
      ),
    );
  }

  static Future<void> pushLiveTracking(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LiveTrackingPage()),
    );
  }

  static Future<void> pushMap(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const InteractiveMapPage()),
    );
  }

  static Future<void> pushNfcPass(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NfcPassPage()),
    );
  }

  static Future<void> pushAdmin(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AdminDashboardPage()),
    );
  }

  static Future<void> showCurrencyPicker(
    BuildContext context,
    CurrencyController controller,
  ) {
    return CurrencySelectorSheet.show(context, controller);
  }
}
