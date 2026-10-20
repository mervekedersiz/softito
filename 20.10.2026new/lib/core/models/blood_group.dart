/// Blood group representation adhering to the project specification:
/// Uses 'O' in internal code / data representations and '0' in display labels.
enum BloodGroup {
  oPositive('O+', '0+', '0', true),
  oNegative('O-', '0-', '0', false),
  aPositive('A+', 'A+', 'A', true),
  aNegative('A-', 'A-', 'A', false),
  bPositive('B+', 'B+', 'B', true),
  bNegative('B-', 'B-', 'B', false),
  abPositive('AB+', 'AB+', 'AB', true),
  abNegative('AB-', 'AB-', 'AB', false),
  unknown('UNKNOWN', 'Bilmiyorum', 'Bilinmiyor', null);

  /// Internal standard data code (e.g. 'O+', 'A-', 'UNKNOWN')
  final String code;

  /// Turkish user-facing label (e.g. '0+', 'A-', 'Bilmiyorum')
  final String label;

  /// Base ABO system group
  final String baseGroup;

  /// Rh factor (true = positive, false = negative, null = unknown)
  final bool? isPositive;

  const BloodGroup(this.code, this.label, this.baseGroup, this.isPositive);

  String get rhLabel {
    if (isPositive == true) return 'Rh Pozitif (+)';
    if (isPositive == false) return 'Rh Negatif (−)';
    return 'Bilinmiyor';
  }

  String get description {
    if (this == unknown) return 'Kan grubu henüz belirlenmemiş';
    return '$baseGroup grubu $rhLabel';
  }

  /// Parse from string safely (handles both '0+' and 'O+', case-insensitive)
  static BloodGroup fromString(String? value) {
    if (value == null) return BloodGroup.unknown;
    final normalized = value.trim().toUpperCase().replaceAll('0', 'O');
    for (final group in BloodGroup.values) {
      if (group.code == normalized) return group;
    }
    // Also check display labels
    for (final group in BloodGroup.values) {
      if (group.label.toUpperCase() == value.trim().toUpperCase()) return group;
    }
    return BloodGroup.unknown;
  }

  String toJson() => code;

  static BloodGroup fromJson(dynamic json) {
    if (json is String) return fromString(json);
    return BloodGroup.unknown;
  }
}
