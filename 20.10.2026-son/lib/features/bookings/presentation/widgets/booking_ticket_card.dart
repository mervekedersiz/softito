import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ticket_card.dart';
import '../../domain/entities/booking.dart';

/// A demo booking drawn as a ticket: route on top, dates and price below.
class BookingTicketCard extends StatelessWidget {
  const BookingTicketCard({required this.booking, super.key});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      container: true,
      label:
          '${booking.vehicleName}, demo talep ${booking.id}. '
          '${booking.pickupLocation} konumundan ${booking.returnLocation} '
          'konumuna. ${formatDateTime(booking.startAt)} ile '
          '${formatDateTime(booking.endAt)} arası. '
          '${booking.billableDays} gün, ${formatLira(booking.estimatedTotal)}.',
      excludeSemantics: true,
      child: TicketCard(
        top: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.vehicleName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        'Demo talep',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Stop(
                icon: Icons.trip_origin,
                label: booking.pickupLocation,
                time: formatDateTime(booking.startAt),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 11),
                child: SizedBox(
                  height: 16,
                  child: VerticalDivider(
                    width: 2,
                    thickness: 2,
                    color: colors.outlineVariant,
                  ),
                ),
              ),
              _Stop(
                icon: Icons.flag,
                label: booking.returnLocation,
                time: formatDateTime(booking.endAt),
              ),
            ],
          ),
        ),
        bottom: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.id,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '${booking.billableDays} gün ücretlendi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatLira(booking.estimatedTotal),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stop extends StatelessWidget {
  const _Stop({required this.icon, required this.label, required this.time});

  final IconData icon;
  final String label;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
