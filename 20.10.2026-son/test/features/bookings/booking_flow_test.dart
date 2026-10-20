import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/pump_app.dart';

void main() {
  Future<void> openCorollaForm(WidgetTester tester) async {
    await openTab(tester, 'Araçlar');
    await tester.tap(find.text('Toyota Corolla'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Kirala'));
    await tester.pumpAndSettle();
  }

  Future<void> pickLocation(
    WidgetTester tester,
    String field,
    String option,
  ) async {
    await tester.tap(find.text(field));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  /// Fills a valid form: end defaults to start + 24h, i.e. exactly 1 day.
  Future<void> fillValidForm(WidgetTester tester) async {
    await pickLocation(tester, 'Alış konumu', 'İstanbul Havalimanı');
    await pickLocation(tester, 'Teslim konumu', 'Kadıköy Merkez Ofis');
    await tester.tap(find.text('Bitiş tarihi ve saati'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tamam')); // date picker
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tamam')); // time picker
    await tester.pumpAndSettle();
  }

  Future<void> tapReview(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Talebi incele'));
    await tester.tap(find.text('Talebi incele'));
    await tester.pumpAndSettle();
  }

  testWidgets('empty form shows Turkish errors and creates no booking', (
    tester,
  ) async {
    final deps = await pumpApp(tester);
    await openCorollaForm(tester);

    await tapReview(tester);

    expect(find.text('Alış konumunu seçin.'), findsOneWidget);
    expect(find.text('Teslim konumunu seçin.'), findsOneWidget);
    expect(find.text('Bitiş tarih ve saatini seçin.'), findsOneWidget);
    expect(find.text('Talebi onayla'), findsNothing);
    expect(deps.bookings.bookings, isEmpty);
  });

  testWidgets('price card explains the rule and shows a hint first', (
    tester,
  ) async {
    await pumpApp(tester);
    await openCorollaForm(tester);

    expect(find.textContaining('25 saat = 2 gün'), findsOneWidget);
    expect(find.textContaining('Geçerli bir başlangıç'), findsOneWidget);
  });

  testWidgets('valid form shows the live total for exactly 1 day', (
    tester,
  ) async {
    await pumpApp(tester);
    await openCorollaForm(tester);
    await fillValidForm(tester);

    expect(find.text('₺1.650'), findsWidgets);
    expect(find.text('1 gün'), findsWidgets);
  });

  testWidgets('cancelling the dialog creates no booking', (tester) async {
    final deps = await pumpApp(tester);
    await openCorollaForm(tester);
    await fillValidForm(tester);

    await tapReview(tester);
    expect(find.text('Talebi onayla'), findsOneWidget);
    expect(find.textContaining('Bu bir demo taleptir'), findsOneWidget);

    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();

    expect(find.text('Talebi onayla'), findsNothing);
    expect(find.text('Kiralama talebi'), findsOneWidget);
    expect(deps.bookings.bookings, isEmpty);
    expect(find.textContaining('oluşturuldu'), findsNothing);
  });

  testWidgets('confirming creates a demo booking, snackbar and ticket', (
    tester,
  ) async {
    final deps = await pumpApp(tester);
    await openCorollaForm(tester);
    await fillValidForm(tester);

    await tapReview(tester);
    await tester.tap(find.text('Demo talebi oluştur'));
    await tester.pumpAndSettle();

    expect(deps.bookings.bookings, hasLength(1));
    expect(deps.bookings.bookings.first.billableDays, 1);
    expect(deps.bookings.bookings.first.estimatedTotal, 1650);
    expect(
      find.textContaining('Demo rezervasyon talebi oluşturuldu'),
      findsOneWidget,
    );
    expect(find.widgetWithText(AppBar, 'Rezervasyonlarım'), findsOneWidget);
    expect(find.text('DEMO-0001'), findsOneWidget);
    expect(find.text('Demo talep'), findsOneWidget);
    expect(find.byType(Badge), findsOneWidget);
  });
}
