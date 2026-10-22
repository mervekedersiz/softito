class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day)
    : assert(year > 0),
      assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 31);

  factory LocalDate.fromDateTime(DateTime dateTime) {
    return LocalDate(dateTime.year, dateTime.month, dateTime.day);
  }

  factory LocalDate.parse(String yyyyMmDd) {
    final parts = yyyyMmDd.split('-');
    if (parts.length != 3) {
      throw FormatException('Geçersiz LocalDate formatı: $yyyyMmDd');
    }
    final y = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final d = int.parse(parts[2]);
    return LocalDate(y, m, d);
  }

  final int year;
  final int month;
  final int day;

  int get weekday =>
      DateTime(year, month, day).weekday; // 1 = Monday, 7 = Sunday

  String get key =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  LocalDate addDays(int days) {
    final dt = DateTime(year, month, day).add(Duration(days: days));
    return LocalDate(dt.year, dt.month, dt.day);
  }

  int differenceInDays(LocalDate other) {
    final a = DateTime(year, month, day);
    final b = DateTime(other.year, other.month, other.day);
    return a.difference(b).inDays;
  }

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;
  bool isAtSameMomentAs(LocalDate other) => compareTo(other) == 0;

  DateTime toDateTime([int hour = 0, int minute = 0, int second = 0]) {
    return DateTime(year, month, day, hour, minute, second);
  }

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDate &&
          other.year == year &&
          other.month == month &&
          other.day == day);

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => key;
}
