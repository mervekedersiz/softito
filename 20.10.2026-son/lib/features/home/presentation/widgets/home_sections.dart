import 'package:flutter/material.dart';

import '../../../../app/app_destination.dart';
import '../../../../app/app_scope.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/entities/vehicle_filter.dart';
import '../../../vehicles/presentation/controllers/vehicle_controller.dart';
import '../../../vehicles/presentation/vehicle_labels.dart';
import '../../../vehicles/presentation/widgets/vehicle_card.dart';

/// Quick-pick chips that open the vehicle list with a filter applied.
class CategoryShortcuts extends StatelessWidget {
  const CategoryShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);

    void open(VehicleFilter filter) {
      deps.vehicles.updateFilter(filter);
      deps.tab.value = AppDestination.vehicles;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChip(
          avatar: Icon(FuelType.electric.icon, size: 18),
          label: Text(FuelType.electric.label),
          onPressed: () =>
              open(const VehicleFilter(fuelType: FuelType.electric)),
        ),
        ActionChip(
          avatar: Icon(FuelType.hybrid.icon, size: 18),
          label: Text(FuelType.hybrid.label),
          onPressed: () => open(const VehicleFilter(fuelType: FuelType.hybrid)),
        ),
        ActionChip(
          avatar: Icon(Transmission.automatic.icon, size: 18),
          label: Text(Transmission.automatic.label),
          onPressed: () =>
              open(const VehicleFilter(transmission: Transmission.automatic)),
        ),
        ActionChip(
          avatar: Icon(Transmission.manual.icon, size: 18),
          label: Text(Transmission.manual.label),
          onPressed: () =>
              open(const VehicleFilter(transmission: Transmission.manual)),
        ),
      ],
    );
  }
}

/// Horizontally scrolling cards of currently available vehicles.
class PopularVehicles extends StatelessWidget {
  const PopularVehicles({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).vehicles;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        switch (controller.status) {
          case LoadStatus.loading:
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Popüler araçlar yükleniyor',
                ),
              ),
            );
          case LoadStatus.error:
            return const Text('Popüler araçlar yüklenemedi.');
          case LoadStatus.ready:
            final popular = controller.all
                .where((v) => v.isAvailable)
                .take(3)
                .toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final vehicle in popular)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 280,
                          child: VehicleCard(
                            vehicle: vehicle,
                            heroTag: 'home-${vehicle.id}',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
