import 'package:flutter/material.dart';

import '../core/feedback/app_feedback.dart';
import '../features/bookings/presentation/pages/my_bookings_page.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/vehicles/presentation/pages/vehicle_list_page.dart';
import 'app_destination.dart';
import 'app_scope.dart';

/// Width from which the bottom bar is replaced by a side [NavigationRail].
const double _railBreakpoint = 840;

/// Main scaffold hosting the navigation and the five tab pages,
/// along with the global on-screen feedback banner.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([deps.tab, deps.bookings, deps.feedback]),
      builder: (context, _) {
        final current = deps.tab.value;
        final bookingCount = deps.bookings.bookings.length;
        final feedback = deps.feedback.current;
        void select(int index) => deps.tab.value = AppDestination.values[index];

        Widget icon(AppDestination d, {required bool selected}) {
          final base = Icon(selected ? d.selectedIcon : d.icon);
          if (d != AppDestination.bookings || bookingCount == 0) return base;
          return Badge.count(count: bookingCount, child: base);
        }

        final pages = IndexedStack(
          index: current.index,
          children: const [
            HomePage(),
            VehicleListPage(),
            MyBookingsPage(),
            FavoritesPage(),
            ProfilePage(),
          ],
        );

        Widget contentWithFeedback = Column(
          children: [
            if (feedback != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                child: AppFeedbackBanner(
                  feedback: feedback,
                  onDismiss: deps.feedback.clear,
                ),
              ),
            Expanded(child: pages),
          ],
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= _railBreakpoint) {
              return Scaffold(
                body: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: current.index,
                      onDestinationSelected: select,
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        for (final d in AppDestination.values)
                          NavigationRailDestination(
                            icon: icon(d, selected: false),
                            selectedIcon: icon(d, selected: true),
                            label: Text(d.label),
                          ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: contentWithFeedback),
                  ],
                ),
              );
            }
            return Scaffold(
              body: contentWithFeedback,
              bottomNavigationBar: NavigationBar(
                selectedIndex: current.index,
                onDestinationSelected: select,
                destinations: [
                  for (final d in AppDestination.values)
                    NavigationDestination(
                      icon: icon(d, selected: false),
                      selectedIcon: icon(d, selected: true),
                      label: d.label,
                      tooltip: d.label,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
