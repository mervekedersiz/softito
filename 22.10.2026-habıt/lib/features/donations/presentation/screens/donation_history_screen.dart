import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../providers/donation_providers.dart';

class DonationHistoryScreen extends ConsumerWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(donationPackagesProvider);

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Bağış Geçmişi & Taslaklar',
        showBackButton: true,
      ),
      body: packagesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Yükleme hatası: $err'),
        ),
        data: (packages) {
          if (packages.isEmpty) {
            return EmptyStateView(
              icon: Icons.history,
              title: 'Henüz Bağış Kaydı Yok',
              description:
                  'Henüz oluşturulmuş bir bağış taslağı veya tamamlanmış teslimat bulunmuyor.',
              buttonText: '+ Yeni Paket Oluştur',
              onButtonPressed: () => context.push('/donations/drafts/new'),
            );
          }

          final completed = packages.where((p) => p.status == DonationStatus.completedLocally).toList();
          final drafts = packages.where((p) => p.status == DonationStatus.draft).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryMint.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryMint),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.volunteer_activism,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hane İçi Dayanışma Özeti',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${completed.length} Tamamlanmış Teslimat • ${drafts.length} Aktif Taslak',
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
              const SizedBox(height: 20),

              if (drafts.isNotEmpty) ...[
                const Text(
                  'Aktif Taslaklar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                ...drafts.map((d) => _buildPackageCard(context, d, false)),
                const SizedBox(height: 16),
              ],

              if (completed.isNotEmpty) ...[
                const Text(
                  'Tamamlanan Yerel Teslimatlar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                ...completed.map((d) => _buildPackageCard(context, d, true)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, dynamic package, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          context.push('/donations/drafts/${package.id}');
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.safeBg : AppColors.warningBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.edit_note,
                color: isCompleted ? AppColors.safe : AppColors.warning,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${package.itemIds.length} Ürün • ${package.targetCenterName ?? "Genel"}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isCompleted && package.completedAt != null
                        ? 'Teslim Tarihi: ${DateFormatter.toShortDate(package.completedAt!)}'
                        : 'Oluşturulma: ${DateFormatter.toShortDate(package.createdAt)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
