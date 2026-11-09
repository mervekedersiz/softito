import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../providers/recipe_providers.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(recipeMatchesProvider);
    final onlyFull = ref.watch(onlyFullRecipesFilterProvider);
    final recipeCtrl = ref.read(recipeControllerProvider);
    final balance = ref.watch(kitchenBalanceProvider);

    return Scaffold(
      appBar: const AppHeader(subtitle: 'Bugün Pişir'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chef AI Quick Banner
            InkWell(
              onTap: () => context.push('/chef-ai'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryMint.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryMint),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.psychology_outlined,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Şef AI (Akıllı Mutfak)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            'Buzdolabı & kiler danışmanına sor',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Akıllı Kiler Dengesi Card
            Container(
              padding: const EdgeInsets.all(16),
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
                      const Row(
                        children: [
                          Icon(Icons.whatshot,
                              size: 16, color: Color(0xFFC86D24)),
                          SizedBox(width: 6),
                          Text(
                            'AKILLI KİLER DENGESİ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC86D24),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '• ${balance.criticalCount} Kritik Ürün',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bugün Tüketilmesi Gereken ${balance.criticalCount} Malzemeniz Var',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tarihi yaklaşan aktif stoklarınızı lezzetli öğünlere dönüştürün, israfı sıfırlayın.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Pills
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildPill('Süt (Bugün Son)', AppColors.dangerBg,
                          AppColors.danger, Icons.access_time),
                      _buildPill('Tavuk Göğsü (1 Gün)', AppColors.warningBg,
                          AppColors.warning, Icons.access_time),
                      _buildPill('Kültür Mantarı (2 Gün)', AppColors.warningBg,
                          AppColors.warning, Icons.access_time),
                      _buildPill('Kaşar Peyniri (Açılmış Paket)',
                          AppColors.safeBg, AppColors.safe, Icons.check),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Güvenlik İlkesi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield_outlined,
                            size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Güvenlik İlkesi: Tarihi geçmiş (STT) ürünler asla önerilmez. Lütfen pişirmeden önce koku, doku ve görünüş kontrolü yapınız.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryDark,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Toggle "Sadece Eksiksiz Tarifler (%100)"
            Row(
              children: [
                Switch(
                  value: onlyFull,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(onlyFullRecipesFilterProvider.notifier).setVal(val);
                  },
                ),
                const SizedBox(width: 6),
                const Text(
                  'Sadece Eksiksiz Tarifler (%100)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${matches.length} Öneri',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A84FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Recipe Cards
            ...matches.map((match) {
              return _buildRecipeCard(context, ref, match, recipeCtrl);
            }),

            const SizedBox(height: 16),
            // Bottom Discovery Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Text(
                    'Farklı bir şeyler mi arıyorsunuz?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Çevrimdışı kayıtlı 450+ pratik Türk mutfağı reçetesini keşfedin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (ctx) => DraggableScrollableSheet(
                          initialChildSize: 0.7,
                          maxChildSize: 0.9,
                          minChildSize: 0.4,
                          expand: false,
                          builder: (c, scrollCtrl) => Container(
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                              controller: scrollCtrl,
                              children: [
                                const Text(
                                  'Yerel Türk Mutfağı Kataloğu',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...matches.map((m) => ListTile(
                                      leading: const Icon(Icons.restaurant,
                                          color: AppColors.primary),
                                      title: Text(m.recipe.name),
                                      subtitle: Text(
                                          '${m.recipe.cookingTimeMinutes} dk • ${m.recipe.difficulty}'),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14),
                                      onTap: () {
                                        Navigator.pop(ctx);
                                        context.push('/recipes/${m.recipe.id}');
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Text(
                      'Tüm Yerel Tarif Kataloğunu İncele',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    label: const Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    WidgetRef ref,
    RecipeMatch match,
    RecipeController ctrl,
  ) {
    final recipe = match.recipe;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: match.isFullMatch
                            ? AppColors.primaryMint
                            : AppColors.warningBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            match.isFullMatch
                                ? Icons.check
                                : Icons.star_border,
                            size: 12,
                            color: match.isFullMatch
                                ? AppColors.primary
                                : AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            match.isFullMatch
                                ? '%100 Dolaptan'
                                : '%${match.matchPercentage} Karşılandı',
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
                    ),
                    Text(
                      '${recipe.servings} Porsiyon',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${recipe.difficulty} • ${recipe.subtitle}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.bolt,
                        size: 14, color: Color(0xFFC86D24)),
                    const SizedBox(width: 4),
                    Text(
                      recipe.rescuedDescription,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC86D24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Kullanılacak stok ürünler box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: AppColors.surfaceMuted,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KULLANILACAK STOK ÜRÜNLER:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: match.matchedItems.map((food) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check,
                              size: 11, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${food.name} (${food.quantity.toStringAsFixed(0)}${food.unit})',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (match.missingIngredients.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart_outlined,
                          size: 13, color: AppColors.danger),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Eksik: ${match.missingIngredients.map((i) => '${i.amount.toStringAsFixed(0)}${i.unit} ${i.name}').join(', ')}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Eksik malzeme alışveriş listesine eklendi.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Text(
                            '+ Listeye Ekle',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Bottom Action Row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: match.isFullMatch
                            ? const Color(0xFF005A36)
                            : AppColors.surfaceMuted,
                        foregroundColor: match.isFullMatch
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                      onPressed: () {
                        context.push('/recipes/${recipe.id}');
                      },
                      icon: Icon(
                        match.isFullMatch
                            ? Icons.soup_kitchen
                            : Icons.menu_book,
                        size: 18,
                      ),
                      label: Text(
                        match.isFullMatch
                            ? 'Tarifi Gör & Malzemeleri Düş'
                            : 'Tarif Detayını Oku',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => ctrl.toggleBookmark(recipe.id),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      match.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: match.isBookmarked
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(
      String label, Color bg, Color text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
