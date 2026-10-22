import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_status.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/food_thumbnail.dart';
import '../../../donations/domain/usecases/check_donation_eligibility.dart';
import '../providers/inventory_providers.dart';

class FoodDetailScreen extends ConsumerWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodAsync = ref.watch(foodDetailProvider(foodId));

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Ürün Detayı',
        showBackButton: true,
      ),
      body: foodAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                const SizedBox(height: 12),
                Text('Hata oluştu: $err'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(foodDetailProvider(foodId)),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
        data: (food) {
          if (food == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 54, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    const Text(
                      'Ürün Bulunamadı',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Aradığınız ürün silinmiş veya geçersiz bir bağlantı kullanılmış olabilir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.go('/inventory'),
                      child: const Text('Envantere Dön'),
                    ),
                  ],
                ),
              ),
            );
          }

          final now = DateTime.now();
          final daysLeft = daysRemaining(now, food.expiryDate);
          final donationCheck = DonationEligibilityChecker.check(food, now);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
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
                          FoodThumbnail(
                            foodName: food.name,
                            category: food.category,
                            size: 60,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${food.quantity.toStringAsFixed(0)} ${food.unit} • ${food.category.label}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: AppColors.primary),
                            onPressed: () {
                              context.push('/products/${food.id}/edit');
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        'Saklama Yeri',
                        '${food.storageLocation.label} ${food.subLocation.isNotEmpty ? '(${food.subLocation})' : ''}',
                        Icons.kitchen,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Tarih Tipi & STT',
                        '${food.dateType.label}: ${DateFormatter.toTurkishDate(food.expiryDate)} ($daysLeft gün kaldı)',
                        Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Ambalaj Durumu',
                        food.packageStatus.label,
                        food.packageStatus == PackageStatus.unopened
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined,
                      ),
                      if (food.purchasePrice != null) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Kayıtlı Fiyat',
                          '₺${food.purchasePrice!.toStringAsFixed(2)}',
                          Icons.payments_outlined,
                        ),
                      ],
                      if (food.note != null && food.note!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Özel Not',
                          food.note!,
                          Icons.notes_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Donation eligibility status card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: donationCheck.isEligible
                        ? AppColors.primaryMint.withValues(alpha: 0.3)
                        : AppColors.warningBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: donationCheck.isEligible
                          ? AppColors.primaryMint
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        donationCheck.isEligible
                            ? Icons.volunteer_activism
                            : Icons.info_outline,
                        color: donationCheck.isEligible
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donationCheck.isEligible
                                  ? 'Bağışa Uygun: ${donationCheck.statusTag}'
                                  : 'Bağış Durumu: Uygun Değil',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: donationCheck.isEligible
                                    ? AppColors.primary
                                    : AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              donationCheck.reasons.join('\n'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Actions
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () async {
                      await ref
                          .read(foodsListProvider.notifier)
                          .consumeFood(food.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${food.name} başarıyla tüketildi olarak kaydedildi.'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                        context.pop();
                      }
                    },
                    icon: const Icon(Icons.check, size: 20),
                    label: const Text('Tükettim (Kurtarıldı)'),
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
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('İsraf Olarak İşaretle'),
                          content: Text(
                              '${food.name} tüketilemeden bozuldu mu? Bu işlem istatistiklere israf olarak yansıyacaktır.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('İptal'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.danger),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Evet, İsraf Oldu'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        await ref
                            .read(foodsListProvider.notifier)
                            .wasteFood(food.id, reason: 'Tarihi geçti / bozuldu');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ürün israf olarak kaydedildi.'),
                            ),
                          );
                          context.pop();
                        }
                      }
                    },
                    icon: const Icon(Icons.close, size: 20),
                    label: const Text('İsraf Oldu'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                    ),
                    onPressed: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Ürünü Sil'),
                          content: Text('${food.name} kaydını kalıcı olarak silmek istiyor musunuz?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('İptal'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.danger),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true && context.mounted) {
                        await ref
                            .read(foodsListProvider.notifier)
                            .deleteFood(food.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ürün envanterden silindi.')),
                          );
                          context.pop();
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('Kaydı Tamamen Sil'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          '$title: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
