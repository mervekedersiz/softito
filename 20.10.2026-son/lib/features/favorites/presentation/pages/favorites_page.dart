import 'package:flutter/material.dart';

import '../../../../app/app_destination.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/responsive_wrap.dart';
import '../../../vehicles/presentation/widgets/vehicle_card.dart';

/// Vehicles the user marked as favorite during this session.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: ListenableBuilder(
        listenable: Listenable.merge([deps.favorites, deps.vehicles]),
        builder: (context, _) {
          final favorites = deps.vehicles.all
              .where((v) => deps.favorites.isFavorite(v.id))
              .toList();
          if (favorites.isEmpty) {
            return AppEmptyState(
              icon: Icons.favorite_border,
              title: 'Favori araç yok',
              message:
                  'Beğendiğin araçların kalp simgesine dokun, '
                  'burada hızlıca ulaş.',
              action: FilledButton.icon(
                onPressed: () => deps.tab.value = AppDestination.vehicles,
                icon: const Icon(Icons.directions_car),
                label: const Text('Araçlara göz at'),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  ResponsiveWrap(
                    children: [
                      for (final vehicle in favorites)
                        VehicleCard(
                          vehicle: vehicle,
                          heroTag: 'fav-${vehicle.id}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
