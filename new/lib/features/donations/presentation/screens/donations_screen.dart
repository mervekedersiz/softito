import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/food_thumbnail.dart';
import '../../../inventory/domain/entities/food_item.dart';
import '../../domain/entities/donation_package.dart';
import '../providers/donation_providers.dart';
import '../widgets/donation_guidelines_dialog.dart';
import '../widgets/donation_location_card.dart';

class DonationsScreen extends ConsumerWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibleAsync = ref.watch(eligibleDonationFoodsProvider);
    final activeDrafts = ref.watch(activeDonationDraftsProvider);
    final completedList = ref.watch(completedDonationsProvider);
    final campaignDraft = ref.watch(campaignDonationPackageProvider);
    final ctrl = ref.read(donationControllerProvider);

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Özet',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Card (Yerel Dayanışma - Gıda Bağışı & Paylaşım)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7F4E5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.volunteer_activism_outlined,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                const Text(
                                  'Yerel Dayanışma',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Gıda Bağışı & Paylaşım',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Info question mark button
                      IconButton(
                        icon: const Icon(Icons.help_outline,
                            size: 22, color: AppColors.textSecondary),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const DonationGuidelinesDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'İhtiyaç fazlası taze ve kuru gıdaları israf etmeyin; mahallenizdeki aşevleri, dayanışma dolapları ve ihtiyaç sahipleriyle kolayca paylaşın.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Community highlight banner
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAF8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.eco_outlined,
                            size: 16, color: AppColors.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bu ay mahallede: 42 kg gıda paylaşıldı • 14 hane faydalandı',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2. Section: Bağışa Uygun Ürünlerin
            eligibleAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (err, _) => Text('Yükleme hatası: $err'),
              data: (eligibleList) {
                final displayItems = eligibleList.take(3).toList();
                final currentDraft = campaignDraft ?? (activeDrafts.isNotEmpty ? activeDrafts.first : null);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Bağışa Uygun Ürünlerin',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${eligibleList.length} Öneri',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0A84FF),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => context.push('/donations/eligible'),
                          child: const Text(
                            'Tümünü Gör',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Gıda Güvenliği Şartı Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 16, color: Color(0xFFD97706)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Gıda Güvenliği Şartı: Yalnızca ambalajı açılmamış, soğuk zinciri bozulmamış ve STT süresi dolmamış ürünler bağış listesine kabul edilir.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF92400E),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Eligible Product Cards
                    if (displayItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          'Şu an envanterinizde ambalajı açılmamış uygun ürün bulunmuyor.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      )
                    else
                      ...displayItems.map((wrapper) {
                        final food = wrapper.food;
                        final isInDraft = currentDraft?.itemIds.contains(food.id) ?? false;

                        return _buildDonationFoodCard(
                          context: context,
                          food: food,
                          statusTag: wrapper.eligibility.statusTag,
                          isInDraft: isInDraft,
                          onAction: () async {
                            if (currentDraft != null) {
                              await ctrl.toggleItemInDraft(currentDraft.id, food.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isInDraft
                                        ? '${food.name} paketten çıkarıldı.'
                                        : '${food.name} pakete eklendi.'),
                                    backgroundColor: AppColors.primary,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            } else {
                              context.push('/donations/drafts/new');
                            }
                          },
                        );
                      }),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),

            // 3. Campaign Box (Kış Dayanışması Erzak Paketi)
            _buildCampaignCard(context, campaignDraft, ctrl),
            const SizedBox(height: 20),

            const DonationLocationCard(),
            const SizedBox(height: 24),

            // 5. Bottom Main CTA: + Yeni Bağış Paketi / İlanı Oluştur
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005A36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  context.push('/donations/drafts/new');
                },
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text(
                  'Yeni Bağış Paketi / İlanı Oluştur',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 6. Secondary Link: Geçmiş Bağışlarım ve Etki Sertifikalarım
            Center(
              child: TextButton.icon(
                onPressed: () {
                  context.push('/donations/history');
                },
                icon: const Icon(Icons.receipt_long_outlined,
                    size: 16, color: AppColors.textSecondary),
                label: Text(
                  'Geçmiş Bağışlarım ve Taslaklarım (${completedList.length + activeDrafts.length} Kayıt)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationFoodCard({
    required BuildContext context,
    required FoodItem food,
    required String statusTag,
    required bool isInDraft,
    required VoidCallback onAction,
  }) {
    Color leftColor = const Color(0xFFC86D24);
    if (food.storageLocation == StorageLocation.fridge) {
      leftColor = const Color(0xFF007A4D);
    } else if (food.storageLocation == StorageLocation.freezer) {
      leftColor = const Color(0xFF0A84FF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: leftColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      FoodThumbnail(
                        foodName: food.name,
                        category: food.category,
                        size: 46,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    food.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${food.quantity.toStringAsFixed(0)}${food.unit}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  food.storageLocation.label,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('•',
                                    style: TextStyle(
                                        fontSize: 11, color: AppColors.textMuted)),
                                const SizedBox(width: 6),
                                const Icon(Icons.check_circle_outline,
                                    size: 12, color: AppColors.primary),
                                const SizedBox(width: 3),
                                Text(
                                  statusTag,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInDraft
                              ? AppColors.surfaceMuted
                              : const Color(0xFF005A36),
                          foregroundColor: isInDraft
                              ? AppColors.textPrimary
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: onAction,
                        child: Text(
                          isInDraft ? 'Pakette ✓' : '+ Pakete Ekle',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    DonationPackage? campaign,
    DonationController ctrl,
  ) {
    final itemCount = campaign?.itemIds.length ?? 2;
    const totalTarget = 3;
    final progressFraction = '$itemCount/$totalTarget';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE8D1)),
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8D1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: Color(0xFFC86D24), size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Kış Dayanışması Erzak Paketi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8D1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Kampanya',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC86D24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Kilerindeki kullanılmayan 3 kuru bakliyatı birleştirerek yerel öğrenci evleri ve dayanışma mutfaklarına doğrudan ulaştır.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE8D1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFD7F4E5),
                  child: Text(
                    progressFraction,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erzak Kutusu Hazır Olmak Üzere',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Nohut veya Pirinç eklenirse hazır',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDAB9),
                    foregroundColor: const Color(0xFF8B4513),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    if (campaign != null) {
                      await ctrl.completeDraft(campaign.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erzak paketi hazırlandı ve teslimat kaydı tamamlandı!'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    } else {
                      context.push('/donations/eligible');
                    }
                  },
                  child: const Text('Tamamla',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
