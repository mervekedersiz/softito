import '../models/blood_group.dart';
import '../models/donor_profile.dart';
import '../models/blood_request.dart';
import '../models/donation_center.dart';
import '../models/donation_record.dart';
import '../models/blood_measurement.dart';
import '../models/donor_badge.dart';

abstract class DemoSeed {
  static DonorProfile createInitialProfile() {
    return const DonorProfile(
      id: 'donor_demo_1',
      displayName: 'Ahmet Yılmaz (Örnek)',
      bloodGroup: BloodGroup.aPositive,
      district: 'Kadıköy',
    );
  }

  static List<DonationCenter> createInitialCenters() {
    return const [
      DonationCenter(
        id: 'center_1',
        name: 'Örnek Bağış Merkezi — Kadıköy',
        district: 'Kadıköy',
        address: 'Rıhtım Cad. No: 12, Kadıköy / İstanbul',
        workingHours: 'Hafta içi 08:30 - 18:00, Hafta sonu 09:30 - 16:30',
        availableSlots: ['09:00', '10:30', '11:45', '14:00', '15:30', '17:00'],
      ),
      DonationCenter(
        id: 'center_2',
        name: 'Örnek Bağış Merkezi — Bahçelievler',
        district: 'Bahçelievler',
        address: 'Şirinevler Meydan No: 4, Bahçelievler / İstanbul',
        workingHours: 'Haftanın her günü 09:00 - 19:00',
        availableSlots: ['09:30', '11:00', '13:30', '15:00', '16:30', '18:00'],
      ),
      DonationCenter(
        id: 'center_3',
        name: 'Örnek Bağış Merkezi — Şişli',
        district: 'Şişli',
        address: 'Büyükdere Cad. No: 88, Şişli / İstanbul',
        workingHours: 'Hafta içi 08:00 - 17:30',
        availableSlots: ['08:30', '10:00', '12:00', '14:30', '16:00'],
      ),
      DonationCenter(
        id: 'center_4',
        name: 'Örnek Bağış Noktası — Üsküdar',
        district: 'Üsküdar',
        address: 'Hakimiyeti Milliye Cad. No: 23, Üsküdar / İstanbul',
        workingHours: 'Salı - Pazar 09:00 - 17:00',
        availableSlots: ['09:15', '11:00', '13:00', '14:45', '16:15'],
      ),
      DonationCenter(
        id: 'center_5',
        name: 'Örnek Bağış Merkezi — Kartal',
        district: 'Kartal',
        address: 'Kızılay Cad. No: 5, Kartal / İstanbul',
        workingHours: 'Hafta içi 09:00 - 17:30',
        availableSlots: ['09:30', '11:15', '14:00', '15:30'],
      ),
      DonationCenter(
        id: 'center_6',
        name: 'Örnek Bağış Merkezi — Beşiktaş',
        district: 'Beşiktaş',
        address: 'Çırağan Cad. No: 34, Beşiktaş / İstanbul',
        workingHours: 'Haftanın her günü 08:30 - 18:30',
        availableSlots: ['09:00', '10:30', '12:30', '14:00', '16:00', '17:30'],
      ),
    ];
  }

