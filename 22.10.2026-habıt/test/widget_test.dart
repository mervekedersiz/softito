import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freshtrack/app/app.dart';

void main() {
  testWidgets('FreshTrackApp bootstrap smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FreshTrackApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify FreshTrack title exists
    expect(find.text('FreshTrack'), findsWidgets);
  });
}
