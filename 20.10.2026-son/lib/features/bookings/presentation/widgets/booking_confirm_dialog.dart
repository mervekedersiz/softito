import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/services/rental_pricing.dart';

/// Asks the user to confirm the rental summary. Resolves to `true` only when
/// the user confirms; cancel or dismiss resolves to `false` / `null`.
Future<bool?> showBookingConfirmDialog(
  BuildContext context, {
  required Vehicle vehicle,
  required String pickupLocation,
  required String returnLocation,
  required DateTime startAt,
  required DateTime endAt,
}) {
  final duration = endAt.difference(startAt);
  final total = RentalPricing.estimatedTotal(
    duration: duration,
    dailyPrice: vehicle.dailyPrice,
  );

  return showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        icon: const Icon(Icons.fact_check_outlined),
        title: const Text('Talebi onayla'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(theme, 'Araç', vehicle.name),
              _line(theme, 'Alış', pickupLocation),
              _line(theme, 'Teslim', returnLocation),
              _line(theme, 'Başlangıç', formatDateTime(startAt)),
              _line(theme, 'Bitiş', formatDateTime(endAt)),
              _line(
                theme,
                'Süre',
                '${formatDuration(duration)} '
                    '(${RentalPricing.billableDays(duration)} gün ücretlenir)',
              ),
              _line(theme, 'Tahmini tutar', formatLira(total)),
              const SizedBox(height: 12),
              Text(
                'Bu bir demo taleptir. Gerçek rezervasyon veya ödeme '
                'yapılmaz.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Demo talebi oluştur'),
          ),
        ],
      );
    },
  );
}

Widget _line(ThemeData theme, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
