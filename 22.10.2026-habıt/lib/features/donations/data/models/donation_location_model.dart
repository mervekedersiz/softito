import '../../domain/entities/donation_location.dart';

class DonationLocationModel {
  static Map<String, dynamic> toJson(DonationLocation location) => {
    'latitude': location.point.latitude,
    'longitude': location.point.longitude,
    'label': location.label,
    'address': location.address,
    'updatedAt': location.updatedAt.toIso8601String(),
  };

  static DonationLocation fromJson(
    DonationLocationKind kind,
    Map<String, dynamic> json,
  ) => DonationLocation(
    kind: kind,
    point: GeoPoint(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    ),
    label: json['label'] as String,
    address: json['address'] as String? ?? '',
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}
