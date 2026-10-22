import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_vehicle_image.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../bookings/presentation/pages/booking_form_page.dart';
import '../../domain/entities/vehicle.dart';
import '../vehicle_labels.dart';
import '../widgets/availability_badge.dart';
import '../widgets/availability_strip.dart';
import '../widgets/favorite_button.dart';
import '../widgets/fuel_gauge_widget.dart';
import '../widgets/spec_chip.dart';

/// Vehicle details with gallery image, specs, "Depoyu Söylüyor" gauge,
/// Sahibinden expert status, and instant rental / telemetry actions.
class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({
    required this.vehicle,
    required this.heroTag,
    super.key,
  });

  final Vehicle vehicle;
  final String heroTag;

  void _rent(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingFormPage(vehicle: vehicle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currency = AppScope.of(context).currency;

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.name),
        actions: [
          FavoriteButton(
            vehicleId: vehicle.id,
            vehicleName: vehicle.name,
            overlay: false,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Hero(
                  tag: heroTag,
                  child: AppVehicleImage(
                    asset: vehicle.imageAsset,
                    semanticLabel: '${vehicle.name} görseli (temsili)',
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vehicle.modelYear} • ${vehicle.locationDistrict} • ${vehicle.expertStatus}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: currency,
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currency.format(vehicle.dailyPrice),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'günlük (demo fiyat)',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AvailabilityBadge(isAvailable: vehicle.isAvailable),
              const SizedBox(height: 16),
              // "Depoyu Söylüyor" prominent visual component
              FuelGaugeWidget(vehicle: vehicle),
              const SizedBox(height: 16),
              Text(vehicle.description, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Özellikler'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SpecChip(
                    icon: vehicle.transmission.icon,
                    label: vehicle.transmission.label,
                  ),
                  SpecChip(
                    icon: vehicle.fuelType.icon,
                    label: vehicle.fuelType.label,
                  ),
                  SpecChip(
                    icon: Icons.event_seat,
                    label: '${vehicle.seatCount} koltuk',
                  ),
                  SpecChip(
                    icon: Icons.directions_car,
                    label: vehicle.category.label,
                  ),
                  SpecChip(
                    icon: Icons.speed,
                    label: '${vehicle.mileageKm} km',
                  ),
                  SpecChip(
                    icon: Icons.verified,
                    label: vehicle.expertStatus,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Live Telemetry / Tracking Shortcut Card
              Card(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.black87,
                        child: Icon(Icons.radar, color: Colors.cyanAccent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Canlı Telemetri & GPS Takip',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Gerçek zamanlı hız, harita ve kamera yayını simülatörü',
                              style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: () => AppRouter.pushLiveTracking(context),
                        child: const Text('İzle'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Örnek müsaitlik (demo)'),
              const SizedBox(height: 4),
              Text(
                'Önümüzdeki 7 gün için temsili durum.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              AvailabilityStrip(vehicle: vehicle),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: vehicle.isAvailable ? () => _rent(context) : null,
                      icon: Icon(vehicle.isAvailable ? Icons.key : Icons.block),
                      label: Text(
                        vehicle.isAvailable ? 'Kirala' : 'Şu an müsait değil',
                      ),
                    ),
                  ),
                  if (vehicle.isAvailable) ...[
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      tooltip: 'Doğrudan Kredi Kartı ile Öde',
                      icon: const Icon(Icons.credit_card),
                      onPressed: () {
                        AppRouter.pushPayment(
                          context,
                          vehicle: vehicle,
                          totalAmountTry: vehicle.dailyPrice,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
