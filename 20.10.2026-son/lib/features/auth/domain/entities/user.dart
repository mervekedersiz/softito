/// Permissions in the application for role-based access control.
enum AppPermission {
  viewFleet,
  bookVehicle,
  useNfcPass,
  viewLiveTelemetry,
  manageFleet,
  managePricing,
  accessAdminPanel;

  String get label {
    switch (this) {
      case AppPermission.viewFleet:
        return 'Filoyu Görüntüleme';
      case AppPermission.bookVehicle:
        return 'Rezervasyon Oluşturma';
      case AppPermission.useNfcPass:
        return 'NFC Temassız Sürüş';
      case AppPermission.viewLiveTelemetry:
        return 'Canlı Telemetri & Takip';
      case AppPermission.manageFleet:
        return 'Filo Araç Yönetimi (Admin)';
      case AppPermission.managePricing:
        return 'Fiyat & Kur Yönetimi (Admin)';
      case AppPermission.accessAdminPanel:
        return 'Admin Yönetim Paneli';
    }
  }
}

/// User roles defining system capabilities.
enum UserRole {
  customer('Müşteri', 'Standart kiralama ve arama', [
    AppPermission.viewFleet,
    AppPermission.bookVehicle,
  ]),
  driver('Onaylı Sürücü', 'NFC hızlı geçiş ve canlı takip yetkisi', [
    AppPermission.viewFleet,
    AppPermission.bookVehicle,
    AppPermission.useNfcPass,
    AppPermission.viewLiveTelemetry,
  ]),
  admin('Sistem Yöneticisi (Admin)', 'Tam yetkili filo, kur ve kullanıcı yönetimi', [
    AppPermission.viewFleet,
    AppPermission.bookVehicle,
    AppPermission.useNfcPass,
    AppPermission.viewLiveTelemetry,
    AppPermission.manageFleet,
    AppPermission.managePricing,
    AppPermission.accessAdminPanel,
  ]);

  const UserRole(this.title, this.description, this.defaultPermissions);

  final String title;
  final String description;
  final List<AppPermission> defaultPermissions;
}

/// User entity with permissions, wallet balance, and NFC identifier.
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.driverLicenseVerified = true,
    this.nfcCardId = 'YOL-PASS-7842',
    this.walletBalanceTry = 4500.0,
    this.permissions = const [],
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool driverLicenseVerified;
  final String nfcCardId;
  final double walletBalanceTry;
  final List<AppPermission> permissions;

  bool hasPermission(AppPermission permission) =>
      permissions.contains(permission) || role.defaultPermissions.contains(permission);

  bool get isAdmin => role == UserRole.admin;

  User copyWith({
    String? name,
    UserRole? role,
    double? walletBalanceTry,
    List<AppPermission>? permissions,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role ?? this.role,
      driverLicenseVerified: driverLicenseVerified,
      nfcCardId: nfcCardId,
      walletBalanceTry: walletBalanceTry ?? this.walletBalanceTry,
      permissions: permissions ?? this.permissions,
    );
  }
}
