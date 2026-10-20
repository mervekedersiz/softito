import 'blood_group.dart';

enum RequestUrgency {
  normal('Normal'),
  high('Yüksek'),
  emergency('Acil');

  final String label;
  const RequestUrgency(this.label);

  static RequestUrgency fromString(String? val) {
    if (val == null) return RequestUrgency.normal;
    return RequestUrgency.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => RequestUrgency.normal,
    );
  }
}

enum RequestStatus {
  active('Aktif'),
  fulfilled('Karşılandı'),
  expired('Süresi Doldu');

  final String label;
  const RequestStatus(this.label);

  static RequestStatus fromString(String? val) {
    if (val == null) return RequestStatus.active;
    return RequestStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => RequestStatus.active,
    );
  }
}

class BloodRequest {
  final String id;
  final String recipientAlias;
  final BloodGroup bloodGroup;
  final String centerId;
  final String district;
  final int requiredUnits;
  final DateTime expiresAt;
  final RequestUrgency urgency;
  final RequestStatus status;
  final double demoDistanceKm;

  const BloodRequest({
    required this.id,
    required this.recipientAlias,
    required this.bloodGroup,
    required this.centerId,
    required this.district,
    required this.requiredUnits,
    required this.expiresAt,
    required this.urgency,
    required this.status,
    required this.demoDistanceKm,
  });

  bool get isExpired =>
      DateTime.now().isAfter(expiresAt) || status == RequestStatus.expired;
  bool get canAcceptDonation => status == RequestStatus.active && !isExpired;

  BloodRequest copyWith({
    String? id,
    String? recipientAlias,
    BloodGroup? bloodGroup,
    String? centerId,
    String? district,
    int? requiredUnits,
    DateTime? expiresAt,
    RequestUrgency? urgency,
    RequestStatus? status,
    double? demoDistanceKm,
  }) {
    return BloodRequest(
      id: id ?? this.id,
      recipientAlias: recipientAlias ?? this.recipientAlias,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      centerId: centerId ?? this.centerId,
      district: district ?? this.district,
      requiredUnits: requiredUnits ?? this.requiredUnits,
      expiresAt: expiresAt ?? this.expiresAt,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
      demoDistanceKm: demoDistanceKm ?? this.demoDistanceKm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientAlias': recipientAlias,
      'bloodGroup': bloodGroup.toJson(),
      'centerId': centerId,
      'district': district,
      'requiredUnits': requiredUnits,
      'expiresAt': expiresAt.toIso8601String(),
      'urgency': urgency.name,
      'status': status.name,
      'demoDistanceKm': demoDistanceKm,
    };
  }

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    return BloodRequest(
      id: json['id'] as String,
      recipientAlias: json['recipientAlias'] as String? ?? 'Kurgusal Alıcı',
      bloodGroup: BloodGroup.fromJson(json['bloodGroup']),
      centerId: json['centerId'] as String? ?? '',
      district: json['district'] as String? ?? '',
      requiredUnits: (json['requiredUnits'] as num?)?.toInt() ?? 1,
      expiresAt:
          DateTime.tryParse(json['expiresAt'] as String? ?? '') ??
          DateTime.now().add(const Duration(days: 3)),
      urgency: RequestUrgency.fromString(json['urgency'] as String?),
      status: RequestStatus.fromString(json['status'] as String?),
      demoDistanceKm: (json['demoDistanceKm'] as num?)?.toDouble() ?? 3.5,
    );
  }
}
