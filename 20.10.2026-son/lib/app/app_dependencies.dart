import 'package:flutter/foundation.dart';

import '../core/feedback/app_feedback.dart';
import '../features/auth/data/repositories/mock_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/bookings/data/repositories/mock_booking_repository.dart';
import '../features/bookings/domain/repositories/booking_repository.dart';
import '../features/bookings/presentation/controllers/booking_controller.dart';
import '../features/currency/domain/services/currency_service.dart';
import '../features/currency/presentation/controllers/currency_controller.dart';
import '../features/favorites/presentation/controllers/favorites_controller.dart';
import '../features/map_pins/presentation/controllers/map_pin_controller.dart';
import '../features/nfc_pass/presentation/controllers/nfc_controller.dart';
import '../features/tracking/presentation/controllers/telemetry_controller.dart';
import '../features/vehicles/data/repositories/mock_vehicle_repository.dart';
import '../features/vehicles/domain/repositories/vehicle_repository.dart';
import '../features/vehicles/presentation/controllers/vehicle_controller.dart';
import 'app_destination.dart';
import 'theme_controller.dart';

/// Clean Architecture Composition Root: wires repositories to controllers.
class AppDependencies {
  AppDependencies({
    VehicleRepository? vehicleRepository,
    BookingRepository? bookingRepository,
    AuthRepository? authRepository,
    CurrencyService? currencyService,
    DateTime Function()? clock,
  })  : vehicles = VehicleController(
          vehicleRepository ?? const MockVehicleRepository(includeMultiModal: false),
        ),
        bookings = BookingController(
          bookingRepository ?? MockBookingRepository(),
          clock: clock,
        ),
        favorites = FavoritesController(),
        theme = ThemeController(),
        auth = AuthController(repository: authRepository ?? MockAuthRepository()),
        currency = CurrencyController(service: currencyService ?? CurrencyService()),
        feedback = AppFeedbackController(),
        nfc = NfcController(),
        telemetry = TelemetryController(),
        mapPins = MapPinController(),
        tab = ValueNotifier(AppDestination.home);

  final VehicleController vehicles;
  final BookingController bookings;
  final FavoritesController favorites;
  final ThemeController theme;
  final AuthController auth;
  final CurrencyController currency;
  final AppFeedbackController feedback;
  final NfcController nfc;
  final TelemetryController telemetry;
  final MapPinController mapPins;

  /// Currently selected bottom-navigation destination.
  final ValueNotifier<AppDestination> tab;

  void dispose() {
    vehicles.dispose();
    bookings.dispose();
    favorites.dispose();
    theme.dispose();
    auth.dispose();
    currency.dispose();
    feedback.dispose();
    nfc.dispose();
    telemetry.dispose();
    mapPins.dispose();
    tab.dispose();
  }
}
