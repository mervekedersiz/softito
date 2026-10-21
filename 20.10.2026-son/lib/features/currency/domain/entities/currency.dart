/// Supported currencies for multi-currency conversion and live pricing.
enum Currency {
  tryCurrency('TRY', '₺', 'Türk Lirası'),
  usd('USD', '\$', 'Amerikan Doları'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'İngiliz Sterlini');

  const Currency(this.code, this.symbol, this.displayName);

  final String code;
  final String symbol;
  final String displayName;
}
