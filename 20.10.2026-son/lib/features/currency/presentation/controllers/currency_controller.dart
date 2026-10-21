import 'package:flutter/foundation.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/services/currency_service.dart';

/// Controller providing active currency and real-time converted rates across the entire app.
class CurrencyController extends ChangeNotifier {
  CurrencyController({CurrencyService? service})
      : _service = service ?? CurrencyService() {
    _initRates();
  }

  final CurrencyService _service;
  Currency _selected = Currency.tryCurrency;
  bool _isLoading = false;
  DateTime? _lastQueried;
  Map<Currency, ExchangeRate> _rates = {};

  Currency get selected => _selected;
  bool get isLoading => _isLoading;
  DateTime? get lastQueried => _lastQueried;
  Map<Currency, ExchangeRate> get rates => Map.unmodifiable(_rates);

  void _initRates() {
    final now = DateTime.now();
    _rates = {
      Currency.tryCurrency: ExchangeRate(currency: Currency.tryCurrency, rateAgainstTry: 1.0, changePercent: 0.0, lastUpdated: now),
      Currency.usd: ExchangeRate(currency: Currency.usd, rateAgainstTry: 34.45, changePercent: 0.18, lastUpdated: now),
      Currency.eur: ExchangeRate(currency: Currency.eur, rateAgainstTry: 37.35, changePercent: -0.12, lastUpdated: now),
      Currency.gbp: ExchangeRate(currency: Currency.gbp, rateAgainstTry: 44.80, changePercent: 0.25, lastUpdated: now),
    };
    _lastQueried = now;
  }

  void selectCurrency(Currency currency) {
    if (_selected != currency) {
      _selected = currency;
      notifyListeners();
    }
  }

  /// Anlık kur sorgulama (Live rate query)
  Future<void> refreshLiveRates() async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetched = await _service.fetchLiveRates();
      _rates = fetched;
      _lastQueried = DateTime.now();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Converts a given TRY amount to the currently selected currency.
  double convert(num amountInTry) {
    final rate = _rates[_selected];
    if (rate == null) return amountInTry.toDouble();
    return rate.convertFromTry(amountInTry);
  }

  /// Formats converted amount with proper symbol, e.g. "$71.20" or "₺2.450".
  String format(num amountInTry) {
    final converted = convert(amountInTry);
    final symbol = _selected.symbol;
    if (_selected == Currency.tryCurrency) {
      final rounded = converted.round();
      final digits = rounded.abs().toString();
      final buffer = StringBuffer();
      for (var i = 0; i < digits.length; i++) {
        if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
        buffer.write(digits[i]);
      }
      return '${rounded < 0 ? '-' : ''}₺$buffer';
    } else {
      return '$symbol${converted.toStringAsFixed(1)}';
    }
  }
}
