import 'package:flutter/foundation.dart';

import '../features/bookings/data/repositories/mock_booking_repository.dart';
import '../features/bookings/domain/repositories/booking_repository.dart';
import '../features/bookings/presentation/controllers/booking_controller.dart';
import '../features/favorites/presentation/controllers/favorites_controller.dart';
import '../features/vehicles/data/repositories/mock_vehicle_repository.dart';
import '../features/vehicles/domain/repositories/vehicle_repository.dart';
import '../features/vehicles/presentation/controllers/vehicle_controller.dart';
import 'app_destination.dart';
import 'theme_controller.dart';

/// Composition root: wires repositories to controllers.
class AppDependencies {
  AppDependencies({
    VehicleRepository? vehicleRepository,
    BookingRepository? bookingRepository,
    DateTime Function()? clock,
  }) : vehicles = VehicleController(
         vehicleRepository ?? const MockVehicleRepository(),
       ),
       bookings = BookingController(
         bookingRepository ?? MockBookingRepository(),
         clock: clock,
       ),
       favorites = FavoritesController(),
       theme = ThemeController(),
       tab = ValueNotifier(AppDestination.home);

  final VehicleController vehicles;
  final BookingController bookings;
  final FavoritesController favorites;
  final ThemeController theme;

  /// Currently selected bottom-navigation destination.
  final ValueNotifier<AppDestination> tab;

  void dispose() {
    vehicles.dispose();
    bookings.dispose();
    favorites.dispose();
    theme.dispose();
    tab.dispose();
  }
}
