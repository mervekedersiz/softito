class WaterRecordModel {
  final int currentIntakeMl;
  final int dailyGoalMl;
  final int glassCount;
  final DateTime lastUpdated;

  const WaterRecordModel({
    required this.currentIntakeMl,
    required this.dailyGoalMl,
    required this.glassCount,
    required this.lastUpdated,
  });

  double get progressRatio =>
      dailyGoalMl > 0 ? (currentIntakeMl / dailyGoalMl).clamp(0.0, 1.0) : 0.0;

  int get remainingMl => (dailyGoalMl - currentIntakeMl).clamp(0, dailyGoalMl);

  WaterRecordModel copyWith({
    int? currentIntakeMl,
    int? dailyGoalMl,
    int? glassCount,
    DateTime? lastUpdated,
  }) {
    return WaterRecordModel(
      currentIntakeMl: currentIntakeMl ?? this.currentIntakeMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      glassCount: glassCount ?? this.glassCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentIntakeMl': currentIntakeMl,
      'dailyGoalMl': dailyGoalMl,
      'glassCount': glassCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory WaterRecordModel.fromJson(Map<String, dynamic> json) {
    return WaterRecordModel(
      currentIntakeMl: (json['currentIntakeMl'] as num?)?.toInt() ?? 0,
      dailyGoalMl: (json['dailyGoalMl'] as num?)?.toInt() ?? 2500,
      glassCount: (json['glassCount'] as num?)?.toInt() ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
