import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../providers/donation_providers.dart';

class EligibleFoodsScreen extends ConsumerWidget {
  const EligibleFoodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibleAsync = ref.watch(eligibleDonationFoodsProvider);
    final activeDrafts = ref.watch(activeDonationDraftsProvider);
    final ctrl = ref.read(donationControllerProvider);

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Bağışa Uygun Ürünler',
        showBackButton: true,
      ),
      body: eligibleAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Yükleme hatası: $err'),
        ),
        data: (eligibleList) {
          if (eligibleList.isEmpty) {
            return EmptyStateView(
              icon: Icons.volunteer_activism_outlined,
              title: 'Uygun Ürün Bulunamadı',
              description:
                  'Şu anda envanterinizde ambalajı açılmamış ve son tüketim tarihi uygun ürün bulunmuyor.',
              buttonText: 'Envantere Yeni Ürün Ekle',
              onButtonPressed: () => context.push('/products/new'),
            );
          }

          final targetDraft = activeDrafts.isNotEmpty ? activeDrafts.first : null;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eligibleList.length,
            itemBuilder: (context, index) {
              final wrapper = eligibleList[index];
              final food = wrapper.food;
              final isInDraft = targetDraft?.itemIds.contains(food.id) ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryMint.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.inventory_2_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${food.quantity.toStringAsFixed(0)} ${food.unit} • ${food.storageLocation.label}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.safeBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              wrapper.eligibility.statusTag,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.safe,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (targetDraft != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInDraft
                              ? AppColors.surfaceMuted
                              : const Color(0xFF005A36),
                          foregroundColor: isInDraft
                              ? AppColors.textPrimary
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () async {
                          await ctrl.toggleItemInDraft(targetDraft.id, food.id);
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
                        },
                        child: Text(
                          isInDraft ? 'Çıkar' : '+ Pakete Ekle',
                          style: const TextStyle(fontSize: 11),
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005A36),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          context.push('/donations/drafts/new');
                        },
                        child: const Text('+ Yeni Paket',
                            style: TextStyle(fontSize: 11)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