  static List<BloodRequest> createInitialRequests([DateTime? baseTime]) {
    final now = baseTime ?? DateTime.now();
    return [
      BloodRequest(
        id: 'req_1',
        recipientAlias: 'Kurgusal Hasta A.K.',
        bloodGroup: BloodGroup.aPositive,
        centerId: 'center_1',
        district: 'Kadıköy',
        requiredUnits: 2,
        expiresAt: now.add(const Duration(days: 2)),
        urgency: RequestUrgency.emergency,
        status: RequestStatus.active,
        demoDistanceKm: 1.8,
      ),
      BloodRequest(
        id: 'req_2',
        recipientAlias: 'Kurgusal Hasta M.E.',
        bloodGroup: BloodGroup.oPositive,
        centerId: 'center_2',
        district: 'Bahçelievler',
        requiredUnits: 3,
        expiresAt: now.add(const Duration(days: 4)),
        urgency: RequestUrgency.high,
        status: RequestStatus.active,
        demoDistanceKm: 8.5,
      ),
      BloodRequest(
        id: 'req_3',
        recipientAlias: 'Kurgusal Hasta Z.T.',
        bloodGroup: BloodGroup.oNegative,
        centerId: 'center_3',
        district: 'Şişli',
        requiredUnits: 1,
        expiresAt: now.add(const Duration(hours: 18)),
        urgency: RequestUrgency.emergency,
        status: RequestStatus.active,
        demoDistanceKm: 4.2,
      ),
      BloodRequest(
        id: 'req_4',
        recipientAlias: 'Kurgusal Hasta C.S.',
        bloodGroup: BloodGroup.bPositive,
        centerId: 'center_4',
        district: 'Üsküdar',
        requiredUnits: 2,
        expiresAt: now.add(const Duration(days: 5)),
        urgency: RequestUrgency.normal,
        status: RequestStatus.active,
        demoDistanceKm: 3.1,
      ),
      BloodRequest(
        id: 'req_5',
        recipientAlias: 'Kurgusal Hasta E.B.',
        bloodGroup: BloodGroup.abPositive,
        centerId: 'center_5',
        district: 'Kartal',
        requiredUnits: 1,
        expiresAt: now.add(const Duration(days: 3)),
        urgency: RequestUrgency.normal,
        status: RequestStatus.active,
        demoDistanceKm: 12.0,
      ),
      BloodRequest(
        id: 'req_6',
        recipientAlias: 'Kurgusal Hasta V.D.',
        bloodGroup: BloodGroup.aNegative,
        centerId: 'center_6',
        district: 'Beşiktaş',
        requiredUnits: 2,
        expiresAt: now.add(const Duration(days: 1)),
        urgency: RequestUrgency.high,
        status: RequestStatus.active,
        demoDistanceKm: 5.6,
      ),
      BloodRequest(
        id: 'req_7',
        recipientAlias: 'Kurgusal Hasta T.N.',
        bloodGroup: BloodGroup.bNegative,
        centerId: 'center_1',
        district: 'Kadıköy',
        requiredUnits: 2,
        expiresAt: now.add(const Duration(days: 6)),
        urgency: RequestUrgency.normal,
        status: RequestStatus.active,
        demoDistanceKm: 2.3,
      ),
      BloodRequest(
        id: 'req_8',
        recipientAlias: 'Kurgusal Hasta K.P.',
        bloodGroup: BloodGroup.abNegative,
        centerId: 'center_3',
        district: 'Şişli',
        requiredUnits: 1,
        expiresAt: now.add(const Duration(days: 3)),
        urgency: RequestUrgency.high,
        status: RequestStatus.active,
        demoDistanceKm: 4.9,
      ),
      // Fulfilled request
      BloodRequest(
        id: 'req_9',
        recipientAlias: 'Kurgusal Hasta O.L.',
        bloodGroup: BloodGroup.aPositive,
        centerId: 'center_2',
        district: 'Bahçelievler',
        requiredUnits: 2,
        expiresAt: now.add(const Duration(days: 2)),
        urgency: RequestUrgency.normal,
        status: RequestStatus.fulfilled,
        demoDistanceKm: 9.1,
      ),
      // Expired request
      BloodRequest(
        id: 'req_10',
        recipientAlias: 'Kurgusal Hasta R.Y.',
        bloodGroup: BloodGroup.oPositive,
        centerId: 'center_4',
        district: 'Üsküdar',
        requiredUnits: 1,
        expiresAt: now.subtract(const Duration(days: 2)),
        urgency: RequestUrgency.emergency,
        status: RequestStatus.expired,
        demoDistanceKm: 3.8,
      ),
    ];
  }

