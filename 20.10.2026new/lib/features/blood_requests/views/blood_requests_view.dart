import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_group.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/widgets/demo_label.dart';
import '../../../../core/widgets/empty_state.dart';
import '../controllers/blood_requests_controller.dart';
import '../models/blood_requests_state.dart';
import '../widgets/blood_request_card.dart';
import 'blood_request_detail_view.dart';

class BloodRequestsView extends StatelessWidget {
  final BloodRequestsController controller;
  final DemoStore store;
  final Function(BloodRequest request)? onPlanDonation;

  const BloodRequestsView({
    super.key,
    required this.controller,
    required this.store,
    this.onPlanDonation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bloodRequestsTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Kurgusal Talepler'),
          ),
        ],
      ),
      body: ValueListenableBuilder<BloodRequestsState>(
        valueListenable: controller,
        builder: (context, state, child) {
          final requests = state.filteredSortedRequests;

          // Unique districts from all requests for filtering
          final districts = [
            'Tümü',
            ...state.allRequests.map((r) => r.district).toSet().toList()
              ..sort(),
          ];

          return Column(
            children: [
              // Filter and Sorting Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Blood Group Filter Dropdown
                      DropdownButton<BloodGroup?>(
                        value: state.filterBloodGroup,
                        hint: const Text(
                          'Grup: Tümü',
                          style: TextStyle(fontSize: 12),
                        ),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Grup: Tümü',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ...BloodGroup.values
                              .where((g) => g != BloodGroup.unknown)
                              .map((g) {
                                return DropdownMenuItem(
                                  value: g,
                                  child: Text(
                                    'Grup: ${g.label}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }),
                        ],
                        onChanged: (val) => controller.setBloodGroupFilter(val),
                      ),
                      const SizedBox(width: 8),

                      // District Filter Dropdown
                      DropdownButton<String>(
                        value: state.filterDistrict ?? 'Tümü',
                        underline: const SizedBox(),
                        items: districts.map((d) {
                          return DropdownMenuItem(
                            value: d,
                            child: Text(
                              'İlçe: $d',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => controller.setDistrictFilter(val),
                      ),
                      const SizedBox(width: 8),

                      // Sort Option Dropdown
                      DropdownButton<RequestSortOption>(
                        value: state.sortOption,
                        underline: const SizedBox(),
                        items: RequestSortOption.values.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              s.label,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) controller.setSortOption(val);
                        },
                      ),
                      const SizedBox(width: 8),

                      if (state.filterBloodGroup != null ||
                          state.filterDistrict != null ||
                          state.filterUrgency != null)
                        ActionChip(
                          avatar: const Icon(Icons.close_rounded, size: 14),
                          label: const Text(
                            'Sıfırla',
                            style: TextStyle(fontSize: 11),
                          ),
                          onPressed: () => controller.resetFilters(),
                        ),
                    ],
                  ),
                ),
              ),

              // Request List
              Expanded(
                child: requests.isEmpty
                    ? EmptyState(
                        title: 'Eşleşen Talep Bulunamadı',
                        message:
                            'Seçili filtre kriterlerine uygun kan ihtiyacı bulunmuyor.',
                        actionLabel: 'Filtreleri Temizle',
                        onAction: () => controller.resetFilters(),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final req = requests[index];
                          return BloodRequestCard(
                            request: req,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => BloodRequestDetailView(
                                    request: req,
                                    store: store,
                                    onPlanDonation: () {
                                      Navigator.of(ctx).pop();
                                      onPlanDonation?.call(req);
                                    },
                                  ),
                                ),
                              );
                            },
                            onPlanDonation: () {
                              onPlanDonation?.call(req);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
