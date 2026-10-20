import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/features/bookings/domain/services/rental_pricing.dart';

void main() {
  group('billableDays', () {
    test('rejects zero duration', () {
      expect(
        () => RentalPricing.billableDays(Duration.zero),
        throwsArgumentError,
      );
    });

    test('rejects negative duration', () {
      expect(
        () => RentalPricing.billableDays(const Duration(hours: -3)),
        throwsArgumentError,
      );
    });

    test('1 minute counts as 1 day', () {
      expect(RentalPricing.billableDays(const Duration(minutes: 1)), 1);
    });

    test('24 hours is exactly 1 day', () {
      expect(RentalPricing.billableDays(const Duration(hours: 24)), 1);
    });

    test('25 hours is 2 days', () {
      expect(RentalPricing.billableDays(const Duration(hours: 25)), 2);
    });

    test('48 hours is 2 days and 48h 1min is 3 days', () {
      expect(RentalPricing.billableDays(const Duration(hours: 48)), 2);
      expect(
        RentalPricing.billableDays(const Duration(hours: 48, minutes: 1)),
        3,
      );
    });
  });

  group('estimatedTotal', () {
    test('multiplies billable days by the daily price', () {
      final total = RentalPricing.estimatedTotal(
        duration: const Duration(hours: 25),
        dailyPrice: 1000,
      );
      expect(total, 2000);
      expect(total, isPositive);
    });

    test('rejects a non-positive daily price', () {
      expect(
        () => RentalPricing.estimatedTotal(
          duration: const Duration(hours: 24),
          dailyPrice: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a non-positive duration', () {
      expect(
        () => RentalPricing.estimatedTotal(
          duration: const Duration(hours: -1),
          dailyPrice: 500,
        ),
        throwsArgumentError,
      );
    });
  });
}
