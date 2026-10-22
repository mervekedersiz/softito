import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/core/utils/formatters.dart';

void main() {
  test('formatLira groups thousands with dots', () {
    expect(formatLira(950), '₺950');
    expect(formatLira(1250), '₺1.250');
    expect(formatLira(1234567), '₺1.234.567');
    expect(formatLira(0), '₺0');
  });

  test('formatDateTime uses Turkish month names and 24h clock', () {
    expect(formatDateTime(DateTime(2026, 10, 21, 9, 5)), '21 Eki 2026, 09:05');
    expect(formatDate(DateTime(2026, 1, 3)), '3 Oca 2026');
  });

  test('formatDuration splits days, hours and minutes', () {
    expect(formatDuration(const Duration(hours: 25)), '1 gün 1 saat');
    expect(formatDuration(const Duration(hours: 24)), '1 gün');
    expect(formatDuration(const Duration(minutes: 90)), '1 saat 30 dk');
    expect(formatDuration(Duration.zero), '0 dk');
  });
}
