import 'package:flutter/material.dart';
import '../../domain/entities/vehicle.dart';

/// Visual gauge clearly displaying exact tank or battery status ("Depoyu Söylüyor").
class FuelGaugeWidget extends StatelessWidget {
  const FuelGaugeWidget({required this.vehicle, this.compact = false, super.key});

  final Vehicle vehicle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isElectric = vehicle.fuelType == FuelType.electric;
    final percent = vehicle.fuelLevelPercent;

    Color gaugeColor;
    if (percent >= 60) {
      gaugeColor = const Color(0xFF10B981); // Emerald Green
    } else if (percent >= 30) {
      gaugeColor = const Color(0xFFF59E0B); // Amber Warning
    } else {
      gaugeColor = const Color(0xFFEF4444); // Red Low
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: gaugeColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: gaugeColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isElectric ? Icons.bolt : Icons.local_gas_station, size: 14, color: gaugeColor),
            const SizedBox(width: 4),
            Text(
              '%$percent ${isElectric ? "Şarj" : "Depo"}',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: gaugeColor),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gaugeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gaugeColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(isElectric ? Icons.electric_car : Icons.local_gas_station, size: 18, color: gaugeColor),
                  const SizedBox(width: 6),
                  Text(
                    isElectric ? 'Batarya Seviyesi (Depo)' : 'Yakıt Deposu Durumu',
                    style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '%$percent',
                style: TextStyle(fontWeight: FontWeight.w900, color: gaugeColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent / 100.0,
              minHeight: 8,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicle.fuelOrBatteryDescription,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                'Menzil: ${vehicle.rangeKm} km',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
