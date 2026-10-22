import 'package:flutter/foundation.dart';

import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/services/booking_validator.dart';
import '../../domain/services/rental_pricing.dart';

/// Creates demo bookings after re-validating every rule, then exposes them.
class BookingController extends ChangeNotifier {
  BookingController(this._repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final BookingRepository _repository;
  final DateTime Function() _clock;

  List<Booking> _bookings = const [];
  int _counter = 0;

  /// Newest first.
  List<Booking> get bookings => _bookings;

  /// Throws [ArgumentError] and stores nothing when any rule is violated.
  Future<Booking> submit({
    required Vehicle vehicle,
    required String pickupLocation,
    required String returnLocation,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final now = _clock();
    final error = !vehicle.isAvailable
        ? 'Araç şu an müsait değil.'
        : BookingValidator.location(
                pickupLocation,
                message: 'Alış konumunu seçin.',
              ) ??
              BookingValidator.location(
                returnLocation,
                message: 'Teslim konumunu seçin.',
              ) ??
              BookingValidator.start(startAt, now) ??
              BookingValidator.end(endAt, startAt);
    if (error != null) throw ArgumentError(error);

    final duration = endAt.difference(startAt);
    _counter++;
    final booking = Booking(
      id: 'DEMO-${_counter.toString().padLeft(4, '0')}',
      vehicleId: vehicle.id,
      vehicleName: vehicle.name,
      pickupLocation: pickupLocation,
      returnLocation: returnLocation,
      startAt: startAt,
      endAt: endAt,
      billableDays: RentalPricing.billableDays(duration),
      estimatedTotal: RentalPricing.estimatedTotal(
        duration: duration,
        dailyPrice: vehicle.dailyPrice,
      ),
      createdAt: now,
    );
    await _repository.add(booking);
    _bookings = await _repository.getAll();
    notifyListeners();
    return booking;
  }
}
