import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım v1 Su Takibi ve Egzersiz iki sekme ve tema testi', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // 1. Su Takibi Sekmesi Kontrolü
    expect(find.text('Susadım v1'), findsOneWidget);
    expect(find.text('HIZLI SU EKLE'), findsOneWidget);
    expect(find.text('Su Takibi'), findsOneWidget);
    expect(find.text('Egzersiz'), findsOneWidget);

    // Su ekleme testi
    expect(find.text('1250'), findsOneWidget);
    await tester.tap(find.text('+200'));
    await tester.pumpAndSettle();
    expect(find.text('1450'), findsOneWidget);

    // 2. Egzersiz Sekmesine Geçiş
    await tester.tap(find.text('Egzersiz'));
    await tester.pumpAndSettle();

    expect(find.text('GÜNLÜK ANTRENMAN ÖZETİ'), findsOneWidget);
    expect(find.text('ANTRENMAN LİSTESİ'), findsOneWidget);
    expect(find.text('HIIT Kardiyo & Sprint'), findsOneWidget);

    // Egzersiz Uygula butonuna bas
    await tester.tap(find.text('Uygula').first);
    await tester.pumpAndSettle();

    // 3. Su Takibi sekmesine geri dön
    await tester.tap(find.text('Su Takibi'));
    await tester.pumpAndSettle();
    expect(find.text('HIZLI SU EKLE'), findsOneWidget);

    // 4. Tema Değiştirme
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.light_mode_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
  });
}
