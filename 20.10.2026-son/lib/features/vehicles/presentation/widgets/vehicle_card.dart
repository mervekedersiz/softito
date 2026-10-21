import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/widgets/app_vehicle_image.dart';
import '../../domain/entities/vehicle.dart';
import '../pages/vehicle_detail_page.dart';
import 'availability_badge.dart';
import 'favorite_button.dart';
import 'fuel_gauge_widget.dart';
import 'spec_chip.dart';

/// Gallery card: image with dynamic currency price tag, favorite button, and "Depoyu söylüyor" status.
class VehicleCard extends StatelessWidget {
  const VehicleCard({required this.vehicle, required this.heroTag, super.key});

  final Vehicle vehicle;
  final String heroTag;

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VehicleDetailPage(vehicle: vehicle, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currency = AppScope.of(context).currency;

    return Card(
      child: InkWell(
        onTap: () => _open(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: heroTag,
                  child: AppVehicleImage(
                    asset: vehicle.imageAsset,
                    semanticLabel: '${vehicle.name} görseli (temsili)',
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    vehicleId: vehicle.id,
                    vehicleName: vehicle.name,
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: ListenableBuilder(
                    listenable: currency,
                    builder: (context, _) => _PriceTag(
                      formattedPrice: currency.format(vehicle.dailyPrice),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      // "Depoyu Söylüyor" Compact Badge
                      FuelGaugeWidget(vehicle: vehicle, compact: true),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${vehicle.modelYear} • ${vehicle.bodyType} • ${vehicle.locationDistrict}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  VehicleSpecs(vehicle: vehicle),
                  const SizedBox(height: 12),
                  AvailabilityBadge(isAvailable: vehicle.isAvailable),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.formattedPrice});

  final String formattedPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: formattedPrice,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              TextSpan(
                text: ' / gün',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
