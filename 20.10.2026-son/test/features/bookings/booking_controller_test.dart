import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/features/bookings/data/repositories/mock_booking_repository.dart';
import 'package:yol_ortagim/features/bookings/presentation/controllers/booking_controller.dart';
import 'package:yol_ortagim/features/vehicles/domain/entities/vehicle.dart';

const _available = Vehicle(
  id: 'v1',
  brand: 'Test',
  model: 'Car',
  transmission: Transmission.automatic,
  fuelType: FuelType.electric,
  seatCount: 5,
  dailyPrice: 1000,
  description: 'Test aracı',
  isAvailable: true,
);

const _unavailable = Vehicle(
  id: 'v2',
  brand: 'Test',
  model: 'Busy',
  transmission: Transmission.manual,
  fuelType: FuelType.diesel,
  seatCount: 5,
  dailyPrice: 800,
  description: 'Müsait olmayan test aracı',
  isAvailable: false,
);

void main() {
  final now = DateTime(2026, 10, 20, 12);
  late BookingController controller;
  late MockBookingRepository repository;

  setUp(() {
    repository = MockBookingRepository();
    controller = BookingController(repository, clock: () => now);
  });

  test('stores a valid booking and bills 25 hours as 2 days', () async {
    final start = now.add(const Duration(hours: 2));
    final booking = await controller.submit(
      vehicle: _available,
      pickupLocation: 'Kadıköy Merkez Ofis',
      returnLocation: 'Antalya Havalimanı',
      startAt: start,
      endAt: start.add(const Duration(hours: 25)),
    );

    expect(booking.id, 'DEMO-0001');
    expect(booking.billableDays, 2);
    expect(booking.estimatedTotal, 2000);
    expect(controller.bookings, hasLength(1));
  });

  test('newest booking comes first', () async {
    final start = now.add(const Duration(hours: 2));
    for (var i = 0; i < 2; i++) {
      await controller.submit(
        vehicle: _available,
        pickupLocation: 'A',
        returnLocation: 'B',
        startAt: start,
        endAt: start.add(const Duration(days: 1)),
      );
    }
    expect(controller.bookings.map((b) => b.id), ['DEMO-0002', 'DEMO-0001']);
  });

  test('rejects an end that is not after the start and stores nothing', () {
    final start = now.add(const Duration(hours: 2));
    expect(
      () => controller.submit(
        vehicle: _available,
        pickupLocation: 'A',
        returnLocation: 'B',
        startAt: start,
        endAt: start,
      ),
      throwsArgumentError,
    );
    expect(controller.bookings, isEmpty);
  });

  test('rejects a start in the past', () {
    expect(
      () => controller.submit(
        vehicle: _available,
        pickupLocation: 'A',
        returnLocation: 'B',
        startAt: now.subtract(const Duration(hours: 1)),
        endAt: now.add(const Duration(days: 1)),
      ),
      throwsArgumentError,
    );
  });

  test('rejects empty locations', () {
    final start = now.add(const Duration(hours: 2));
    expect(
      () => controller.submit(
        vehicle: _available,
        pickupLocation: '',
        returnLocation: 'B',
        startAt: start,
        endAt: start.add(const Duration(days: 1)),
      ),
      throwsArgumentError,
    );
  });

  test('rejects an unavailable vehicle', () {
    final start = now.add(const Duration(hours: 2));
    expect(
      () => controller.submit(
        vehicle: _unavailable,
        pickupLocation: 'A',
        returnLocation: 'B',
        startAt: start,
        endAt: start.add(const Duration(days: 1)),
      ),
      throwsArgumentError,
    );
    expect(controller.bookings, isEmpty);
  });
}
