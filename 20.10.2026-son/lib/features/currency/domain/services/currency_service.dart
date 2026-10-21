import 'dart:math';
import '../entities/currency.dart';
import '../entities/exchange_rate.dart';

/// Service for real-time exchange rate querying (Anlık Kur Sorgulama).
class CurrencyService {
  CurrencyService();

  // Baseline market rates in TRY
  final Map<Currency, double> _baseRates = {
    Currency.tryCurrency: 1.0,
    Currency.usd: 34.45,
    Currency.eur: 37.35,
    Currency.gbp: 44.80,
  };

  /// Fetches live rates, simulating network querying with slight real-world fluctuations.
  Future<Map<Currency, ExchangeRate>> fetchLiveRates() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final random = Random();
    final now = DateTime.now();

    final result = <Currency, ExchangeRate>{};

    for (final entry in _baseRates.entries) {
      if (entry.key == Currency.tryCurrency) {
        result[Currency.tryCurrency] = ExchangeRate(
          currency: Currency.tryCurrency,
          rateAgainstTry: 1.0,
          changePercent: 0.0,
          lastUpdated: now,
        );
        continue;
      }

      // Small jitter between -0.3% and +0.3% to simulate live ticker
      final jitterPercent = (random.nextDouble() * 0.6) - 0.3;
      final currentRate = entry.value * (1 + (jitterPercent / 100));

      result[entry.key] = ExchangeRate(
        currency: entry.key,
        rateAgainstTry: double.parse(currentRate.toStringAsFixed(2)),
        changePercent: double.parse(jitterPercent.toStringAsFixed(2)),
        lastUpdated: now,
      );
    }

    return result;
  }
}
