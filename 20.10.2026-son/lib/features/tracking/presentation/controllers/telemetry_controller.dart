import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../domain/entities/telemetry.dart';

class TelemetryController extends ChangeNotifier {
  TelemetryController({bool autoStart = false}) {
    _telemetry = const VehicleTelemetry(
      vehicleId: 'tesla-model-3',
      vehicleName: 'Tesla Model 3 Long Range',
      speedKmH: 74,
      rpmOrKw: 42,
      fuelOrBatteryPercent: 88,
      latitude: 41.0082,
      longitude: 28.9784,
      altitudeMeters: 48,
      isDoorsLocked: true,
      areLightsOn: true,
      isEngineRunning: true,
    );
    if (autoStart) startTracking();
  }

  late VehicleTelemetry _telemetry;
  Timer? _ticker;
  final Random _random = Random();

  VehicleTelemetry get telemetry => _telemetry;

  void startTracking() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 2), (_) {
      final speedDelta = (_random.nextInt(7) - 3);
      final newSpeed = (_telemetry.speedKmH + speedDelta).clamp(60, 95);
      final newKw = (newSpeed * 0.6).round();
      final latJitter = (_random.nextDouble() - 0.5) * 0.0004;
      final lngJitter = (_random.nextDouble() - 0.5) * 0.0004;

      _telemetry = _telemetry.copyWith(
        speedKmH: newSpeed,
        rpmOrKw: newKw,
        latitude: _telemetry.latitude + latJitter,
        longitude: _telemetry.longitude + lngJitter,
      );
      notifyListeners();
    });
  }

  void stopTracking() {
    _ticker?.cancel();
    _ticker = null;
  }

  void toggleDoors() {
    _telemetry = _telemetry.copyWith(isDoorsLocked: !_telemetry.isDoorsLocked);
    notifyListeners();
  }

  void toggleLights() {
    _telemetry = _telemetry.copyWith(areLightsOn: !_telemetry.areLightsOn);
    notifyListeners();
  }

  void switchCamera(String angle) {
    _telemetry = _telemetry.copyWith(cameraAngle: angle);
    notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
