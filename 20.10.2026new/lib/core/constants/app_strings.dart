/// Centralized Turkish UI strings for Kan Bağı application.
abstract class AppStrings {
  static const String appName = 'Kan Bağı';
  static const String appTagline = 'Her Damla Bir Umut, Her Bağış Bir Hayat';
  static const String demoDataNotice = 'Örnek veri';
  static const String demoNoticeLong =
      'Bu uygulama ders prototipidir; veriler kurgusaldır ve gerçek tıbbi değerlendirme yerine geçmez.';

  // Navigation tabs
  static const String navHome = 'Ana Sayfa';
  static const String navRequests = 'İhtiyaçlar';
  static const String navCenters = 'Bağış Noktaları';
  static const String navHistory = 'Geçmişim';
  static const String navProfile = 'Profilim';

  // Dashboard
  static const String welcomeBack = 'Hoş Geldiniz';
  static const String nextAppointment = 'Sıradaki Randevunuz';
  static const String noUpcomingAppointment =
      'Yaklaşan bir randevunuz bulunmuyor.';
  static const String quickActions = 'Hızlı İşlemler';
  static const String bookDonation = 'Bağış Planla';
  static const String preScreeningForm = 'Ön Bilgi Formu';
  static const String myBloodValues = 'Kan Değerlerim';
  static const String bloodGroupsGuide = 'Kan Grupları';
  static const String monthlyDonationSummary = 'Aylık Bağış Grafiği';
  static const String urgentNeedsNearYou = 'Yakındaki İhtiyaç Özeti';
  static const String viewAllNeeds = 'Tümünü Gör';
  static const String lastEarnedBadge = 'Son Kazanılan Rozet';

  // Blood Animation
  static const String simulationTitle = 'Kan Akış Simülasyonu';
  static const String simulationSubtitle =
      'Hortumdan torbaya kan akışı canlandırması';
  static const String simulationStart = 'Simülasyonu Başlat';
  static const String simulationPause = 'Duraklat';
  static const String simulationResume = 'Devam Et';
  static const String simulationReset = 'Sıfırla';
  static const String simulationCompleted = 'Dolum Tamamlandı';
  static const String simulationRunning = 'Akış devam ediyor...';
  static const String simulationPaused = 'Duraklatıldı';
  static const String simulationIdle = 'Başlamaya hazır';
  static const String simulationNotice =
      'Not: Bu animasyon ders sunumu için görsel bir simülasyondur. Gerçek bağış süresi ve medikal hacim ölçümü içermez.';

  // Blood Groups
  static const String bloodGroupsTitle = 'Kan Grupları ve Uyumluluk';
  static const String bloodGroupUnknown = 'Bilmiyorum';
  static const String rhFactor = 'Rh Faktörü';
  static const String rhPositive = 'Rh Pozitif (+)';
  static const String rhNegative = 'Rh Negatif (−)';
  static const String selectBloodGroup = 'Kan Grubunuzu Seçin';
  static const String bloodGroupUpdated = 'Kan grubu tercihiniz güncellendi.';
  static const String bloodGroupCompatibilityNotice =
      'Bilgilendirme: Kan grubu uyumluluğu bileşene (eritrosit, plazma, trombosit) göre farklılık gösterebilir. Transfüzyon kararı uzman sağlık personeli tarafından verilir.';

  // Blood Values
  static const String bloodValuesTitle = 'Kan Değerlerim';
  static const String bloodValuesSubtitle =
      'Kişisel tahlil geçmişi ve eğilim grafiği';
  static const String addMeasurement = 'Yeni Ölçüm Ekle';
  static const String deleteMeasurement = 'Ölçümü Sil';
  static const String hemoglobin = 'Hemoglobin';
  static const String hematocrit = 'Hematokrit';
  static const String ferritin = 'Ferritin';
  static const String measurementDate = 'Ölçüm Tarihi';
  static const String measurementValue = 'Değer';
  static const String measurementUnit = 'Birim';
  static const String measurementSource = 'Laboratuvar / Rapor Kaynağı';
  static const String referenceRange = 'Referans Aralığı';
  static const String bloodValuesDisclaimer =
      'Bu ekran yalnızca kişisel kayıt tutma ve görselleştirme amaçlıdır; tıbbi tanı veya kan bağışı uygunluk onayı oluşturmaz.';
  static const String noMeasurements =
      'Henüz bu gösterge için kayıtlı ölçüm bulunmuyor.';
  static const String singleMeasurementNotice =
      'Grafiğin çizgi eğilimini görmek için birden fazla tarihli ölçüm giriniz.';

