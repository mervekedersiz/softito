enum MeasurementType {
  hemoglobin('Hemoglobin', 'g/dL'),
  hematocrit('Hematokrit', '%'),
  ferritin('Ferritin', 'ng/mL');

  final String label;
  final String standardUnit;
  const MeasurementType(this.label, this.standardUnit);

  static MeasurementType fromString(String? val) {
    if (val == null) return MeasurementType.hemoglobin;
    return MeasurementType.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => MeasurementType.hemoglobin,
    );
  }
}

class BloodMeasurement {
  final String id;
  final MeasurementType type;
  final double value;
  final String unit;
  final DateTime measuredAt;
  final String source;
  final double? referenceMin;
  final double? referenceMax;

  const BloodMeasurement({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.measuredAt,
    required this.source,
    this.referenceMin,
    this.referenceMax,
  });

  bool get hasReferenceRange => referenceMin != null && referenceMax != null;

  String get referenceRangeText {
    if (!hasReferenceRange) return 'Raporda belirtilmemiş';
    return '$referenceMin - $referenceMax $unit';
  }

  BloodMeasurement copyWith({
    String? id,
    MeasurementType? type,
    double? value,
    String? unit,
    DateTime? measuredAt,
    String? source,
    double? referenceMin,
    bool clearReferenceMin = false,
    double? referenceMax,
    bool clearReferenceMax = false,
  }) {
    return BloodMeasurement(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      measuredAt: measuredAt ?? this.measuredAt,
      source: source ?? this.source,
      referenceMin: clearReferenceMin
          ? null
          : (referenceMin ?? this.referenceMin),
      referenceMax: clearReferenceMax
          ? null
          : (referenceMax ?? this.referenceMax),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'value': value,
      'unit': unit,
      'measuredAt': measuredAt.toIso8601String(),
      'source': source,
      'referenceMin': referenceMin,
      'referenceMax': referenceMax,
    };
  }

  factory BloodMeasurement.fromJson(Map<String, dynamic> json) {
    return BloodMeasurement(
      id: json['id'] as String,
      type: MeasurementType.fromString(json['type'] as String?),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? 'g/dL',
      measuredAt:
          DateTime.tryParse(json['measuredAt'] as String? ?? '') ??
          DateTime.now(),
      source: json['source'] as String? ?? 'Örnek Laboratuvar',
      referenceMin: (json['referenceMin'] as num?)?.toDouble(),
      referenceMax: (json['referenceMax'] as num?)?.toDouble(),
    );
  }
}
