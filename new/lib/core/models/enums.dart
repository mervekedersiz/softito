enum StorageLocation {
  fridge('Buzdolabı'),
  freezer('Dondurucu'),
  pantry('Kiler');

  final String label;
  const StorageLocation(this.label);
}

enum FoodCategory {
  dairy('Süt & Şarküteri'),
  meat('Et & Tavuk'),
  produce('Sebze & Meyve'),
  pantry('Kiler & Bakliyat'),
  other('Diğer');

  final String label;
  const FoodCategory(this.label);
}

enum DateType {
  stt('STT'),
  tett('TETT');

  final String label;
  const DateType(this.label);
}

enum PackageStatus {
  unopened('Kapalı Ambalaj'),
  opened('Açılmış Paket');

  final String label;
  const PackageStatus(this.label);
}

enum UrgencyStatus {
  expired('Tarihi Geçmiş'),
  today('Bugün Son Gün'),
  urgent('1-2 Gün Kaldı'),
  upcoming('3-5 Gün Kaldı'),
  safe('6+ Gün Var');

  final String label;
  const UrgencyStatus(this.label);
}

enum DonationStatus {
  draft('Taslak Paket'),
  reserved('Rezerve Edildi'),
  completedLocally('Bağış Tamamlandı'),
  cancelled('İptal Edildi');

  final String label;
  const DonationStatus(this.label);
}
