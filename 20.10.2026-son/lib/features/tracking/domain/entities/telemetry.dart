class VehicleTelemetry {
  const VehicleTelemetry({
    required this.vehicleId,
    required this.vehicleName,
    required this.speedKmH,
    required this.rpmOrKw,
    required this.fuelOrBatteryPercent,
    required this.latitude,
    required this.longitude,
    required this.altitudeMeters,
    required this.isDoorsLocked,
    required this.areLightsOn,
    required this.isEngineRunning,
    this.streamFps = 60,
    this.cameraAngle = 'Ön Kokpit',
  });

  final String vehicleId;
  final String vehicleName;
  final int speedKmH;
  final int rpmOrKw; // kW for electric, RPM for combustion
  final int fuelOrBatteryPercent;
  final double latitude;
  final double longitude;
  final int altitudeMeters;
  final bool isDoorsLocked;
  final bool areLightsOn;
  final bool isEngineRunning;
  final int streamFps;
  final String cameraAngle;

  VehicleTelemetry copyWith({
    int? speedKmH,
    int? rpmOrKw,
    int? fuelOrBatteryPercent,
    double? latitude,
    double? longitude,
    bool? isDoorsLocked,
    bool? areLightsOn,
    bool? isEngineRunning,
    String? cameraAngle,
  }) {
    return VehicleTelemetry(
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      speedKmH: speedKmH ?? this.speedKmH,
      rpmOrKw: rpmOrKw ?? this.rpmOrKw,
      fuelOrBatteryPercent: fuelOrBatteryPercent ?? this.fuelOrBatteryPercent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeMeters: altitudeMeters,
      isDoorsLocked: isDoorsLocked ?? this.isDoorsLocked,
      areLightsOn: areLightsOn ?? this.areLightsOn,
      isEngineRunning: isEngineRunning ?? this.isEngineRunning,
      streamFps: streamFps,
      cameraAngle: cameraAngle ?? this.cameraAngle,
    );
  }
}
