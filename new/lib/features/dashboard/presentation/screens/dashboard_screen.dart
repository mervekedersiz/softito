import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_status.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/food_thumbnail.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../../statistics/presentation/providers/statistics_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(kitchenBalanceProvider);
    final foodsAsync = ref.watch(foodsListProvider);
    final statsAsync = ref.watch(statisticsSummaryProvider);

    final foods = foodsAsync.value ?? [];
    final now = DateTime.now();

    // Urgent foods
    final urgentFoods = foods.where((f) {
      final urg = classifyDate(now, f.expiryDate);
      return urg == UrgencyStatus.today ||
          urg == UrgencyStatus.urgent ||
          urg == UrgencyStatus.expired;
    }).toList();

    return Scaffold(
      appBar: const AppHeader(subtitle: 'Özet'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mutfak Dengesi Card
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryMint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.eco_outlined,
                                color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Mutfak Dengesi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF28A745),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Buzdolabı 4°C İdeal',
                              style: TextStyle(
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
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                            text: 'Dolabınızda bugün tüketilmeyi bekleyen '),
                        TextSpan(
                          text: '${balance.criticalCount} kritik ürün',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.danger,
                          ),
                        ),
                        const TextSpan(text: ' bulunuyor.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Progress color bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: (balance.criticalCount > 0 ? balance.criticalCount : 1),
                          child: Container(height: 5, color: AppColors.danger),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: (balance.upcomingCount > 0 ? balance.upcomingCount : 1),
                          child: Container(height: 5, color: AppColors.warning),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: (balance.safeCount > 0 ? balance.safeCount : 1),
                          child: Container(height: 5, color: AppColors.safe),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Şef AI Chatbot Banner
            InkWell(
              onTap: () => context.push('/chef-ai'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005A36), Color(0xFF007A4D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF005A36).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.smart_toy_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Şef AI • Mutfak Chatbot',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.bolt, size: 14, color: Color(0xFFFFD166)),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Dolabındaki malzemelerle ne pişirebileceğini sor veya sohbet et',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFD7F4E5),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Dolabım & Kilerim Durumu Card
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
                          Icon(Icons.inventory_2_outlined,
                              size: 18, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Dolabım & Kilerim Durumu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Toplam ${balance.totalCount} Ürün',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Kritik
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.dangerBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 14, color: AppColors.danger),
                                  SizedBox(width: 4),
                                  Text(
                                    'Kritik',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${balance.criticalCount}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.danger,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Son 1–2 gün',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Yaklaşan
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded,
                                      size: 14, color: AppColors.warning),
                                  SizedBox(width: 4),
                                  Text(
                                    'Yaklaşan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${balance.upcomingCount}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.warning,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '3–5 gün',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Güvende
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.safeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 14, color: AppColors.safe),
                                  SizedBox(width: 4),
                                  Text(
                                    'Güvende',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.safe,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${balance.safeCount}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.safe,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '6+ gün var',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.safe,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Bu Ayki Bütçe Etkisi
            statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (stats) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.savings_outlined,
                                size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Bu Ayki Bütçe Etkisi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '%${stats.successRatePercent} Başarı',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KURTARILAN DEĞER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₺${stats.savedValue.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '✓ ${stats.savedCount} ürün zamanında tüketildi',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'İSRAF KAYBI',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.danger,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₺${stats.wastedValue.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.danger,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '↘ ${stats.wastedCount} parça israf oldu',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Acil Tüketim Rafı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined,
                        size: 18, color: AppColors.danger),
                    const SizedBox(width: 6),
                    const Text(
                      'Acil Tüketim Rafı',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ref.read(inventoryFilterProvider.notifier).reset();
                    ref.read(inventoryFilterProvider.notifier).toggleOnlyUrgent();
                    context.go('/inventory');
                  },
                  child: Text(
                    'Tümünü Gör (${urgentFoods.length})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            if (urgentFoods.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.safe),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Şu an acil tüketim bekleyen ürününüz bulunmuyor.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...urgentFoods.take(3).map((item) {
                final daysLeft = daysRemaining(now, item.expiryDate);
                final badgeLabel = daysLeft <= 0
                    ? 'Son Gün'
                    : (daysLeft == 1 ? 'Yarın (1 gün)' : '$daysLeft Gün Kaldı');

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
                      FoodThumbnail(
                        foodName: item.name,
                        category: item.category,
                        size: 38,
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
                                    '${item.name} ${item.quantity.toStringAsFixed(0)}${item.unit}',
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
                                    color: AppColors.dangerBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    badgeLabel,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${item.category.label} • ${item.storageLocation.label}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005A36),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () async {
                          await ref
                              .read(foodsListProvider.notifier)
                              .consumeFood(item.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} tüketildi.'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check, size: 14),
                        label: const Text('Tükettim', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 14),

            // Saklama Alanları
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saklama Alanları',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '3 Aktif Bölme',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStorageBox(
                        title: 'Buzdolabı',
                        count: balance.fridgeCount,
                        icon: Icons.kitchen,
                        color: const Color(0xFF007A4D),
                        onTap: () {
                          ref
                              .read(inventoryFilterProvider.notifier)
                              .setStorageLocation(StorageLocation.fridge);
                          context.go('/inventory');
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildStorageBox(
                        title: 'Dondurucu',
                        count: balance.freezerCount,
                        icon: Icons.ac_unit,
                        color: const Color(0xFF0A84FF),
                        onTap: () {
                          ref
                              .read(inventoryFilterProvider.notifier)
                              .setStorageLocation(StorageLocation.freezer);
                          context.go('/inventory');
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildStorageBox(
                        title: 'Kiler',
                        count: balance.pantryCount,
                        icon: Icons.shelves,
                        color: const Color(0xFFC86D24),
                        onTap: () {
                          ref
                              .read(inventoryFilterProvider.notifier)
                              .setStorageLocation(StorageLocation.pantry);
                          context.go('/inventory');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // "Bugün Ne Pişirsem?" Banner Link
            InkWell(
              onTap: () => context.go('/recipes'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCCE2FF)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.soup_kitchen_outlined,
                          color: Color(0xFF0A84FF), size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bugün Ne Pişirsem?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D3B66),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Acil süt ve mantarla 2 eşleşme',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A6B82),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Color(0xFF0A84FF)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // "Gıda Bağışı & Paylaşım" Banner Link (Added to showcase new feature!)
            InkWell(
              onTap: () => context.push('/donations'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.volunteer_activism_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gıda Bağışı & Paylaşım',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Aşevleri, dayanışma dolapları ve paket taslakları',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Big CTA: + Ürün Ekle
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  context.push('/products/new');
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Ürün Ekle',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageBox({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
