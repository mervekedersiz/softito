import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım v1 initial smoke test and widget loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // Verify app title and water tracker section
    expect(find.text('Susadım v1'), findsOneWidget);
    expect(find.text('Günlük Su Takibi'), findsOneWidget);
    expect(find.text('Hızlı Su Ekle'), findsOneWidget);

    // Verify theme toggle button exists and works
    final themeButton = find.byTooltip('Aydınlık Moda Geç');
    expect(themeButton, findsOneWidget);

    await tester.tap(themeButton);
    await tester.pumpAndSettle();

    // After switching to light mode, button tooltip changes
    expect(find.byTooltip('Karanlık Moda Geç'), findsOneWidget);
  });
}
