enum DonationLocationKind { destination, pickup }

class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint(this.latitude, this.longitude) {
    if (!latitude.isFinite ||
        !longitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      throw const FormatException('Geçerli bir enlem ve boylam girin.');
    }
  }

  String get coordinates =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
}

class DonationLocation {
  final DonationLocationKind kind;
  final GeoPoint point;
  final String label;
  final String address;
  final DateTime updatedAt;

  DonationLocation({
    required this.kind,
    required this.point,
    required String label,
    required String address,
    required this.updatedAt,
  }) : label = label.trim(),
       address = address.trim() {
    if (this.label.isEmpty || this.label.length > 100) {
      throw const FormatException('Konum adı 1–100 karakter olmalı.');
    }
    if (this.address.length > 500) {
      throw const FormatException(
        'Adres açıklaması en fazla 500 karakter olabilir.',
      );
    }
  }
}
