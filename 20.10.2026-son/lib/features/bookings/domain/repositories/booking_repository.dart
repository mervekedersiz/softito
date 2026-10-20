import '../entities/booking.dart';

/// Storage for demo bookings. Implemented in memory now.
abstract interface class BookingRepository {
  Future<void> add(Booking booking);

  /// Newest booking first.
  Future<List<Booking>> getAll();
}
