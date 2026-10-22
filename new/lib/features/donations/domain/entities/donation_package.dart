import '../../../../core/models/enums.dart';

class DonationPackage {
  final String id;
  final String title;
  final String description;
  final List<String> itemIds;
  final String? targetCenterId;
  final String? targetCenterName;
  final DonationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final String? notes;

  const DonationPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.itemIds,
    this.targetCenterId,
    this.targetCenterName,
    this.status = DonationStatus.draft,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.notes,
  });

  DonationPackage copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? itemIds,
    String? targetCenterId,
    String? targetCenterName,
    DonationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? notes,
  }) {
    return DonationPackage(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      itemIds: itemIds ?? this.itemIds,
      targetCenterId: targetCenterId ?? this.targetCenterId,
      targetCenterName: targetCenterName ?? this.targetCenterName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }
}
