import '../entities/vehicle.dart';

/// Deterministic sample availability for the 7-day demo strip.
///
/// Unavailable vehicles are never available; the others miss roughly one day
/// in five, derived from the vehicle id so the output is stable.
bool isDemoDayAvailable(Vehicle vehicle, int dayOffset) {
  if (!vehicle.isAvailable) return false;
  final seed = vehicle.id.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
  return (seed + dayOffset * 3) % 5 != 0;
}