  static List<DonationRecord> createInitialDonations([DateTime? baseTime]) {
    final now = baseTime ?? DateTime.now();
    return [
      // 1 upcoming planned appointment
      DonationRecord(
        id: 'donation_upcoming_1',
        centerId: 'center_1',
        scheduledAt: now.add(const Duration(days: 3, hours: 2)),
        status: DonationStatus.planned,
        source: DonationSource.general,
        trackingEvents: [],
      ),
      // 4 completed donations spread over past 6 months
      DonationRecord(
        id: 'donation_comp_1',
        centerId: 'center_1',
        scheduledAt: now.subtract(const Duration(days: 150)),
        completedAt: now.subtract(const Duration(days: 150)),
        status: DonationStatus.completed,
        source: DonationSource.general,
        trackingEvents: [
          TrackingEvent(
            stage: TrackingStage.donated,
            timestamp: now.subtract(const Duration(days: 150)),
            note: 'Kadıköy merkezinde bağış kabul edildi.',
          ),
          TrackingEvent(
            stage: TrackingStage.tested,
            timestamp: now.subtract(const Duration(days: 149)),
            note: 'Laboratuvar analizleri başarıyla onaylandı.',
          ),
          TrackingEvent(
            stage: TrackingStage.ready,
            timestamp: now.subtract(const Duration(days: 148)),
            note: 'Kan bileşenleri stok havuzuna aktarıldı.',
          ),
          TrackingEvent(
            stage: TrackingStage.delivered,
            timestamp: now.subtract(const Duration(days: 147)),
            note: 'Bölge transfüzyon merkezine iletildi.',
          ),
        ],
      ),
      DonationRecord(
        id: 'donation_comp_2',
        centerId: 'center_3',
        scheduledAt: now.subtract(const Duration(days: 105)),
        completedAt: now.subtract(const Duration(days: 105)),
        status: DonationStatus.completed,
        source: DonationSource.general,
        trackingEvents: [
          TrackingEvent(
            stage: TrackingStage.donated,
            timestamp: now.subtract(const Duration(days: 105)),
            note: 'Şişli merkezinde tam kan bağışı yapıldı.',
          ),
          TrackingEvent(
            stage: TrackingStage.tested,
            timestamp: now.subtract(const Duration(days: 104)),
            note: 'Seroloji ve kan grubu testleri tamamlandı.',
          ),
          TrackingEvent(
            stage: TrackingStage.ready,
            timestamp: now.subtract(const Duration(days: 103)),
            note: 'Soğuk zincir transferine hazırlandı.',
          ),
          TrackingEvent(
            stage: TrackingStage.delivered,
            timestamp: now.subtract(const Duration(days: 102)),
            note: 'Acil stok ihtiyacı için hastaneye iletildi.',
          ),
        ],
      ),
      DonationRecord(
        id: 'donation_comp_3',
        centerId: 'center_6',
        scheduledAt: now.subtract(const Duration(days: 60)),
        completedAt: now.subtract(const Duration(days: 60)),
        status: DonationStatus.completed,
        source: DonationSource.general,
        trackingEvents: [
          TrackingEvent(
            stage: TrackingStage.donated,
            timestamp: now.subtract(const Duration(days: 60)),
            note: 'Beşiktaş merkezinde bağış alındı.',
          ),
          TrackingEvent(
            stage: TrackingStage.tested,
            timestamp: now.subtract(const Duration(days: 59)),
            note: 'Bileşen ayrıştırma (eritrosit/trombosit) tamamlandı.',
          ),
          TrackingEvent(
            stage: TrackingStage.ready,
            timestamp: now.subtract(const Duration(days: 58)),
            note: 'Dağıtım onaylandı.',
          ),
          TrackingEvent(
            stage: TrackingStage.delivered,
            timestamp: now.subtract(const Duration(days: 57)),
            note: 'İlgili kliniğe teslim edildi.',
          ),
        ],
      ),
      DonationRecord(
        id: 'donation_comp_4',
        centerId: 'center_4',
        scheduledAt: now.subtract(const Duration(days: 15)),
        completedAt: now.subtract(const Duration(days: 15)),
        status: DonationStatus.completed,
        source: DonationSource.general,
        trackingEvents: [
          TrackingEvent(
            stage: TrackingStage.donated,
            timestamp: now.subtract(const Duration(days: 15)),
            note: 'Üsküdar noktasında bağış işlemi gerçekleşti.',
          ),
          TrackingEvent(
            stage: TrackingStage.tested,
            timestamp: now.subtract(const Duration(days: 14)),
            note: 'Kontrol taramaları sorunsuz tamamlandı.',
          ),
          TrackingEvent(
            stage: TrackingStage.ready,
            timestamp: now.subtract(const Duration(days: 13)),
            note: 'Ulusal kan deposuna giriş yapıldı.',
          ),
          TrackingEvent(
            stage: TrackingStage.delivered,
            timestamp: now.subtract(const Duration(days: 12)),
            note: 'İhtiyaç duyulan merkeze ulaştırıldı.',
          ),
        ],
      ),
    ];
  }

