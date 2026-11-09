import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../providers/statistics_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(statisticsSummaryProvider);
    final eventsAsync = ref.watch(consumptionEventsProvider);

    return Scaffold(
      appBar: const AppHeader(subtitle: 'İstatistik'),
      body: summaryAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('İstatistikler yüklenemedi: $err'),
        ),
        data: (stats) {
          final events = eventsAsync.value ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tasarruf Analizi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Doğrulanmış hanehalkı gıda verileri',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 13, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text(
                            'Ekim 2024',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2 Big Cards
                Row(
                  children: [
                    // Kurtarılan
                    Expanded(
                      child: Container(
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
                                const Text(
                                  'KURTARILAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryMint,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.savings_outlined,
                                      size: 14, color: AppColors.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₺${stats.savedValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryMint,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '↗ %${stats.successRatePercent} Başarı Oranı',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Zamanında tüketildi',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // İsraf Olan
                    Expanded(
                      child: Container(
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
                                const Text(
                                  'İSRAF OLAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.dangerBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.delete_outline,
                                      size: 14, color: AppColors.danger),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₺${stats.wastedValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.danger,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.dangerBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '↑ ${stats.wastedCount} Ürün',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.danger,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tüketilemeden bozuldu',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Disclaimer Info Banner
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3FAF6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fiyatı girilmemiş ${stats.unpricedEventsCount} tüketim toplam tutara dahil edilmemiştir. Sadece fiyatı teyitli kalemler işlenir.',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Haftalık Tüketim Dengesi Bar Chart Card
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Haftalık Tüketim Dengesi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Kurtarılan (adet) vs. İsraf',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Kurtarılan',
                                  style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('İsraf',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Custom Weekly Bars matching Image 4
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildDayBar('Pzt', 3, 1),
                          _buildDayBar('Sal', 4, 0),
                          _buildDayBar('Çar', 2, 1),
                          _buildDayBar('Per', 4, 0),
                          _buildDayBar('Cum', 3, 0),
                          _buildDayBar('Cmt', 5, 1),
                          _buildDayBar('Paz', 4, 0),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Kategori Dağılımı Card
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
                            'Kategori Dağılımı',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Tüketilen Ürünler',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            Expanded(flex: 42, child: Container(height: 6, color: const Color(0xFF005A36))),
                            const SizedBox(width: 2),
                            Expanded(flex: 28, child: Container(height: 6, color: const Color(0xFF20C997))),
                            const SizedBox(width: 2),
                            Expanded(flex: 18, child: Container(height: 6, color: const Color(0xFFC86D24))),
                            const SizedBox(width: 2),
                            Expanded(flex: 12, child: Container(height: 6, color: const Color(0xFF6C757D))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildCatPercent('Süt Ürünleri', 'En çok kurtarılan', '%42', const Color(0xFF005A36)),
                          const SizedBox(width: 8),
                          _buildCatPercent('Sebze & Meyve', '', '%28', const Color(0xFF20C997)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCatPercent('Et & Tavuk', '', '%18', const Color(0xFFC86D24)),
                          const SizedBox(width: 8),
                          _buildCatPercent('Kiler & Bakliyat', '', '%12', const Color(0xFF6C757D)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Tüketim Olayları Günlüğü
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.history, size: 18, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Tüketim Olayları Günlüğü',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Son ${events.length} İşlem',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (events.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text('Henüz kaydedilmiş tüketim olayı yok.'),
                  )
                else
                  ...events.take(4).map((ev) {
                    final isSaved = !ev.isWasted;
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
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSaved ? AppColors.primaryMint : AppColors.dangerBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved ? Icons.check : Icons.close,
                              size: 16,
                              color: isSaved ? AppColors.primary : AppColors.danger,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ev.foodName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ev.note ?? '${ev.storageLocation.label} • ${ev.category.label}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ev.price != null
                                    ? '${isSaved ? '+' : '-'}₺${ev.price!.toStringAsFixed(2)}'
                                    : 'Fiyatsız',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isSaved ? AppColors.primary : AppColors.danger,
                                ),
                              ),
                              Text(
                                isSaved ? 'Tüketildi' : 'İsraf Oldu',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSaved ? AppColors.primary : AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 14),

                // Export JSON Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005A36),
                    ),
                    onPressed: () {
                      final jsonString = jsonEncode({
                        'exportDate': DateTime.now().toIso8601String(),
                        'summary': {
                          'savedValue': stats.savedValue,
                          'wastedValue': stats.wastedValue,
                          'savedCount': stats.savedCount,
                          'wastedCount': stats.wastedCount,
                          'successRate': stats.successRatePercent,
                        },
                        'events': events.map((e) => {
                          'id': e.id,
                          'foodName': e.foodName,
                          'quantity': e.quantity,
                          'unit': e.unit,
                          'price': e.price,
                          'isWasted': e.isWasted,
                          'timestamp': e.timestamp.toIso8601String(),
                        }).toList(),
                      });

                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('İstatistik Raporu (JSON)'),
                          content: SingleChildScrollView(
                            child: SelectableText(
                              jsonString,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: jsonString));
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('JSON panoya kopyalandı!')),
                                );
                              },
                              child: const Text('Panoya Kopyala'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Kapat'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 20),
                    label: const Text(
                      'İstatistik Raporunu Dışa Aktar (JSON)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Akıllı Hatırlatıcı & Bildirimler
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Akıllı Hatırlatıcı & Bildirimler',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 12),
                                const ListTile(
                                  leading: Icon(Icons.notifications_active_outlined,
                                      color: AppColors.primary),
                                  title: Text('Son Kullanma Eşikleri'),
                                  subtitle: Text(
                                      '1 gün ve 3 gün öncesinde yerel uyarı bülteni aktif.'),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.calendar_month_outlined,
                                      color: AppColors.primary),
                                  title: Text('Haftalık İsraf Özeti'),
                                  subtitle: Text(
                                      'Her Pazar akşamı haftalık tasarruf raporu bildirimi.'),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Bildirim tercihleri güncellendi.')),
                                      );
                                    },
                                    child: const Text('Kaydet ve Kapat'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.notifications_outlined, size: 20, color: AppColors.primary),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Akıllı Hatırlatıcı & Bildirimler',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Son kullanma eşikleri ve haftalık bülten',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayBar(String day, int saved, int wasted) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 10,
              height: (saved * 14.0).clamp(10, 80),
              decoration: BoxDecoration(
                color: const Color(0xFF005A36),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 2),
            if (wasted > 0)
              Container(
                width: 10,
                height: (wasted * 12.0).clamp(6, 40),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCatPercent(String title, String subtitle, String percent, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                  ),
              ],
            ),
            Text(
              percent,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
