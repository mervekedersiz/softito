import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/demo_notice_banner.dart';
import '../../../../core/widgets/responsive_wrap.dart';
import '../controllers/vehicle_controller.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_filter_bar.dart';

/// Vehicle gallery with filters and loading / empty / error states.
class VehicleListPage extends StatelessWidget {
  const VehicleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).vehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Araçlar'),
        actions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => IconButton(
              tooltip: 'Filtreleri temizle',
              onPressed: controller.filter.isActive
                  ? controller.clearFilter
                  : null,
              icon: const Icon(Icons.filter_alt_off),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => switch (controller.status) {
          LoadStatus.loading => const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Araçlar yükleniyor',
            ),
          ),
          LoadStatus.error => AppEmptyState(
            icon: Icons.cloud_off,
            title: 'Araçlar yüklenemedi',
            message: 'Bir sorun oluştu. Lütfen tekrar dene.',
            action: FilledButton.icon(
              onPressed: controller.load,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar dene'),
            ),
          ),
          LoadStatus.ready => _Results(controller: controller),
        },
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.controller});

  final VehicleController controller;

  @override
  Widget build(BuildContext context) {
    final vehicles = controller.visible;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DemoNoticeBanner(),
            ),
            const SizedBox(height: 12),
            const VehicleFilterBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                '${vehicles.length} araç bulundu',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: motionDuration(context),
              child: vehicles.isEmpty
                  ? AppEmptyState(
                      key: const ValueKey('empty'),
                      icon: Icons.search_off,
                      title: 'Sonuç bulunamadı',
                      message:
                          'Bu filtrelere uyan araç yok. '
                          'Filtreleri değiştirmeyi dene.',
                      action: OutlinedButton.icon(
                        onPressed: controller.clearFilter,
                        icon: const Icon(Icons.filter_alt_off),
                        label: const Text('Filtreleri temizle'),
                      ),
                    )
                  : Padding(
                      key: ValueKey(vehicles.map((v) => v.id).join(',')),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ResponsiveWrap(
                        children: [
                          for (final vehicle in vehicles)
                            VehicleCard(
                              vehicle: vehicle,
                              heroTag: 'list-${vehicle.id}',
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
