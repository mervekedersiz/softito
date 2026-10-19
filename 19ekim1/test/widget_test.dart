import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım app renders and adds water correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify initial water amount is 0 ml
    expect(find.text('0 ml'), findsOneWidget);
    expect(find.text('Susadım • Su Takibi'), findsOneWidget);

    // Tap quick water add button (+200 ml)
    await tester.tap(find.text('+200 ml'));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify water amount increased to 200 ml
    expect(find.text('200 ml'), findsOneWidget);
  });
}
