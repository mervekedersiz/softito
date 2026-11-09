import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_status.dart';
import '../../../inventory/domain/entities/food_item.dart';

class DonationEligibilityResult {
  final bool isEligible;
  final String statusTag;
  final List<String> reasons;
  final String? warningMessage;

  const DonationEligibilityResult({
    required this.isEligible,
    required this.statusTag,
    required this.reasons,
    this.warningMessage,
  });
}

class DonationEligibilityChecker {
  DonationEligibilityChecker._();

  static DonationEligibilityResult check(FoodItem item, DateTime now) {
    final reasons = <String>[];
    final urgency = classifyDate(now, item.expiryDate);
    final daysLeft = daysRemaining(now, item.expiryDate);

    // 1. Not consumed or wasted
    if (item.isConsumed || item.isWasted) {
      return const DonationEligibilityResult(
        isEligible: false,
        statusTag: 'Tüketilmiş / İsraf',
        reasons: ['Ürün önceden tüketildi veya israf olarak işaretlendi.'],
      );
    }

    // 2. Package status: MUST BE UNOPENED
    if (item.packageStatus == PackageStatus.opened) {
      return const DonationEligibilityResult(
        isEligible: false,
        statusTag: 'Açılmış Ambalaj',
        reasons: [
          'Gıda güvenliği şartı: Açılmış paketler hijyen ve hijyen riski sebebiyle bağışa kabul edilmez.'
        ],
      );
    }

    // 3. Expiry date check
    if (urgency == UrgencyStatus.expired) {
      return const DonationEligibilityResult(
        isEligible: false,
        statusTag: 'Tarihi Geçmiş',
        reasons: ['Tarihi geçmiş ürünler bağış listesine kesinlikle kabul edilemez.'],
      );
    }

    // 4. Perishable cold-chain checks
    if (item.storageLocation == StorageLocation.fridge ||
        item.storageLocation == StorageLocation.freezer) {
      // Fridge/freezer perishable goods must have at least 2 days shelf life
      if (daysLeft < 2) {
        return DonationEligibilityResult(
          isEligible: false,
          statusTag: 'Kritik Soğuk Zincir',
          reasons: [
            'Soğuk zincir gıdalarında teslimat süresi ve güvenliği için en az 2 gün raf ömrü gereklidir. (${daysLeft <= 0 ? 'Bugün son gün' : '$daysLeft gün kaldı'})'
          ],
        );
      }
    }

    // 5. Quantity check
    if (item.quantity <= 0) {
      return const DonationEligibilityResult(
        isEligible: false,
        statusTag: 'Yetersiz Miktar',
        reasons: ['Ürün miktarı 0 veya negatif olamaz.'],
      );
    }

    // Eligible! Determine specific badge text
    String badge;
    if (item.storageLocation == StorageLocation.pantry) {
      if (daysLeft > 180) {
        badge = '6 Ay Güvende';
      } else if (daysLeft > 30) {
        badge = 'Kapalı Ambalaj';
      } else {
        badge = 'Son $daysLeft Gün';
      }
    } else {
      badge = 'Son $daysLeft Gün';
    }

    reasons.add('Ambalajı açılmamış, soğuk zinciri korunmuş ve son tüketim tarihi uygun.');

    return DonationEligibilityResult(
      isEligible: true,
      statusTag: badge,
      reasons: reasons,
    );
  }
}
