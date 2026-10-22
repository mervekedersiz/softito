import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_filter.dart';
import '../vehicle_labels.dart';
import 'price_filter_sheet.dart';

/// Horizontally scrolling row of filter chips: gearbox, fuel and price.
class VehicleFilterBar extends StatelessWidget {
  const VehicleFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).vehicles;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final filter = controller.filter;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final value in Transmission.values)
                _chip(
                  label: value.label,
                  selected: filter.transmission == value,
                  onSelected: (on) => controller.updateFilter(
                    filter.withTransmission(on ? value : null),
                  ),
                ),
              for (final value in FuelType.values)
                _chip(
                  label: value.label,
                  icon: value.icon,
                  selected: filter.fuelType == value,
                  onSelected: (on) => controller.updateFilter(
                    filter.withFuelType(on ? value : null),
                  ),
                ),
              _chip(
                label: _priceLabel(filter),
                icon: Icons.payments_outlined,
                selected: filter.hasPriceFilter,
                onSelected: (_) => showPriceFilterSheet(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        avatar: icon == null ? null : Icon(icon, size: 18),
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }

  static String _priceLabel(VehicleFilter filter) {
    if (!filter.hasPriceFilter) return 'Fiyat';
    final min = filter.minPrice == null ? '' : formatLira(filter.minPrice!);
    final max = filter.maxPrice == null ? '' : formatLira(filter.maxPrice!);
    return '$min – $max';
  }
}