  static List<BloodMeasurement> createInitialMeasurements([
    DateTime? baseTime,
  ]) {
    final now = baseTime ?? DateTime.now();
    return [
      // 4 Hemoglobin measurements
      BloodMeasurement(
        id: 'meas_hb_1',
        type: MeasurementType.hemoglobin,
        value: 13.8,
        unit: 'g/dL',
        measuredAt: now.subtract(const Duration(days: 150)),
        source: 'Örnek Kan Merkezi Laboratuvarı',
        referenceMin: 13.0,
        referenceMax: 17.5,
      ),
      BloodMeasurement(
        id: 'meas_hb_2',
        type: MeasurementType.hemoglobin,
        value: 14.2,
        unit: 'g/dL',
        measuredAt: now.subtract(const Duration(days: 105)),
        source: 'Devlet Hastanesi Rutin Tahlili',
        referenceMin: 13.0,
        referenceMax: 17.5,
      ),
      BloodMeasurement(
        id: 'meas_hb_3',
        type: MeasurementType.hemoglobin,
        value: 14.0,
        unit: 'g/dL',
        measuredAt: now.subtract(const Duration(days: 60)),
        source: 'Örnek Kan Merkezi Laboratuvarı',
        referenceMin: 13.0,
        referenceMax: 17.5,
      ),
      BloodMeasurement(
        id: 'meas_hb_4',
        type: MeasurementType.hemoglobin,
        value: 14.5,
        unit: 'g/dL',
        measuredAt: now.subtract(const Duration(days: 15)),
        source: 'Aile Sağlığı Merkezi',
        referenceMin: 13.0,
        referenceMax: 17.5,
      ),

      // 4 Hematocrit measurements
      BloodMeasurement(
        id: 'meas_hct_1',
        type: MeasurementType.hematocrit,
        value: 41.5,
        unit: '%',
        measuredAt: now.subtract(const Duration(days: 150)),
        source: 'Örnek Kan Merkezi Laboratuvarı',
        referenceMin: 39.0,
        referenceMax: 50.0,
      ),
      BloodMeasurement(
        id: 'meas_hct_2',
        type: MeasurementType.hematocrit,
        value: 42.8,
        unit: '%',
        measuredAt: now.subtract(const Duration(days: 105)),
        source: 'Devlet Hastanesi Rutin Tahlili',
        referenceMin: 39.0,
        referenceMax: 50.0,
      ),
      BloodMeasurement(
        id: 'meas_hct_3',
        type: MeasurementType.hematocrit,
        value: 42.0,
        unit: '%',
        measuredAt: now.subtract(const Duration(days: 60)),
        source: 'Örnek Kan Merkezi Laboratuvarı',
        referenceMin: 39.0,
        referenceMax: 50.0,
      ),
      BloodMeasurement(
        id: 'meas_hct_4',
        type: MeasurementType.hematocrit,
        value: 43.6,
        unit: '%',
        measuredAt: now.subtract(const Duration(days: 15)),
        source: 'Aile Sağlığı Merkezi',
        referenceMin: 39.0,
        referenceMax: 50.0,
      ),

      // 4 Ferritin measurements
      BloodMeasurement(
        id: 'meas_fer_1',
        type: MeasurementType.ferritin,
        value: 58.0,
        unit: 'ng/mL',
        measuredAt: now.subtract(const Duration(days: 150)),
        source: 'Devlet Hastanesi Tahlili',
        referenceMin: 30.0,
        referenceMax: 300.0,
      ),
      BloodMeasurement(
        id: 'meas_fer_2',
        type: MeasurementType.ferritin,
        value: 64.0,
        unit: 'ng/mL',
        measuredAt: now.subtract(const Duration(days: 105)),
        source: 'Örnek Check-up Raporu',
        referenceMin: 30.0,
        referenceMax: 300.0,
      ),
      BloodMeasurement(
        id: 'meas_fer_3',
        type: MeasurementType.ferritin,
        value: 61.5,
        unit: 'ng/mL',
        measuredAt: now.subtract(const Duration(days: 60)),
        source: 'Aile Sağlığı Merkezi',
        referenceMin: 30.0,
        referenceMax: 300.0,
      ),
      BloodMeasurement(
        id: 'meas_fer_4',
        type: MeasurementType.ferritin,
        value: 70.0,
        unit: 'ng/mL',
        measuredAt: now.subtract(const Duration(days: 15)),
        source: 'Örnek Check-up Raporu',
        referenceMin: 30.0,
        referenceMax: 300.0,
      ),
    ];
  }

  static List<DonorBadge> createInitialBadges([DateTime? baseTime]) {
    final now = baseTime ?? DateTime.now();
    return [
      DonorBadge(
        id: 'badge_first_step',
        title: 'İlk Adım',
        description: 'İlk demo kan bağışınızı başarıyla tamamladınız.',
        criteria: 'En az 1 tamamlanmış bağış kaydı',
        earnedAt: now.subtract(const Duration(days: 150)),
        iconCode: 'favorite',
      ),
      DonorBadge(
        id: 'badge_awareness',
        title: 'Farkındalık Elçisi',
        description:
            'Kan grupları rehberini ve bağış bilgilendirmesini incelediniz.',
        criteria: 'Bilgilendirme içeriğini okuma veya farkındalık paylaşımı',
        earnedAt: now.subtract(const Duration(days: 60)),
        iconCode: 'share',
      ),
      DonorBadge(
        id: 'badge_regular_donor',
        title: 'Gönüllü Destekçi',
        description:
            'Birden fazla kez kan bağışında bulunarak hayat zincirine güç kattınız.',
        criteria: 'En az 3 tamamlanmış bağış kaydı',
        earnedAt: now.subtract(const Duration(days: 15)),
        iconCode: 'stars',
      ),
    ];
  }
}
