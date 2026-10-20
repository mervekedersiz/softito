enum DonationStatus {
  planned('Planlandı'),
  completed('Tamamlandı (Demo)'),
  cancelled('İptal Edildi');

  final String label;
  const DonationStatus(this.label);

  static DonationStatus fromString(String? val) {
    if (val == null) return DonationStatus.planned;
    return DonationStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => DonationStatus.planned,
    );
  }
}

enum DonationSource {
  general('Genel Bağış'),
  specificRequest('Belirli Talep'),
  patientRef('Hasta Adına');

  final String label;
  const DonationSource(this.label);

  static DonationSource fromString(String? val) {
    if (val == null) return DonationSource.general;
    return DonationSource.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => DonationSource.general,
    );
  }
}

enum TrackingStage {
  donated('Bağış Alındı', 'Kan bağış merkezinde başarıyla alındı.'),
  tested(
    'Test ve Kontrol Süreci',
    'Laboratuvar taramaları ve bileşen ayrıştırması yapıldı.',
  ),
  ready('Dağıtıma Hazır', 'Ulusal kan stok havuzunda dağıtım emri verildi.'),
  delivered(
    'İlgili Merkeze İletildi',
    'Transfüzyon merkezine güvenli zincirle teslim edildi.',
  );

  final String title;
  final String description;
  const TrackingStage(this.title, this.description);

  static TrackingStage fromString(String? val) {
    if (val == null) return TrackingStage.donated;
    return TrackingStage.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => TrackingStage.donated,
    );
  }
}

class TrackingEvent {
  final TrackingStage stage;
  final DateTime timestamp;
  final String note;

  const TrackingEvent({
    required this.stage,
    required this.timestamp,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'stage': stage.name,
    'timestamp': timestamp.toIso8601String(),
    'note': note,
  };

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      stage: TrackingStage.fromString(json['stage'] as String?),
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      note: json['note'] as String? ?? '',
    );
  }
}

class DonationRecord {
  final String id;
  final String centerId;
  final String? requestId;
  final String? recipientReference;
  final DateTime scheduledAt;
  final DateTime? completedAt;
  final DonationStatus status;
  final DonationSource source;
  final List<TrackingEvent> trackingEvents;

  const DonationRecord({
    required this.id,
    required this.centerId,
    this.requestId,
    this.recipientReference,
    required this.scheduledAt,
    this.completedAt,
    required this.status,
    required this.source,
    this.trackingEvents = const [],
  });

  bool get isCompleted => status == DonationStatus.completed;
  bool get isPlanned => status == DonationStatus.planned;
  bool get isCancelled => status == DonationStatus.cancelled;

  DonationRecord copyWith({
    String? id,
    String? centerId,
    String? requestId,
    bool clearRequestId = false,
    String? recipientReference,
    bool clearRecipientReference = false,
    DateTime? scheduledAt,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DonationStatus? status,
    DonationSource? source,
    List<TrackingEvent>? trackingEvents,
  }) {
    return DonationRecord(
      id: id ?? this.id,
      centerId: centerId ?? this.centerId,
      requestId: clearRequestId ? null : (requestId ?? this.requestId),
      recipientReference: clearRecipientReference
          ? null
          : (recipientReference ?? this.recipientReference),
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      status: status ?? this.status,
      source: source ?? this.source,
      trackingEvents: trackingEvents ?? List.unmodifiable(this.trackingEvents),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'centerId': centerId,
      'requestId': requestId,
      'recipientReference': recipientReference,
      'scheduledAt': scheduledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.name,
      'source': source.name,
      'trackingEvents': trackingEvents.map((e) => e.toJson()).toList(),
    };
  }

  factory DonationRecord.fromJson(Map<String, dynamic> json) {
    return DonationRecord(
      id: json['id'] as String,
      centerId: json['centerId'] as String? ?? '',
      requestId: json['requestId'] as String?,
      recipientReference: json['recipientReference'] as String?,
      scheduledAt:
          DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
          DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
      status: DonationStatus.fromString(json['status'] as String?),
      source: DonationSource.fromString(json['source'] as String?),
      trackingEvents:
          (json['trackingEvents'] as List<dynamic>?)
              ?.map((e) => TrackingEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
