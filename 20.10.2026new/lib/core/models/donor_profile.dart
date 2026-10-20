import 'blood_group.dart';

class DonorProfile {
  final String id;
  final String displayName;
  final BloodGroup bloodGroup;
  final String district;

  const DonorProfile({
    required this.id,
    required this.displayName,
    this.bloodGroup = BloodGroup.unknown,
    required this.district,
  });

  DonorProfile copyWith({
    String? id,
    String? displayName,
    BloodGroup? bloodGroup,
    String? district,
  }) {
    return DonorProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      district: district ?? this.district,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'bloodGroup': bloodGroup.toJson(),
      'district': district,
    };
  }

  factory DonorProfile.fromJson(Map<String, dynamic> json) {
    return DonorProfile(
      id: json['id'] as String? ?? 'donor_demo_1',
      displayName: json['displayName'] as String? ?? 'Örnek Bağışçı',
      bloodGroup: BloodGroup.fromJson(json['bloodGroup']),
      district: json['district'] as String? ?? 'Kadıköy',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonorProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          bloodGroup == other.bloodGroup &&
          district == other.district;

  @override
  int get hashCode => Object.hash(id, displayName, bloodGroup, district);
}
