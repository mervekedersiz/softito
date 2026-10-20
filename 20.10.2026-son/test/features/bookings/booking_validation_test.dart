import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/features/bookings/domain/services/booking_validator.dart';

void main() {
  final now = DateTime(2026, 10, 20, 12);

  group('location', () {
    test('rejects null, empty and blank values', () {
      for (final value in [null, '', '   ']) {
        expect(BookingValidator.location(value, message: 'Seçin.'), 'Seçin.');
      }
    });

    test('accepts a chosen location', () {
      expect(
        BookingValidator.location('Kadıköy Merkez Ofis', message: 'Seçin.'),
        isNull,
      );
    });
  });

  group('start', () {
    test('rejects missing start', () {
      expect(BookingValidator.start(null, now), isNotNull);
    });

    test('rejects a start in the past', () {
      expect(
        BookingValidator.start(now.subtract(const Duration(minutes: 1)), now),
        'Başlangıç zamanı geçmişte olamaz.',
      );
    });

    test('accepts now and the future', () {
      expect(BookingValidator.start(now, now), isNull);
      expect(
        BookingValidator.start(now.add(const Duration(hours: 2)), now),
        isNull,
      );
    });
  });

  group('end', () {
    final start = now.add(const Duration(hours: 2));

    test('rejects missing end', () {
      expect(BookingValidator.end(null, start), isNotNull);
    });

    test('rejects end before or equal to start', () {
      expect(
        BookingValidator.end(start.subtract(const Duration(hours: 1)), start),
        'Bitiş zamanı başlangıçtan sonra olmalı.',
      );
      expect(BookingValidator.end(start, start), isNotNull);
    });

    test('accepts end after start', () {
      expect(
        BookingValidator.end(start.add(const Duration(hours: 25)), start),
        isNull,
      );
    });

    test('only requires a chosen end when start is unknown', () {
      expect(BookingValidator.end(now, null), isNull);
    });
  });
}
