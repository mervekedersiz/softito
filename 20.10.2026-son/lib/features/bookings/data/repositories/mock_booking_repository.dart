import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

/// Keeps demo bookings for the current app session only.
class MockBookingRepository implements BookingRepository {
  final List<Booking> _items = [];

  @override
  Future<void> add(Booking booking) async {
    _items.insert(0, booking);
  }

  @override
  Future<List<Booking>> getAll() async => List.unmodifiable(_items);
}
