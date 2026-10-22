import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ticket_card.dart';
import '../../domain/services/booking_validator.dart';
import '../../domain/services/rental_pricing.dart';

/// Receipt-style live price estimate shown on the rental form.
///
/// Shows a hint until the selected range is valid, then the total computed by
/// [RentalPricing] (every started 24-hour block is one billable day).
class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({
    required this.dailyPrice,
    required this.start,
    required this.end,
    super.key,
  });

  final int dailyPrice;
  final DateTime? start;
  final DateTime? end;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isValid = start != null && BookingValidator.end(end, start) == null;
    final duration = isValid ? end!.difference(start!) : null;

    return Semantics(
      container: true,
      liveRegion: true,
      child: TicketCard(
        top: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tahmini tutar (demo)',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                duration == null
                    ? '—'
                    : formatLira(
                        RentalPricing.estimatedTotal(
                          duration: duration,
                          dailyPrice: dailyPrice,
                        ),
                      ),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        bottom: Padding(
          padding: const EdgeInsets.all(20),
          child: duration == null
              ? Text(
                  'Geçerli bir başlangıç ve bitiş seçtiğinde süre ve '
                  'tutar burada görünür.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                )
              : Column(
                  children: [
                    _Row('Süre', formatDuration(duration)),
                    _Row(
                      'Ücretlenen gün',
                      '${RentalPricing.billableDays(duration)} gün',
                    ),
                    _Row('Günlük fiyat', formatLira(dailyPrice)),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
