enum BookingStatus { demoPending }

/// A demo rental request. Never a real reservation or payment.
class Booking {
  const Booking({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.pickupLocation,
    required this.returnLocation,
    required this.startAt,
    required this.endAt,
    required this.billableDays,
    required this.estimatedTotal,
    required this.createdAt,
    this.status = BookingStatus.demoPending,
  });

  final String id;
  final String vehicleId;
  final String vehicleName;
  final String pickupLocation;
  final String returnLocation;
  final DateTime startAt;
  final DateTime endAt;
  final int billableDays;
  final int estimatedTotal;
  final BookingStatus status;
  final DateTime createdAt;

  Duration get duration => endAt.difference(startAt);
}
