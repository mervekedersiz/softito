class WaterTrackerModel {
  final String id;
  final String title;
  final int value;
  final bool isCompleted;
  final DateTime lastUpdated;

  const WaterTrackerModel({
    required this.id,
    required this.title,
    required this.value,
    required this.isCompleted,
    required this.lastUpdated,
  });

  WaterTrackerModel copyWith({
    String? id,
    String? title,
    int? value,
    bool? isCompleted,
    DateTime? lastUpdated,
  }) {
    return WaterTrackerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'isCompleted': isCompleted,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
