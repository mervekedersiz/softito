class DonorBadge {
  final String id;
  final String title;
  final String description;
  final String criteria;
  final DateTime? earnedAt;
  final String iconCode;

  const DonorBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.criteria,
    this.earnedAt,
    this.iconCode = 'favorite',
  });

  bool get isEarned => earnedAt != null;

  DonorBadge copyWith({
    String? id,
    String? title,
    String? description,
    String? criteria,
    DateTime? earnedAt,
    bool clearEarnedAt = false,
    String? iconCode,
  }) {
    return DonorBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      criteria: criteria ?? this.criteria,
      earnedAt: clearEarnedAt ? null : (earnedAt ?? this.earnedAt),
      iconCode: iconCode ?? this.iconCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'criteria': criteria,
      'earnedAt': earnedAt?.toIso8601String(),
      'iconCode': iconCode,
    };
  }

  factory DonorBadge.fromJson(Map<String, dynamic> json) {
    return DonorBadge(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      criteria: json['criteria'] as String? ?? '',
      earnedAt: json['earnedAt'] != null
          ? DateTime.tryParse(json['earnedAt'] as String)
          : null,
      iconCode: json['iconCode'] as String? ?? 'favorite',
    );
  }
}
