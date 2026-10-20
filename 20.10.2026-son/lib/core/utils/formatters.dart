/// Formats a whole-lira amount Turkish style, e.g. `₺1.250`.
String formatLira(num amount) {
  final rounded = amount.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${rounded < 0 ? '-' : ''}₺$buffer';
}

const List<String> _shortMonths = [
  'Oca',
  'Şub',
  'Mar',
  'Nis',
  'May',
  'Haz',
  'Tem',
  'Ağu',
  'Eyl',
  'Eki',
  'Kas',
  'Ara',
];

const List<String> _shortWeekdays = [
  'Pzt',
  'Sal',
  'Çar',
  'Per',
  'Cum',
  'Cmt',
  'Paz',
];

String _two(int value) => value.toString().padLeft(2, '0');

/// `21 Eki 2026, 14:30`
String formatDateTime(DateTime value) {
  return '${formatDate(value)}, ${_two(value.hour)}:${_two(value.minute)}';
}

/// `21 Eki 2026`
String formatDate(DateTime value) {
  return '${value.day} ${_shortMonths[value.month - 1]} ${value.year}';
}

/// `21 Eki`
String formatDayMonth(DateTime value) {
  return '${value.day} ${_shortMonths[value.month - 1]}';
}

/// `Sal`, `Çar`, ...
String formatWeekday(DateTime value) => _shortWeekdays[value.weekday - 1];

/// `1 gün 1 saat`, `25 saat` is expressed as days and hours.
String formatDuration(Duration value) {
  final parts = <String>[
    if (value.inDays > 0) '${value.inDays} gün',
    if (value.inHours % 24 > 0) '${value.inHours % 24} saat',
    if (value.inMinutes % 60 > 0) '${value.inMinutes % 60} dk',
  ];
  return parts.isEmpty ? '0 dk' : parts.join(' ');
}
