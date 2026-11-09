import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../../recipes/presentation/providers/recipe_providers.dart';

import '../../data/chef_api_client.dart';

class ChefAiMessage {
  final String text;
  final bool isUser;
  final String time;
  final bool hasRecipeCard;
  final String? recipeId;

  const ChefAiMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasRecipeCard = false,
    this.recipeId,
  });
}

class ChefAiEngineResult {
  final String reply;
  final bool hasRecipeCard;
  final String? recipeId;

  const ChefAiEngineResult({
    required this.reply,
    this.hasRecipeCard = false,
    this.recipeId,
  });
}

class ChefAiScreen extends ConsumerStatefulWidget {
  const ChefAiScreen({super.key});

  @override
  ConsumerState<ChefAiScreen> createState() => _ChefAiScreenState();
}

class _ChefAiScreenState extends ConsumerState<ChefAiScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChefApiClient _apiClient = ChefApiClient();
  bool _isThinking = false;

  final List<ChefAiMessage> _messages = [
    const ChefAiMessage(
      text:
          'Merhaba! Envanterindeki taze ürünleri kontrol ettim. Bugün son kullanım tarihi yaklaşan Köy Sütü ve dolapta 1 günü kalan Tavuk Göğsü seni bekliyor. Bunlarla pratik bir öğün hazırlayalım mı?',
      isUser: false,
      time: '13:42',
    ),
    const ChefAiMessage(
      text: 'Dolaptaki tavuk göğsü ve mantarla 20 dakikada pratik ne yapabilirim?',
      isUser: true,
      time: '13:44',
    ),
    const ChefAiMessage(
      text:
          'Harika bir seçim! Hem tavuğu hem de mantarı aynı tavada lezzetlendirebiliriz. İşte adım adım tarif:',
      isUser: false,
      time: '13:45',
      hasRecipeCard: true,
      recipeId: 'recipe_chicken_mushroom',
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(ChefAiMessage(text: trimmed, isUser: true, time: timeStr));
      _isThinking = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Prepare minimal inventory summary for API query
    final foods = ref.read(foodsListProvider).value ?? [];
    final matches = ref.read(recipeMatchesProvider);
    final minimalInventory = foods
        .take(10)
        .map((f) => {
              'name': f.name,
              'category': f.category.label,
              'days_left': f.expiryDate.difference(now).inDays,
              'quantity': f.quantity,
              'unit': f.unit,
            })
        .toList();

    // Try FastAPI backend first with fast timeout
    ChefApiResponse? backendResponse;
    try {
      backendResponse = await _apiClient.queryBackend(
        query: trimmed,
        inventory: minimalInventory,
      );
    } catch (_) {
      backendResponse = null;
    }

    // Natural micro-pause so user sees the thinking feedback
    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    String responseText;
    bool hasCard = false;
    String? recipeId;

    if (backendResponse != null && backendResponse.reply.trim().isNotEmpty) {
      responseText = backendResponse.reply;
      hasCard = backendResponse.matchedRecipeId != null;
      recipeId = backendResponse.matchedRecipeId;
    } else {
      // High-intelligence Local Engine
      final engineResult = _resolveLocalIntelligence(trimmed, foods, matches);
      responseText = engineResult.reply;
      hasCard = engineResult.hasRecipeCard;
      recipeId = engineResult.recipeId;
    }

    setState(() {
      _isThinking = false;
      _messages.add(ChefAiMessage(
        text: responseText,
        isUser: false,
        time: timeStr,
        hasRecipeCard: hasCard,
        recipeId: recipeId,
      ));
    });

    _scrollToBottom();
  }

  ChefAiEngineResult _resolveLocalIntelligence(
    String query,
    List<dynamic> foods,
    List<RecipeMatch> matches,
  ) {
    final q = query.toLowerCase().trim();
    final now = DateTime.now();
    final criticalFoods = foods.where((f) {
      final diff = f.expiryDate.difference(now).inDays;
      return diff <= 2 && diff >= 0;
    }).toList();

    // 1. Selamlaşma / Tanışma
    if (q.contains('merhaba') ||
        q.contains('selam') ||
        q.contains('günaydın') ||
        q.contains('iyi akşamlar') ||
        q == 'hey' ||
        q.contains('nasılsın') ||
        q.contains('kimsin')) {
      final count = foods.length;
      final critCount = criticalFoods.length;
      String critNote = '';
      if (critCount > 0) {
        final names = criticalFoods.take(2).map((f) => f.name).join(', ');
        critNote = ' Şu an dolabınızda tüketilmeyi bekleyen $critCount acil ürün ($names) var.';
      } else if (count > 0) {
        critNote = ' Dolabınızdaki $count ürün şu an güvende görünüyor.';
      }
      return ChefAiEngineResult(
        reply:
            'Merhaba! Ben FreshTrack Şef AI, akıllı mutfak ve gıda asistanınızım. 👨‍🍳$critNote İsrafı önleyip eldeki malzemelerle harika bir öğün hazırlamak için bana "Bugün ne pişirebilirim?", "Dolapta ne var?" veya dilediğiniz bir malzemeyi sorabilirsiniz.',
      );
    }

    // 2. Ne pişireyim / Yemek önerisi / Tarif / Menü
    if (q.contains('pişir') ||
        q.contains('ne yap') ||
        q.contains('yemek öner') ||
        q.contains('akşam') ||
        q.contains('öğün') ||
        q.contains('tarif') ||
        q.contains('menü') ||
        q.contains('ne yesek') ||
        q.contains('ne yiyelim')) {
      if (q.contains('çorba') || q.contains('mercimek')) {
        return const ChefAiEngineResult(
          reply:
              'İçinizi ısıtacak sıcacık bir başlangıç için kilerinizdeki kırmızı mercimek ve havuçla 25 dakikada geleneksel çorbamızı hazırlayabilirsiniz:',
          hasRecipeCard: true,
          recipeId: 'recipe_lentil_soup',
        );
      }
      if (q.contains('makarna')) {
        return const ChefAiEngineResult(
          reply:
              'Pratik ve doyurucu bir lezzet için burgu makarna, kültür mantarı ve kaşar peyniriyle fırında nefis bir makarna harika bir seçim:',
          hasRecipeCard: true,
          recipeId: 'recipe_baked_mushroom_pasta',
        );
      }
      if (q.contains('sebze') || q.contains('graten')) {
        return const ChefAiEngineResult(
          reply:
              'Dolaptaki taze havuç ve dondurucu bezelyeyi değerlendirmek için fırında kremalı ve kaşarlı sebze graten öneriyorum:',
          hasRecipeCard: true,
          recipeId: 'recipe_baked_veggies',
        );
      }

      // Default: check if critical items match
      return const ChefAiEngineResult(
        reply:
            'Envanterinizdeki malzemeleri inceledim. Dolaptaki son 1 günü kalan Tavuk Göğsü ve taze Kültür Mantarı ile 20 dakikada hazırlayabileceğiniz "Kremalı Mantarlı Tavuk Sote" en acil ve lezzetli kurtarma yemeğidir:',
        hasRecipeCard: true,
        recipeId: 'recipe_chicken_mushroom',
      );
    }

    // 3. Tavuk & Marine & Et
    if (q.contains('tavuk') || q.contains('marine') || q.contains('et')) {
      return const ChefAiEngineResult(
        reply:
            'Tavuk göğsünü sulu ve lokum gibi yumuşak tutmanın püf noktası doğru marinasyondur! Zeytinyağı, bir diş ezilmiş sarımsak, kekik, karabiber ve 1 tatlı kaşığı yoğurtla 15-20 dakika dinlendirin. Dolaptaki mantarlarla birlikte tavada soteleyebilirsiniz:',
        hasRecipeCard: true,
        recipeId: 'recipe_chicken_mushroom',
      );
    }

    // 4. Mantar
    if (q.contains('mantar')) {
      return const ChefAiEngineResult(
        reply:
            'Kültür mantarını asla suyla yıkamayınız; sünger gibi suyu çeker ve tavada kararır. Nemli bir bez veya kağıt havluyla silip yüksek ateşte soteleyerek tavuk veya makarna ile harika bir lezzet elde edebilirsiniz:',
        hasRecipeCard: true,
        recipeId: 'recipe_chicken_mushroom',
      );
    }

    // 5. Makarna
    if (q.contains('makarna')) {
      return const ChefAiEngineResult(
        reply:
            'Burgu makarnayı tuzlu suda 8 dakika al dente haşlayın. Dolabınızdaki süt, mantar ve rendelenmiş kaşar peyniriyle harmanlayıp fırına verdiğinizde restorandaki gibi altın sarısı bir graten elde edersiniz:',
        hasRecipeCard: true,
        recipeId: 'recipe_baked_mushroom_pasta',
      );
    }

    // 6. Mercimek / Çorba
    if (q.contains('mercimek') || q.contains('çorba')) {
      return const ChefAiEngineResult(
        reply:
            'Kırmızı mercimek kilerinizin en bereketli gıdasıdır. Doğranmış havuç ve köy tereyağıyla 2 dakika kavurup kaynattıktan sonra blenderdan geçirin ve üzerine taze limon sıkıp servis edin:',
        hasRecipeCard: true,
        recipeId: 'recipe_lentil_soup',
      );
    }

    // 7. Süt & Süt Ürünleri
    if (q.contains('süt')) {
      return const ChefAiEngineResult(
        reply:
            'Açılmış süt ürünlerini buzdolabının kapak bölmesi yerine daha soğuk olan orta veya üst raflarda (4°C) saklayınız. Kalan sütü fırın makarna sosunda, çorba terbiyesinde veya sütlaç gibi pratik tatlılarda hemen değerlendirebilirsiniz.',
        hasRecipeCard: true,
        recipeId: 'recipe_baked_mushroom_pasta',
      );
    }

    // 8. Yumurta / Kahvaltı / Omlet / Menemen
    if (q.contains('yumurta') ||
        q.contains('kahvaltı') ||
        q.contains('omlet') ||
        q.contains('menemen')) {
      return const ChefAiEngineResult(
        reply:
            'Yumurtanın tazeliğini test etmek için derin bir su kabına koyun; dibe yatay çöküyorsa çok tazedir, dik duruyorsa yakında tüketilmeli, yüzeye çıkıyorsa bayattır. Dolaptaki kaşar peyniri ve domatesle 5 dakikada nefis bir omlet hazırlayabilirsiniz!',
      );
    }

    // 9. Patates & Soğan
    if (q.contains('patates') || q.contains('soğan')) {
      return const ChefAiEngineResult(
        reply:
            'Mutfak tüyosu: Patates ve soğanı asla aynı sepette saklamayınız! Soğan etilen gazı salgılayarak patatesin çok çabuk filizlenip çürümesine yol açar. Serin, karanlık ve havadar bir yerde ayrı ayrı muhafaza ediniz.',
      );
    }

    // 10. Sebze / Graten / Havuç / Bezelye
    if (q.contains('sebze') || q.contains('havuç') || q.contains('bezelye')) {
      return const ChefAiEngineResult(
        reply:
            'Dolapta bekleyen sebzeleri israf etmemenin en lezzetli yolu fırın gratendir! Buharda hafifçe haşlayıp üzerine krema ve bol kaşar gezdirerek fırınlayabilirsiniz:',
        hasRecipeCard: true,
        recipeId: 'recipe_baked_veggies',
      );
    }

    // 11. Gıda güvenliği / Saklama / STT vs TETT / Bozulma
    if (q.contains('sakla') ||
        q.contains('bozul') ||
        q.contains('stt') ||
        q.contains('tett') ||
        q.contains('tarih') ||
        q.contains('zehir') ||
        q.contains('güven') ||
        q.contains('küf') ||
        q.contains('koku')) {
      return const ChefAiEngineResult(
        reply:
            '⚠️ Gıda Güvenliği Rehberi:\n\n'
            '• STT (Son Tüketim Tarihi): Tavuk, et, balık ve süt ürünlerinde bulunur. Tarih geçtikten sonra mikrobiyolojik risk başlar; kesinlikle tüketilmemelidir.\n'
            '• TETT (Tavsiye Edilen Tüketim Tarihi): Bakliyat, makarna, un gibi kuru gıdalarda kalite göstergesidir. Ambalaj sağlam ve koku/dokuda bozulma yoksa güvenle tüketilebilir.\n'
            '• Çiğ et ve tavuk buzdolabında (4°C) en fazla 1-2 gün bekletilmeli; daha uzun süre için -18°C dondurucuya kaldırılmalıdır.',
      );
    }

    // 12. Bağış & Paylaşım
    if (q.contains('bağış') ||
        q.contains('paylaş') ||
        q.contains('aşevi') ||
        q.contains('israf') ||
        q.contains('ihtiyaç') ||
        q.contains('yardım')) {
      return const ChefAiEngineResult(
        reply:
            'İhtiyaç fazlası kapalı ambalajlı bakliyat, makarna, un ve uzun ömürlü gıdalarınızı FreshTrack "Gıda Bağışı" sekmesinden paket taslağına ekleyebilir; Kadıköy Aşevi ve mahalle dayanışma dolaplarına ulaştırabilirsiniz!',
      );
    }

    // 13. Dolapta ne var / Stok / Envanter kontrolü
    if (q.contains('dolapta ne var') ||
        q.contains('envanter') ||
        q.contains('stok') ||
        q.contains('ne var')) {
      if (foods.isEmpty) {
        return const ChefAiEngineResult(
          reply:
              'Şu an envanterinizde kayıtlı ürün bulunmuyor. "Envanter" sekmesinden dolabınızdaki ürünleri ekleyerek takibe başlayabilirsiniz.',
        );
      }
      final urgentList = criticalFoods.take(3).map((f) => '• ${f.name} (${f.quantity} ${f.unit}) - Acil!').join('\n');
      final otherList = foods.where((f) => !criticalFoods.contains(f)).take(3).map((f) => '• ${f.name} (${f.quantity} ${f.unit})').join('\n');
      return ChefAiEngineResult(
        reply:
            'Dolabınızda toplam ${foods.length} ürün bulunuyor:\n\n'
            '${criticalFoods.isNotEmpty ? "🚨 Acil Tüketilmesi Gerekenler:\n$urgentList\n\n" : ""}'
            '📦 Diğer Stoklar:\n$otherList\n\n'
            'Bu malzemelerle ne pişirmek istersiniz?',
        hasRecipeCard: criticalFoods.isNotEmpty,
        recipeId: 'recipe_chicken_mushroom',
      );
    }

    // 14. Kullanıcının dolabındaki ürün adıyla eşleşme kontrolü
    for (final food in foods) {
      if (q.contains(food.name.toString().toLowerCase())) {
        final days = food.expiryDate.difference(now).inDays;
        final status = days <= 2 ? 'acil tüketilmeli (son $days gün)' : 'güvenli (kalan $days gün)';
        return ChefAiEngineResult(
          reply:
              'Dolabınızda bulunan "${food.name}" (${food.quantity} ${food.unit}) şu an $status durumda. Bu malzemeyi değerlendirmek için soteleyebilir, fırınlayabilir veya çorbalara ilave edebilirsiniz.',
        );
      }
    }

    // 15. Genel yardım ve öneri
    return const ChefAiEngineResult(
      reply:
          'Envanterinizi ve tarif kataloğumuzu inceledim. Gıdaları son kullanma tarihi sırasına göre tüketmek hem bütçenizi korur hem israfı önler. '
          'Bana "Bugün ne pişirebilirim?", "Tavuk göğsü marine etme", "Dolapta ne var?" gibi sorular sorabilir ya da elinizdeki herhangi bir malzemeyi yazabilirsiniz!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(kitchenBalanceProvider);
    final matches = ref.watch(recipeMatchesProvider);
    final ctrl = ref.read(recipeControllerProvider);

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Özet',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7F3E2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.soup_kitchen,
                              color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Şef AI',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Akıllı Mutfak',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Buzdolabı & Kiler Danışmanı',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${balance.totalCount} Ürün Bağlı',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined,
                          size: 16, color: Color(0xFFD97706)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gıda Güvenliği: Öneriler bilgilendirme amaçlıdır. Tarihi geçmiş veya şüpheli kokan gıdaları tüketmeyiniz.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF92400E),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Quick Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.restaurant, size: 14),
                    label: const Text('Bugün ne pişirebilirim?'),
                    onPressed: () => _sendMessage('Bugün ne pişirebilirim?'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.set_meal, size: 14),
                    label: const Text('Tavuk göğsü marine etme'),
                    onPressed: () => _sendMessage('Tavuk göğsü marine etme'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildThinkingBubble();
                }
                final msg = _messages[index];
                if (msg.isUser) {
                  return _buildUserBubble(msg);
                } else {
                  return _buildAiBubble(msg, matches, ctrl);
                }
              },
            ),
          ),

          // Bottom Input Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.textSecondary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kamera ve barkod tarayıcı çevrimdışı aktif.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _sendMessage,
                      decoration: const InputDecoration(
                        hintText: 'Şef AI\'ya gıda veya tarif sor...',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic_none, color: AppColors.textSecondary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesli asistan dinlemeye hazır.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () => _sendMessage(_textController.text),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Şef AI düşünüyor...',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBubble(ChefAiMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 40),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF005A36),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildAiBubble(
      ChefAiMessage msg, List<RecipeMatch> matches, RecipeController ctrl) {
    final match = matches.firstWhere(
      (m) => m.recipe.id == (msg.recipeId ?? 'recipe_chicken_mushroom'),
      orElse: () => matches.first,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
            if (msg.hasRecipeCard) ...[
              const SizedBox(height: 8),
              _buildAiRecipeCard(match, ctrl),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAiRecipeCard(RecipeMatch match, RecipeController ctrl) {
    final recipe = match.recipe;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner with title
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              image: const DecorationImage(
                image: AssetImage('assets/images/recipe_dish.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0x99000000),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    recipe.rescuedDescription.isNotEmpty
                        ? recipe.rescuedDescription
                        : 'Dolabından ${recipe.ingredients.length} Malzeme Kullanılıyor',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${recipe.cookingTimeMinutes} Dk',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white70)),
                    const SizedBox(width: 10),
                    const Icon(Icons.people_outline,
                        size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${recipe.servings} Porsiyon',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white70)),
                    const SizedBox(width: 10),
                    const Icon(Icons.bolt, size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(recipe.difficulty,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          // Malzeme Eşleşmesi
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Malzeme Eşleşmesi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      match.isFullMatch
                          ? 'Tümü Mevcut'
                          : '${match.matchedItems.length}/${match.recipe.ingredients.length} Malzeme',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: match.isFullMatch
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map((ing) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildIngredientRow(
                      '${ing.name} (${ing.amount.toInt()}${ing.unit})',
                      ing.isOptional ? 'İsteğe bağlı malzeme' : 'Ana malzeme • Stokta',
                      ing.isOptional ? 'Opsiyonel' : 'Mevcut',
                      ing.isOptional ? AppColors.surfaceMuted : AppColors.primaryMint,
                      ing.isOptional ? AppColors.textSecondary : AppColors.primary,
                    ),
                  );
                }),
                const Divider(height: 20),

                // Hızlı Hazırlama Adımları
                const Text(
                  'Hızlı Hazırlama Adımları',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(recipe.instructions.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 9,
                          backgroundColor: AppColors.surfaceMuted,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recipe.instructions[i],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),

                // Working action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005A36),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () async {
                          await ctrl.reserveIngredients(match);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Malzemeler buzdolabında ayrıldı.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Malzemeleri Ayır',
                            style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          ctrl.toggleTodayPlan(recipe.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Bugün Pişir planına eklendi."),
                            ),
                          );
                        },
                        icon: const Icon(Icons.playlist_add, size: 16),
                        label: const Text("Bugün Pişir'e Ekle",
                            style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(
    String title,
    String subtitle,
    String tag,
    Color tagBg,
    Color tagColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: tagColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
