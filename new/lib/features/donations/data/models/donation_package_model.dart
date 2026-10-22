import '../../../../core/models/enums.dart';
import '../../domain/entities/donation_package.dart';

class DonationPackageModel {
  static Map<String, dynamic> toJson(DonationPackage package) {
    return {
      'id': package.id,
      'title': package.title,
      'description': package.description,
      'itemIds': package.itemIds,
      'targetCenterId': package.targetCenterId,
      'targetCenterName': package.targetCenterName,
      'status': package.status.name,
      'createdAt': package.createdAt.toIso8601String(),
      'updatedAt': package.updatedAt.toIso8601String(),
      'completedAt': package.completedAt?.toIso8601String(),
      'notes': package.notes,
    };
  }

  static DonationPackage fromJson(Map<String, dynamic> json) {
    return DonationPackage(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      itemIds: (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
      targetCenterId: json['targetCenterId'] as String?,
      targetCenterName: json['targetCenterName'] as String?,
      status: DonationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DonationStatus.draft,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }
}
