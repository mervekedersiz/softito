enum CardBrand {
  visa('Visa', 'VISA'),
  mastercard('Mastercard', 'MC'),
  troy('Troy', 'TROY'),
  amex('American Express', 'AMEX'),
  unknown('Banka Kartı', 'CARD');

  const CardBrand(this.displayName, this.shortCode);
  final String displayName;
  final String shortCode;
}

class CreditCardModel {
  const CreditCardModel({
    required this.number,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
  });

  final String number;
  final String holderName;
  final String expiryDate;
  final String cvv;

  CardBrand get brand {
    final clean = number.replaceAll(' ', '');
    if (clean.startsWith('4')) return CardBrand.visa;
    if (clean.startsWith('9792')) return CardBrand.troy;
    if (clean.startsWith('34') || clean.startsWith('37')) return CardBrand.amex;
    if (clean.startsWith('51') || clean.startsWith('52') || clean.startsWith('53') || clean.startsWith('54') || clean.startsWith('55') || clean.startsWith('22') || clean.startsWith('27')) {
      return CardBrand.mastercard;
    }
    return CardBrand.unknown;
  }

  String get formattedNumber {
    final clean = number.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var i = 0; i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      if (i < clean.length) {
        buffer.write(clean[i]);
      } else {
        buffer.write('•');
      }
    }
    return buffer.toString();
  }
}
