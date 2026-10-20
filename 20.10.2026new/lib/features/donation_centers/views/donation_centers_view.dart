import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/widgets/demo_label.dart';
import '../../../../core/widgets/empty_state.dart';
import '../controllers/donation_centers_controller.dart';
import '../models/donation_centers_state.dart';
import '../widgets/donation_center_card.dart';
import 'donation_center_detail_view.dart';

class DonationCentersView extends StatefulWidget {
  final DonationCentersController controller;
  final Function(DonationCenter center)? onPlanBooking;

  const DonationCentersView({
    super.key,
    required this.controller,
    this.onPlanBooking,
  });

  @override
  State<DonationCentersView> createState() => _DonationCentersViewState();
}

class _DonationCentersViewState extends State<DonationCentersView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.controller.value.searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.donationCentersTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: '6 Kurgusal Merkez'),
          ),
        ],
      ),
      body: ValueListenableBuilder<DonationCentersState>(
        valueListenable: widget.controller,
        builder: (context, state, child) {
          final centers = state.filteredCenters;
          final districts = [
            'Tümü',
            ...state.allCenters.map((c) => c.district).toSet().toList()..sort(),
          ];

          return Column(
            children: [
              // Search and Filter Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Merkez veya ilçe ara...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  widget.controller.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) => widget.controller.setSearchQuery(val),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: districts.map((district) {
                          final isSelected =
                              (state.filterDistrict == null &&
                                  district == 'Tümü') ||
                              (state.filterDistrict == district);

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(district),
                              selected: isSelected,
                              onSelected: (selected) {
                                widget.controller.setDistrictFilter(
                                  selected ? district : null,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Center List
              Expanded(
                child: centers.isEmpty
                    ? EmptyState(
                        title: 'Merkez Bulunamadı',
                        message:
                            'Arama kriterlerinize uygun bağış merkezi bulunamadı.',
                        actionLabel: 'Aramayı Temizle',
                        onAction: () {
                          _searchController.clear();
                          widget.controller.resetFilters();
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        itemCount: centers.length,
                        itemBuilder: (context, index) {
                          final c = centers[index];
                          return DonationCenterCard(
                            center: c,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => DonationCenterDetailView(
                                    center: c,
                                    onPlanBooking: () {
                                      Navigator.of(ctx).pop();
                                      widget.onPlanBooking?.call(c);
                                    },
                                  ),
                                ),
                              );
                            },
                            onPlanBooking: () {
                              widget.onPlanBooking?.call(c);
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
