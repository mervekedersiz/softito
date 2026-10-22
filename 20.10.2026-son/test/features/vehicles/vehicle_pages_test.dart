import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/pump_app.dart';

void main() {
  Future<void> openVehicles(WidgetTester tester) async {
    await openTab(tester, 'Araçlar');
  }

  testWidgets('lists all five demo vehicles with prices', (tester) async {
    await pumpApp(tester);
    await openVehicles(tester);

    expect(find.text('5 araç bulundu'), findsOneWidget);
    for (final name in [
      'Tesla Model 3',
      'Toyota Corolla',
      'Renault Clio',
      'Fiat Egea',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.textContaining('₺2.450'), findsOneWidget);
  });

  testWidgets('filter chips narrow the list and can be cleared', (
    tester,
  ) async {
    await pumpApp(tester);
    await openVehicles(tester);

    await tester.tap(find.widgetWithText(FilterChip, 'Elektrik'));
    await tester.pumpAndSettle();
    expect(find.text('1 araç bulundu'), findsOneWidget);
    expect(find.text('Tesla Model 3'), findsOneWidget);
    expect(find.text('Renault Clio'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Manuel'));
    await tester.pumpAndSettle();
    expect(find.text('Sonuç bulunamadı'), findsOneWidget);

    await tester.tap(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();
    expect(find.text('5 araç bulundu'), findsOneWidget);
  });

  testWidgets('price filter rejects min greater than max', (tester) async {
    await pumpApp(tester);
    await openVehicles(tester);

    final priceFinder = find.text('Fiyat');
    await tester.scrollUntilVisible(
      priceFinder,
      50,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(priceFinder);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'En az (₺)'),
      '2000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'En çok (₺)'),
      '1000',
    );
    await tester.tap(find.text('Uygula'));
    await tester.pumpAndSettle();

    expect(find.text('Üst limit, alt limitten küçük olamaz.'), findsOneWidget);
    expect(find.text('5 araç bulundu'), findsOneWidget);
  });

  testWidgets('price filter applies a valid range', (tester) async {
    await pumpApp(tester);
    await openVehicles(tester);

    final priceFinder = find.text('Fiyat');
    await tester.scrollUntilVisible(
      priceFinder,
      50,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(priceFinder);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'En çok (₺)'),
      '1000',
    );
    await tester.tap(find.text('Uygula'));
    await tester.pumpAndSettle();

    expect(find.text('1 araç bulundu'), findsOneWidget);
    expect(find.text('Renault Clio'), findsOneWidget);
  });

  testWidgets('detail page shows specs and an enabled Kirala button', (
    tester,
  ) async {
    await pumpApp(tester);
    await openVehicles(tester);

    await tester.tap(find.text('Toyota Corolla'));
    await tester.pumpAndSettle();

    expect(find.text('Örnek müsaitlik (demo)'), findsOneWidget);
    expect(find.text('Özellikler'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Kirala'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('unavailable vehicle cannot be rented', (tester) async {
    await pumpApp(tester);
    await openVehicles(tester);

    await tester.scrollUntilVisible(
      find.text('Volkswagen Passat'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Volkswagen Passat'));
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Şu an müsait değil'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('favorite toggle adds the vehicle to the Favoriler tab', (
    tester,
  ) async {
    await pumpApp(tester);
    await openVehicles(tester);

    await tester.tap(find.byTooltip('Tesla Model 3 favorilere ekle'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Tesla Model 3 favorilerden çıkar'), findsOneWidget);

    await openTab(tester, 'Favoriler');
    expect(find.text('Tesla Model 3'), findsOneWidget);
    expect(find.text('Favori araç yok'), findsNothing);

    await tester.tap(find.byTooltip('Tesla Model 3 favorilerden çıkar'));
    await tester.pumpAndSettle();
    expect(find.text('Favori araç yok'), findsOneWidget);
  });

  testWidgets('shows an error state with retry when loading fails', (
    tester,
  ) async {
    await pumpApp(tester, vehicleRepository: FailingVehicleRepository());
    await openVehicles(tester);

    expect(find.text('Araçlar yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar dene'), findsOneWidget);
  });
}