  // Blood Requests
  static const String bloodRequestsTitle = 'Kan İhtiyaçları';
  static const String urgencyNormal = 'Normal';
  static const String urgencyHigh = 'Yüksek';
  static const String urgencyEmergency = 'Acil';
  static const String statusActive = 'Aktif İhtiyaç';
  static const String statusFulfilled = 'Karşılandı';
  static const String statusExpired = 'Süresi Doldu';
  static const String planForThisRequest = 'Bu talep için bağış planla';
  static const String searchByDistrict = 'İlçeye göre filtrele';
  static const String filterByBloodGroup = 'Kan grubuna göre filtrele';
  static const String sortByDistance = 'Yakınlığa Göre Sırala';
  static const String sortByDate = 'Tarihe Göre Sırala';
  static const String sampleDistance = 'Örnek mesafe';
  static const String fictionalNotice =
      'Tüm isimler ve kurumlar ders kapsamında kurgusaldır.';

  // Donation Centers
  static const String donationCentersTitle = 'Bağış Noktaları';
  static const String workingHours = 'Çalışma Saatleri';
  static const String availableSlots = 'Uygun Saat Aralıkları';
  static const String copyAddress = 'Adresi Kopyala';
  static const String addressCopied = 'Adres panoya kopyalandı.';

  // Booking
  static const String bookingTitle = 'Bağış Randevusu Planla';
  static const String bookingTypeGeneral = 'Genel Kan Bağışı';
  static const String bookingTypeSpecific = 'Belirli Bir Hasta / Talep İçin';
  static const String recipientNotice =
      'Önemli: Bir hasta veya talep adına bağış yapmak, toplanan kanın doğrudan o kişiye verileceği garantisini oluşturmaz. Kanlar test ve uygunluk işlemlerinden geçtikten sonra ortak ulusal havuzdan yönlendirilir.';
  static const String selectCenter = 'Bağış Merkezi Seçin';
  static const String selectDate = 'Randevu Tarihi Seçin';
  static const String selectSlot = 'Uygun Saat Seçin';
  static const String bookingConfirmed =
      'Demo bağış randevunuz başarıyla oluşturuldu.';
  static const String bookingCancelled = 'Randevu iptal edildi.';
  static const String alreadyBookedNotice =
      'Zaten aktif bir randevunuz bulunmaktadır.';

  // Eligibility
  static const String eligibilityTitle = 'Ön Bilgi ve Değerlendirme Formu';
  static const String eligibilitySubtitle = 'Bağış öncesi genel durum anketi';
  static const String yes = 'Evet';
  static const String no = 'Hayır';
  static const String unsure = 'Emin Değilim';
  static const String unanswered = 'Yanıtsız';
  static const String eligibilityNotice =
      'Bu form kesin bir tıbbi onay motoru değildir. Kesin uygunluk değerlendirmesi bağış merkezindeki doktor muayenesinde yapılır.';
  static const String reviewTopics = 'Merkezde Doktorla Görüşülecek Başlıklar';
  static const String saveResponses = 'Yanıtları Kaydet';
  static const String responsesSaved = 'Yanıtlarınız başarıyla kaydedildi.';

  // History & Life Chain
  static const String historyTitle = 'Bağış Geçmişim';
  static const String lifeChain = 'Hayat Zinciri';
  static const String statusPlanned = 'Planlandı';
  static const String statusCompleted = 'Tamamlandı (Demo)';
  static const String statusCancelled = 'İptal Edildi';
  static const String stageDonated = 'Bağış Alındı';
  static const String stageTested = 'Test ve Kontrol Süreci';
  static const String stageReady = 'Dağıtıma Hazır';
  static const String stageDelivered = 'İlgili Merkeze İletildi';
  static const String markCompletedDemo = 'Demo Bağışı Tamamla';
  static const String markCompletedNotice =
      'Sunum amaçlı demo tamamlamadır. Gerçek kan bankası ve hasta stok kayıtlarını etkilemez.';

  // Profile & Badges
  static const String profileTitle = 'Bağışçı Profilim';
  static const String badgesTitle = 'Kazandığım Rozetler';
  static const String themePreference = 'Görünüm Teması';
  static const String themeLight = 'Açık Tema';
  static const String themeDark = 'Koyu Tema';
  static const String themeSystem = 'Sistem Teması';
  static const String shareAwareness = 'Farkındalık Metnini Paylaş';
  static const String awarenessShareText =
      'Ben de Kan Bağı ile düzenli kan bağışçısıyım! Sen de hayat kurtarmak için sana en yakın bağış noktasına başvurabilirsin. #KanBağı #HayatKurtar';
  static const String shareCopied = 'Farkındalık mesajı panoya kopyalandı!';
}
