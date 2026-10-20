class DonationCenter {
  final String id;
  final String name;
  final String district;
  final String address;
  final String workingHours;
  final List<String> availableSlots;

  const DonationCenter({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.workingHours,
    required this.availableSlots,
  });

  DonationCenter copyWith({
    String? id,
    String? name,
    String? district,
    String? address,
    String? workingHours,
    List<String>? availableSlots,
  }) {
    return DonationCenter(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      availableSlots: availableSlots ?? List.unmodifiable(this.availableSlots),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'district': district,
      'address': address,
      'workingHours': workingHours,
      'availableSlots': availableSlots,
    };
  }

  factory DonationCenter.fromJson(Map<String, dynamic> json) {
    return DonationCenter(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Örnek Bağış Merkezi',
      district: json['district'] as String? ?? '',
      address: json['address'] as String? ?? '',
      workingHours: json['workingHours'] as String? ?? '08:30 - 17:30',
      availableSlots:
          (json['availableSlots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['09:00', '10:30', '13:00', '14:30', '16:00'],
    );
  }
}
