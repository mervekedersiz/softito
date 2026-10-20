/// MVP pricing: every started 24-hour block is one billable day.
abstract final class RentalPricing {
  static const int _microsecondsPerDay = 24 * 60 * 60 * 1000 * 1000;

  /// `ceil(duration / 24h)`. Throws [ArgumentError] unless duration > 0.
  static int billableDays(Duration duration) {
    if (duration <= Duration.zero) {
      throw ArgumentError.value(
        duration,
        'duration',
        'Kiralama süresi sıfırdan büyük olmalı.',
      );
    }
    return (duration.inMicroseconds + _microsecondsPerDay - 1) ~/
        _microsecondsPerDay;
  }

  /// `billableDays * dailyPrice`. Throws [ArgumentError] for invalid input.
  static int estimatedTotal({
    required Duration duration,
    required int dailyPrice,
  }) {
    if (dailyPrice <= 0) {
      throw ArgumentError.value(
        dailyPrice,
        'dailyPrice',
        'Günlük fiyat pozitif olmalı.',
      );
    }
    return billableDays(duration) * dailyPrice;
  }
}
