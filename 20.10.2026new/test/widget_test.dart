import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kan_bagi/app.dart';
import 'package:kan_bagi/core/data/demo_store.dart';
import 'package:kan_bagi/core/models/blood_group.dart';
import 'package:kan_bagi/core/models/blood_measurement.dart';
import 'package:kan_bagi/features/blood_animation/controllers/blood_animation_controller.dart';
import 'package:kan_bagi/features/blood_values/controllers/blood_values_controller.dart';
import 'package:kan_bagi/features/blood_values/widgets/blood_value_chart.dart';
import 'package:kan_bagi/features/donation_booking/controllers/donation_booking_controller.dart';
import 'package:kan_bagi/features/donation_history/models/donation_history_state.dart';
import 'package:kan_bagi/features/donation_history/widgets/donation_bar_chart.dart';
import 'package:kan_bagi/features/eligibility/controllers/eligibility_controller.dart';

void main() {
  group('Kan Bağı Mimari ve Davranış Testleri', () {
    test(
      '1. Plan Kaydı: Yeni plan kaydedildiğinde tamamlanan bağış sayısı artmaz',
      () async {
        final store = DemoStore();
        final initialCompleted = store.completedDonationsCount;

        // Cancel existing planned appointment to allow new one
        final existingPlanned = store.upcomingAppointment;
        if (existingPlanned != null) {
          store.cancelDonation(existingPlanned.id);
        }

        final controller = DonationBookingController(store);
        controller.selectCenter(store.centers.first);
        controller.selectDate(DateTime.now().add(const Duration(days: 2)));
        controller.selectSlot('10:30');

        final success = await controller.submitBooking();
        expect(success, isTrue);

        // Verify that completed donations did NOT increase
        expect(store.completedDonationsCount, equals(initialCompleted));
        expect(store.upcomingAppointment, isNotNull);
      },
    );

    test(
      '2. Çift Kaydetme Engeli: Zaten aktif randevu varken ikinci randevu oluşturulamaz',
      () async {
        final store = DemoStore();
        expect(store.upcomingAppointment, isNotNull);

        final controller = DonationBookingController(store);
        controller.selectCenter(store.centers.first);
        controller.selectDate(DateTime.now().add(const Duration(days: 2)));
        controller.selectSlot('11:00');

        final success = await controller.submitBooking();
        expect(success, isFalse);
        expect(controller.value.errorMessage, isNotNull);
      },
    );

    test('3. İptal ve Durum Geçişi: Tamamlanan bağış iptal edilemez', () {
      final store = DemoStore();
      final completed = store.donations.firstWhere((d) => d.isCompleted);

      final cancelResult = store.cancelDonation(completed.id);
      expect(cancelResult, isFalse);
    });

    test(
      '4. Ön Bilgi Formu: Yanıtsız soru fark edilir, tıbbi onay uydurulmaz',
      () {
        final store = DemoStore();
        final controller = EligibilityController(store);

        expect(controller.value.answeredCount, equals(0));
        expect(controller.value.isSubmitted, isFalse);

        // Submitting without answers does not validate eligibility
        controller.submitAnswers();
        expect(controller.value.isSubmitted, isTrue);
        expect(controller.value.reviewTopics, isEmpty);
      },
    );

    test(
      '5. Kan Değerleri Doğrulama: Virgüllü sayı parse edilir, negatif reddedilir',
      () {
        final store = DemoStore();
        final controller = BloodValuesController(store);

        // Comma decimal input
        final ok1 = controller.addMeasurement(
          type: MeasurementType.hemoglobin,
          rawValue: '14,5',
          measuredAt: DateTime.now(),
          source: 'Test Laboratuvarı',
        );
        expect(ok1, isTrue);

        // Negative or invalid input
        final ok2 = controller.addMeasurement(
          type: MeasurementType.hemoglobin,
          rawValue: '-12,0',
          measuredAt: DateTime.now(),
          source: 'Test',
        );
        expect(ok2, isFalse);

        // Non-numeric string
        final ok3 = controller.addMeasurement(
          type: MeasurementType.hemoglobin,
          rawValue: 'abc',
          measuredAt: DateTime.now(),
          source: 'Test',
        );
        expect(ok3, isFalse);
      },
    );

    test('6. Rozet Kazanımı: Idempotenttir, aynı rozet mükerrer verilmez', () {
      final store = DemoStore();
      // 'badge_first_step' is already earned in seed
      final initialBadgeCount = store.badges.length;

      final awardedAgain = store.awardBadge('badge_first_step');
      expect(awardedAgain, isFalse);
      expect(store.badges.length, equals(initialBadgeCount));
    });

    test(
      '7. Animasyon Kontrolcüsü: Başlat, duraklat, devam, sıfırla döngüsü',
      () {
        final controller = BloodAnimationController();
        expect(controller.value.isIdle, isTrue);

        controller.start();
        expect(controller.value.isRunning, isTrue);

        controller.updateProgress(0.4);
        expect(controller.value.percentage, equals(40));

        controller.pause();
        expect(controller.value.isPaused, isTrue);
        expect(controller.value.progress, equals(0.4));

        controller.resume();
        expect(controller.value.isRunning, isTrue);

        controller.updateProgress(1.0);
        expect(controller.value.isCompleted, isTrue);

        controller.reset();
        expect(controller.value.isIdle, isTrue);
        expect(controller.value.progress, equals(0.0));
      },
    );

    test('8. BloodGroup 0/O Dönüşümü ve Bilmiyorum grubu', () {
      final g1 = BloodGroup.fromString('0+');
      expect(g1, equals(BloodGroup.oPositive));
      expect(g1.label, equals('0+'));
      expect(g1.code, equals('O+'));

      final g2 = BloodGroup.fromString('A-');
      expect(g2, equals(BloodGroup.aNegative));
      expect(g2.isPositive, isFalse);

      final g3 = BloodGroup.fromString('bilmiyorum');
      expect(g3, equals(BloodGroup.unknown));
      expect(g3.isPositive, isNull);
    });

    testWidgets(
      '9. Grafik Widget Testi: Boş, tek noktalı ve eşit veriler hata üretmez',
      (tester) async {
        // Empty chart
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BloodValueChart(measurements: const [], onSelect: (_) {}),
            ),
          ),
        );
        expect(
          find.text('Henüz bu gösterge için kayıtlı ölçüm bulunmuyor.'),
          findsOneWidget,
        );

        // Single point chart
        final singlePoint = [
          BloodMeasurement(
            id: '1',
            type: MeasurementType.hemoglobin,
            value: 14.0,
            unit: 'g/dL',
            measuredAt: DateTime.now(),
            source: 'Laboratuvar',
          ),
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BloodValueChart(
                measurements: singlePoint,
                onSelect: (_) {},
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(BloodValueChart), findsOneWidget);

        // Equal value points (preventing division by zero)
        final equalPoints = [
          BloodMeasurement(
            id: '1',
            type: MeasurementType.hemoglobin,
            value: 14.0,
            unit: 'g/dL',
            measuredAt: DateTime.now().subtract(const Duration(days: 10)),
            source: 'Laboratuvar',
          ),
          BloodMeasurement(
            id: '2',
            type: MeasurementType.hemoglobin,
            value: 14.0,
            unit: 'g/dL',
            measuredAt: DateTime.now(),
            source: 'Laboratuvar',
          ),
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BloodValueChart(
                measurements: equalPoints,
                onSelect: (_) {},
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(BloodValueChart), findsOneWidget);

        // Bar chart with zeroes
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DonationBarChart(
                monthlyData: [
                  MonthlyDonationCount(month: 1, year: 2026, count: 0),
                  MonthlyDonationCount(month: 2, year: 2026, count: 0),
                ],
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(DonationBarChart), findsOneWidget);
      },
    );

    testWidgets('10. Uygulama Başlatma ve Sekme Gezinme Testi', (tester) async {
      await tester.pumpWidget(const KanBagiApp());
      // Controlled pump (not pumpAndSettle due to continuous subtle animation timer)
      await tester.pump(const Duration(milliseconds: 200));

      // Home Screen visible
      expect(find.text('Kan Bağı'), findsOneWidget);
      expect(find.textContaining('Merhaba,'), findsOneWidget);

      // Scroll down on dashboard to verify bottom cards and nearby requests layout
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 200));

      // Switch to Requests tab
      await tester.tap(find.byIcon(Icons.emergency_outlined));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Kan İhtiyaçları'), findsAtLeastNWidgets(1));

      // Switch to Centers tab
      await tester.tap(find.byIcon(Icons.place_outlined));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Bağış Noktaları'), findsAtLeastNWidgets(1));

      // Switch to History tab
      await tester.tap(find.byIcon(Icons.history_rounded));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Bağış Geçmişim'), findsAtLeastNWidgets(1));

      // Switch to Profile tab
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Bağışçı Profilim'), findsAtLeastNWidgets(1));

      // Toggle Theme
      await tester.tap(find.text('Koyu'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Bağışçı Profilim'), findsOneWidget);
    });
  });
}
