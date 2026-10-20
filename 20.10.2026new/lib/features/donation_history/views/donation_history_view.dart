import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/donation_record.dart';
import '../../../../core/widgets/demo_label.dart';
import '../../../../core/widgets/empty_state.dart';
import '../controllers/donation_history_controller.dart';
import '../models/donation_history_state.dart';
import '../widgets/donation_bar_chart.dart';
import '../widgets/life_chain_timeline.dart';

class DonationHistoryView extends StatelessWidget {
  final DonationHistoryController controller;
  final DemoStore store;

  const DonationHistoryView({
    super.key,
    required this.controller,
    required this.store,
  });

  void _showDetailModal(BuildContext context, DonationRecord record) {
    final center = store.getCenterById(record.centerId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bağış Kaydı Detayı',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const DemoLabel(text: 'Ders Senaryosu'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Merkez: ${center?.name ?? record.centerId}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tarih: ${record.scheduledAt.day}.${record.scheduledAt.month}.${record.scheduledAt.year} — ${record.scheduledAt.hour.toString().padLeft(2, '0')}:${record.scheduledAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tür: ${record.source.label}',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const Divider(height: 24),

              if (record.isCompleted) ...[
                LifeChainTimeline(events: record.trackingEvents),
                const SizedBox(height: 12),
              ],

              if (record.isPlanned) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.softRed.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    AppStrings.markCompletedNotice,
                    style: TextStyle(fontSize: 11.5, height: 1.3),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.cancelDonation(record.id);
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.bookingCancelled),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.urgent,
                          side: const BorderSide(color: AppColors.urgent),
                        ),
                        child: const Text('Randevuyu İptal Et'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.completeDemoDonation(record.id);
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Demo bağış tamamlandı ve Hayat Zinciri güncellendi!',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(AppStrings.markCompletedDemo),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.historyTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Bağış Kayıtları'),
          ),
        ],
      ),
      body: ValueListenableBuilder<DonationHistoryState>(
        valueListenable: controller,
        builder: (context, state, child) {
          final donations = state.filteredDonations;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Monthly Bar Chart Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.monthlyDonationSummary,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                'Son 6 ayda tamamlanan demo bağışlar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bloodRed.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${state.completedDonations.length} Tamamlanan',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bloodRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DonationBarChart(
                        monthlyData: state.monthlyCompletedCounts,
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Status Summary Counts Row
              Row(
                children: [
                  Expanded(
                    child: _buildCountCard(
                      'Tamamlanan',
                      '${state.completedDonations.length}',
                      AppColors.success,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCountCard(
                      'Planlanan',
                      '${state.plannedDonations.length}',
                      AppColors.bloodRed,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCountCard(
                      'İptal Edilen',
                      '${state.cancelledDonations.length}',
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Segmented Status Filters
              SegmentedButton<DonationStatus?>(
                segments: const [
                  ButtonSegment(
                    value: null,
                    label: Text('Tümü', style: TextStyle(fontSize: 11.5)),
                  ),
                  ButtonSegment(
                    value: DonationStatus.completed,
                    label: Text('Tamamlanan', style: TextStyle(fontSize: 11.5)),
                  ),
                  ButtonSegment(
                    value: DonationStatus.planned,
                    label: Text('Planlanan', style: TextStyle(fontSize: 11.5)),
                  ),
                  ButtonSegment(
                    value: DonationStatus.cancelled,
                    label: Text('İptal', style: TextStyle(fontSize: 11.5)),
                  ),
                ],
                selected: {state.filterStatus},
                onSelectionChanged: (set) =>
                    controller.setFilterStatus(set.first),
              ),
              const SizedBox(height: 12),

              // Donation Records List
              if (donations.isEmpty)
                const EmptyState(
                  title: 'Kayıt Bulunamadı',
                  message: 'Seçili filtreye uygun bağış kaydı bulunmuyor.',
                )
              else
                ...donations.map((d) => _buildDonationTile(context, d, isDark)),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCountCard(String label, String count, Color color, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationTile(
    BuildContext context,
    DonationRecord record,
    bool isDark,
  ) {
    final center = store.getCenterById(record.centerId);

    Color statusColor;
    IconData statusIcon;
    switch (record.status) {
      case DonationStatus.completed:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        break;
      case DonationStatus.planned:
        statusColor = AppColors.bloodRed;
        statusIcon = Icons.calendar_today_rounded;
        break;
      case DonationStatus.cancelled:
        statusColor = isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
        statusIcon = Icons.cancel_outlined;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Text(
          center?.name ?? record.centerId,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${record.scheduledAt.day}.${record.scheduledAt.month}.${record.scheduledAt.year} • ${record.source.label}',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(20),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            record.status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
        onTap: () => _showDetailModal(context, record),
      ),
    );
  }
}
