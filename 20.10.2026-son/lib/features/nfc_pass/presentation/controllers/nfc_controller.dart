import 'package:flutter/foundation.dart';
import '../../domain/entities/nfc_pass.dart';

enum NfcScanState { idle, scanning, success, failedQuota, failedHardware }

class NfcController extends ChangeNotifier {
  NfcController() {
    _pass = const NfcPass(
      cardId: 'YOL-PASS-7842',
      holderName: 'AHMET YILMAZ',
      totalDailyMinutes: 120,
      remainingMinutes: 75,
      totalDailyRides: 3,
      remainingRides: 2,
    );
  }

  late NfcPass _pass;
  NfcScanState _state = NfcScanState.idle;
  String? _lastScanMessage;

  NfcPass get pass => _pass;
  NfcScanState get state => _state;
  String? get lastScanMessage => _lastScanMessage;

  /// Simulates tapping an NFC physical card or device.
  Future<bool> simulateTap({bool forceQuotaExceeded = false}) async {
    _state = NfcScanState.scanning;
    _lastScanMessage = 'NFC Kart okunuyor... Lütfen cihazı sabit tutun.';
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (forceQuotaExceeded || !_pass.hasRemainingQuota) {
      _state = NfcScanState.failedQuota;
      _lastScanMessage = 'İşlem Başarısız: Bugün için ayrılan sürüş hakkınız veya kalan süreniz tükendi!';
      notifyListeners();
      return false;
    }

    _pass = _pass.copyWith(
      remainingMinutes: (_pass.remainingMinutes - 15).clamp(0, 120),
      remainingRides: (_pass.remainingRides - 1).clamp(0, 3),
    );
    _state = NfcScanState.success;
    _lastScanMessage = 'Kart Başarıyla Okundu (${_pass.cardId})! Araç kilidi açıldı ve sürüş başladı.';
    notifyListeners();
    return true;
  }

  void rechargeQuota() {
    _pass = _pass.copyWith(
      remainingMinutes: _pass.totalDailyMinutes,
      remainingRides: _pass.totalDailyRides,
    );
    _state = NfcScanState.idle;
    _lastScanMessage = 'Günlük sürüş hakkı 120 dakika (3 sürüş) olarak yenilendi.';
    notifyListeners();
  }

  void resetState() {
    _state = NfcScanState.idle;
    _lastScanMessage = null;
    notifyListeners();
  }
}
