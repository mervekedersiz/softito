import 'currency.dart';

/// Exchange rate entity capturing rate against base TRY currency and market change.
class ExchangeRate {
  const ExchangeRate({
    required this.currency,
    required this.rateAgainstTry,
    required this.changePercent,
    required this.lastUpdated,
    this.isLive = true,
  });

  final Currency currency;

  /// Price of 1 unit of this currency in Turkish Liras (e.g. 1 USD = 34.40 TRY).
  /// For TRY itself, rate is 1.0.
  final double rateAgainstTry;

  /// 24h percentage change (e.g. +0.42% or -0.15%).
  final double changePercent;

  final DateTime lastUpdated;
  final bool isLive;

  /// Converts a TRY amount into this currency.
  double convertFromTry(num tryAmount) {
    if (currency == Currency.tryCurrency || rateAgainstTry <= 0) {
      return tryAmount.toDouble();
    }
    return tryAmount / rateAgainstTry;
  }
}
