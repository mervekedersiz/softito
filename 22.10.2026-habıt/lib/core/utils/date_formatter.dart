import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const List<String> _turkishMonths = [
    '',
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];

  static String toTurkishDate(DateTime date) {
    return '${date.day} ${_turkishMonths[date.month]} ${date.year}';
  }

  static String toShortDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String toTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String toDateTimeString(DateTime date) {
    return '${toTurkishDate(date)} ${toTime(date)}';
  }
}
