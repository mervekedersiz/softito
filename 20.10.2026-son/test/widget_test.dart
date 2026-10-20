import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/pump_app.dart';

void main() {
  testWidgets('home shows the hero, active module and demo notice', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Amacın ne?'), findsOneWidget);
    expect(find.text('Araba Kirala'), findsOneWidget);
    expect(find.textContaining('Demo sürüm'), findsOneWidget);
    expect(find.text('Popüler araçlar'), findsOneWidget);
  });

  testWidgets('upcoming modules are labelled Yakında and not tappable', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('Acemiyim'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Yakında'), findsWidgets);

    await tester.tap(find.text('Acemiyim'));
    await tester.pumpAndSettle();
    expect(find.text('Acemiyim'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Araçlar'), findsNothing);
  });

  testWidgets('bottom navigation switches between all five tabs', (
    tester,
  ) async {
    await pumpApp(tester);

    const titles = {
      'Araçlar': 'Araçlar',
      'Rezervasyonlar': 'Rezervasyonlarım',
      'Favoriler': 'Favoriler',
      'Profil': 'Profil',
    };
    for (final entry in titles.entries) {
      await openTab(tester, entry.key);
      expect(find.widgetWithText(AppBar, entry.value), findsOneWidget);
    }

    await openTab(tester, 'Ana Sayfa');
    expect(find.text('Amacın ne?'), findsOneWidget);
  });

  testWidgets('"Araba Kirala" opens the vehicles tab', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Araba Kirala'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Araçlar'), findsOneWidget);
    expect(find.text('Tesla Model 3'), findsOneWidget);
  });

  testWidgets('category shortcut opens vehicles with the filter applied', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ActionChip, 'Elektrik'));
    await tester.pumpAndSettle();

    expect(find.text('1 araç bulundu'), findsOneWidget);
    expect(find.text('Tesla Model 3'), findsOneWidget);
  });

  testWidgets('wide screens use a navigation rail instead of a bar', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(1200, 900));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('narrow screens use the bottom navigation bar', (tester) async {
    await pumpApp(tester, size: const Size(420, 900));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('profile switches the theme to dark and back', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Profil');

    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await tester.tap(find.text('Açık'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  testWidgets('empty bookings and favorites show helpful empty states', (
    tester,
  ) async {
    await pumpApp(tester);

    await openTab(tester, 'Rezervasyonlar');
    expect(find.text('Henüz demo talebin yok'), findsOneWidget);

    await openTab(tester, 'Favoriler');
    expect(find.text('Favori araç yok'), findsOneWidget);
  });
}
