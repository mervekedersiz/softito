import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/blood_measurement.dart';
import '../../../../core/widgets/demo_label.dart';
import '../controllers/blood_values_controller.dart';
import '../models/blood_values_state.dart';
import '../widgets/blood_value_chart.dart';
import '../widgets/measurement_form.dart';

class BloodValuesView extends StatelessWidget {
  final BloodValuesController controller;

  const BloodValuesView({super.key, required this.controller});

  void _showAddSheet(BuildContext context, MeasurementType initialType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return MeasurementFormSheet(
          initialType: initialType,
          onSave:
              ({
                required type,
                required rawValue,
                required measuredAt,
                required source,
                rawMin,
                rawMax,
              }) {
                final ok = controller.addMeasurement(
                  type: type,
                  rawValue: rawValue,
                  measuredAt: measuredAt,
                  source: source,
                  rawMin: rawMin,
                  rawMax: rawMax,
                );
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Yeni ölçüm başarıyla eklendi.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bloodValuesTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Kişisel Takip'),
          ),
        ],
      ),
      body: ValueListenableBuilder<BloodValuesState>(
        valueListenable: controller,
        builder: (context, state, child) {
          final items = state.filteredSortedMeasurements;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Segmented Indicator Buttons
              SegmentedButton<MeasurementType>(
                segments: MeasurementType.values.map((t) {
                  return ButtonSegment(value: t, label: Text(t.label));
                }).toList(),
                selected: {state.selectedType},
                onSelectionChanged: (newSelection) {
                  controller.selectType(newSelection.first);
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(height: 16),

              // Chart Container Card
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
                                '${state.selectedType.label} Eğilimi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                'Birim: ${state.selectedType.standardUnit}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${items.length} Ölçüm',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bloodRed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      BloodValueChart(
                        measurements: items,
                        selectedMeasurement: state.selectedMeasurement,
                        onSelect: (m) => controller.selectMeasurement(m),
                        height: 190,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Grafikteki bir noktaya dokunarak ölçüm detaylarını inceleyebilirsiniz.',
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
              ),
              const SizedBox(height: 12),

              // Selected Measurement Detail Card
              if (state.selectedMeasurement != null)
                _buildSelectedMeasurementCard(
                  context,
                  state.selectedMeasurement!,
                  isDark,
                ),

              const SizedBox(height: 12),

              // Action button to add measurement
              ElevatedButton.icon(
                onPressed: () => _showAddSheet(context, state.selectedType),
                icon: const Icon(Icons.add_rounded),
                label: Text('${state.selectedType.label} Ölçümü Ekle'),
              ),
              const SizedBox(height: 16),

              // Chronological Measurement List for Accessibility & Clarity
              Text(
                'Ölçüm Geçmişi (Tarih Sıralı)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),

              if (items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        AppStrings.noMeasurements,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                )
              else
                ...items.map((m) => _buildMeasurementTile(context, m, isDark)),

              const SizedBox(height: 16),

              // Medical Disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSubtle
                      : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppStrings.bloodValuesDisclaimer,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedMeasurementCard(
    BuildContext context,
    BloodMeasurement m,
    bool isDark,
  ) {
    return Card(
      color: isDark
          ? AppColors.darkSurfaceSubtle
          : AppColors.softRed.withAlpha(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.bloodRed, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seçili Ölçüm Detayı',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.urgent,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.deleteMeasurement(m.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ölçüm kaydı silindi.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${m.value} ${m.unit}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.bloodRed,
                  ),
                ),
                Text(
                  '${m.measuredAt.day}.${m.measuredAt.month}.${m.measuredAt.year}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Kaynak: ${m.source}',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppStrings.referenceRange}: ${m.referenceRangeText}',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
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

  Widget _buildMeasurementTile(
    BuildContext context,
    BloodMeasurement m,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          '${m.value} ${m.unit}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          '${m.measuredAt.day}.${m.measuredAt.month}.${m.measuredAt.year} — ${m.source}',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          onPressed: () {
            controller.deleteMeasurement(m.id);
          },
        ),
        onTap: () => controller.selectMeasurement(m),
      ),
    );
  }
}
