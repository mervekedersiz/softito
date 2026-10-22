import 'package:flutter/material.dart';

import '../../../../app/app_destination.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/demo_notice_banner.dart';
import '../widgets/booking_ticket_card.dart';

/// Lists the demo booking requests created in this session.
class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rezervasyonlarım')),
      body: ListenableBuilder(
        listenable: deps.bookings,
        builder: (context, _) {
          final bookings = deps.bookings.bookings;
          if (bookings.isEmpty) {
            return AppEmptyState(
              icon: Icons.confirmation_number_outlined,
              title: 'Henüz demo talebin yok',
              message:
                  'Bir araç seçip Kirala dediğinde oluşturduğun '
                  'talepler burada bilet olarak görünür.',
              action: FilledButton.icon(
                onPressed: () => deps.tab.value = AppDestination.vehicles,
                icon: const Icon(Icons.directions_car),
                label: const Text('Araçlara göz at'),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: bookings.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) return const DemoNoticeBanner();
                  return BookingTicketCard(booking: bookings[index - 1]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
