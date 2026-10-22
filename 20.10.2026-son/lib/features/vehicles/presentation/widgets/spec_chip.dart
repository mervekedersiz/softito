import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';
import '../vehicle_labels.dart';

/// Small icon + label pill used for vehicle specs.
class SpecChip extends StatelessWidget {
  const SpecChip({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The three core specs (gearbox, fuel, seats) of a [Vehicle].
class VehicleSpecs extends StatelessWidget {
  const VehicleSpecs({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SpecChip(
          icon: vehicle.transmission.icon,
          label: vehicle.transmission.label,
        ),
        SpecChip(icon: vehicle.fuelType.icon, label: vehicle.fuelType.label),
        SpecChip(icon: Icons.event_seat, label: '${vehicle.seatCount} koltuk'),
      ],
    );
  }
}
