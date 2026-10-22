import 'package:flutter_test/flutter_test.dart';
import 'package:yol_ortagim/features/auth/domain/entities/user.dart';
import 'package:yol_ortagim/features/auth/presentation/controllers/auth_controller.dart';
import 'package:yol_ortagim/features/currency/domain/entities/currency.dart';
import 'package:yol_ortagim/features/currency/presentation/controllers/currency_controller.dart';
import 'package:yol_ortagim/features/map_pins/domain/entities/map_pin.dart';
import 'package:yol_ortagim/features/map_pins/presentation/controllers/map_pin_controller.dart';
import 'package:yol_ortagim/features/nfc_pass/presentation/controllers/nfc_controller.dart';
import 'package:yol_ortagim/features/payment/domain/entities/credit_card.dart';

void main() {
  group('Currency & Live Exchange Rates', () {
    test('converts TRY amounts correctly based on active currency', () {
      final controller = CurrencyController();
      expect(controller.selected, Currency.tryCurrency);
      expect(controller.convert(1000), 1000.0);
      expect(controller.format(1000), contains('₺1.000'));

      controller.selectCurrency(Currency.usd);
      expect(controller.selected, Currency.usd);
      expect(controller.convert(3445), closeTo(100, 1.0));
      expect(controller.format(3445), contains('\$'));
    });
  });

  group('Role-Based Auth & Permissions', () {
    test('customer has basic booking permissions but not admin panel', () {
      final auth = AuthController();
      expect(auth.currentUser?.role, UserRole.customer);
      expect(auth.hasPermission(AppPermission.bookVehicle), isTrue);
      expect(auth.hasPermission(AppPermission.accessAdminPanel), isFalse);

      auth.switchRole(UserRole.admin);
      expect(auth.isAdmin, isTrue);
      expect(auth.hasPermission(AppPermission.accessAdminPanel), isTrue);
      expect(auth.hasPermission(AppPermission.manageFleet), isTrue);
    });
  });

  group('Credit Card & Brand Detection', () {
    test('detects Visa, Mastercard, and Troy correctly', () {
      const visa = CreditCardModel(
        number: '4543 2800 1928 4402',
        holderName: 'AHMET',
        expiryDate: '12/28',
        cvv: '123',
      );
      expect(visa.brand, CardBrand.visa);

      const mc = CreditCardModel(
        number: '5420 1111 2222 3333',
        holderName: 'MEHMET',
        expiryDate: '01/29',
        cvv: '456',
      );
      expect(mc.brand, CardBrand.mastercard);

      const troy = CreditCardModel(
        number: '9792 0000 1111 2222',
        holderName: 'TROY KART',
        expiryDate: '05/27',
        cvv: '789',
      );
      expect(troy.brand, CardBrand.troy);
    });
  });

  group('NFC & Daily Ride Quota', () {
    test('simulateTap deducts ride and minutes, fails when quota exhausted', () async {
      final nfc = NfcController();
      expect(nfc.pass.remainingMinutes, 75);
      expect(nfc.pass.remainingRides, 2);

      final success = await nfc.simulateTap();
      expect(success, isTrue);
      expect(nfc.pass.remainingMinutes, 60);
      expect(nfc.pass.remainingRides, 1);
      expect(nfc.state, NfcScanState.success);

      final failed = await nfc.simulateTap(forceQuotaExceeded: true);
      expect(failed, isFalse);
      expect(nfc.state, NfcScanState.failedQuota);

      nfc.rechargeQuota();
      expect(nfc.pass.remainingMinutes, 120);
      expect(nfc.pass.remainingRides, 3);
    });
  });

  group('Interactive Map & Pin Adding', () {
    test('adds new pins dynamically and filters by type', () {
      final mapCtrl = MapPinController();
      final initialCount = mapCtrl.pins.length;

      mapCtrl.addPin(
        title: 'Kadıköy Hızlı Şarj',
        subtitle: '300 kW Supercharger',
        type: MapPinType.supercharger,
        normalizedX: 0.5,
        normalizedY: 0.5,
      );

      expect(mapCtrl.pins.length, initialCount + 1);
      expect(mapCtrl.selectedPin?.title, 'Kadıköy Hızlı Şarj');

      mapCtrl.setFilter(MapPinType.supercharger);
      expect(mapCtrl.pins.every((p) => p.type == MapPinType.supercharger), isTrue);
    });
  });
}
