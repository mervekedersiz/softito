import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../providers/donation_providers.dart';

class DonationDraftDetailScreen extends ConsumerWidget {
  final String draftId;

  const DonationDraftDetailScreen({super.key, required this.draftId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(donationPackageDetailProvider(draftId));
    final foodsAsync = ref.watch(foodsListProvider);
    final ctrl = ref.read(donationControllerProvider);

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Bağış Paketi Detayı',
        showBackButton: true,
      ),
      body: draftAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Paket yüklenemedi: $err'),
        ),
        data: (package) {
          if (package == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    const Text(
                      'Bağış Paketi Bulunamadı',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.go('/donations'),
                      child: const Text('Bağış Ekranına Dön'),
                    ),
                  ],
                ),
              ),
            );
          }

          final allFoods = foodsAsync.value ?? [];
          // Find foods in this draft
          final draftFoods = allFoods.where((f) => package.itemIds.contains(f.id)).toList();
          final missingItemCount = package.itemIds.length - draftFoods.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: package.status == DonationStatus.completedLocally
                                  ? AppColors.safeBg
                                  : AppColors.warningBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              package.status.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: package.status == DonationStatus.completedLocally
                                    ? AppColors.safe
                                    : AppColors.warning,
                              ),
                            ),
                          ),
                          Text(
                            DateFormatter.toShortDate(package.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        package.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      if (package.targetCenterName != null) ...[
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Hedef Merkez: ${package.targetCenterName}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic inventory synchronization alert
                if (missingItemCount > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.danger),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: AppColors.danger, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Envanter Senkronizasyonu: Paketteki $missingItemCount ürün önceden tüketildi, israf edildi veya silindi.',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Package Items List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Paket İçeriği (${draftFoods.length} Ürün)',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (package.status == DonationStatus.draft)
                      TextButton.icon(
                        onPressed: () => context.push('/donations/eligible'),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Ürün Ekle', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                if (draftFoods.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        'Pakette henüz aktif ürün bulunmuyor.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ...draftFoods.map((food) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.inventory_2_outlined,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${food.quantity.toStringAsFixed(0)} ${food.unit} • ${food.storageLocation.label}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (package.status == DonationStatus.draft)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: AppColors.danger, size: 20),
                              onPressed: () async {
                                await ctrl.toggleItemInDraft(package.id, food.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${food.name} paketten çıkarıldı.'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 24),

                // Actions
                if (package.status == DonationStatus.draft) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005A36),
                      ),
                      onPressed: draftFoods.isEmpty
                          ? null
                          : () async {
                              await ctrl.completeDraft(package.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Bağış paketi başarıyla tamamlandı ve teslim edildi olarak kaydedildi!'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                                context.pop();
                              }
                            },
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: const Text(
                        'Bağışı Tamamla / Teslim Et',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Taslağı Sil'),
                            content: const Text('Bu bağış paketi taslağını silmek istiyor musunuz? Ürünler envanterde serbest bırakılacaktır.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('İptal'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Sil'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          await ctrl.deleteDraft(package.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bağış taslağı silindi.')),
                            );
                            context.pop();
                          }
                        }
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Taslağı Sil'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
