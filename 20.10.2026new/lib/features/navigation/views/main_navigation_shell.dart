import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/blood_request.dart';
import '../../../../core/models/donation_center.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../blood_animation/controllers/blood_animation_controller.dart';
import '../../blood_groups/controllers/blood_groups_controller.dart';
import '../../blood_groups/views/blood_groups_view.dart';
import '../../blood_requests/controllers/blood_requests_controller.dart';
import '../../blood_requests/views/blood_requests_view.dart';
import '../../blood_values/controllers/blood_values_controller.dart';
import '../../blood_values/views/blood_values_view.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../donation_booking/controllers/donation_booking_controller.dart';
import '../../donation_booking/views/donation_booking_view.dart';
import '../../donation_centers/controllers/donation_centers_controller.dart';
import '../../donation_centers/views/donation_centers_view.dart';
import '../../donation_history/controllers/donation_history_controller.dart';
import '../../donation_history/views/donation_history_view.dart';
import '../../eligibility/views/eligibility_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/navigation_controller.dart';

class MainNavigationShell extends StatefulWidget {
  final DemoStore store;
  final ThemeController themeController;

  const MainNavigationShell({
    super.key,
    required this.store,
    required this.themeController,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late final NavigationController _navigationController;
  late final DashboardController _dashboardController;
  late final BloodAnimationController _bloodAnimationController;
  late final BloodRequestsController _bloodRequestsController;
  late final DonationCentersController _donationCentersController;
  late final DonationHistoryController _donationHistoryController;
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _navigationController = NavigationController();
    _dashboardController = DashboardController(widget.store);
    _bloodAnimationController = BloodAnimationController();
    _bloodRequestsController = BloodRequestsController(widget.store);
    _donationCentersController = DonationCentersController(widget.store);
    _donationHistoryController = DonationHistoryController(widget.store);
    _profileController = ProfileController(widget.store);
  }

  @override
  void dispose() {
    _navigationController.dispose();
    _dashboardController.dispose();
    _bloodAnimationController.dispose();
    _bloodRequestsController.dispose();
    _donationCentersController.dispose();
    _donationHistoryController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  void _openBooking({BloodRequest? request, DonationCenter? center}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DonationBookingView(
          controller: DonationBookingController(
            widget.store,
            initialRequest: request,
            initialCenter: center,
          ),
          store: widget.store,
        ),
      ),
    );
  }

  void _openEligibility() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => EligibilityView(store: widget.store)),
    );
  }

  void _openBloodValues() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            BloodValuesView(controller: BloodValuesController(widget.store)),
      ),
    );
  }

  void _openBloodGroups() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            BloodGroupsView(controller: BloodGroupsController(widget.store)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _navigationController,
      builder: (context, currentIndex, child) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              // Tab 0: Ana Sayfa
              TickerMode(
                enabled: currentIndex == 0,
                child: DashboardView(
                  controller: _dashboardController,
                  animationController: _bloodAnimationController,
                  store: widget.store,
                  onNavigateToBooking: () => _openBooking(),
                  onNavigateToEligibility: _openEligibility,
                  onNavigateToBloodValues: _openBloodValues,
                  onNavigateToBloodGroups: _openBloodGroups,
                  onNavigateToRequests: () =>
                      _navigationController.goToRequests(),
                  onNavigateToHistory: () =>
                      _navigationController.goToHistory(),
                ),
              ),

              // Tab 1: İhtiyaçlar
              TickerMode(
                enabled: currentIndex == 1,
                child: BloodRequestsView(
                  controller: _bloodRequestsController,
                  store: widget.store,
                  onPlanDonation: (req) => _openBooking(request: req),
                ),
              ),

              // Tab 2: Bağış Noktaları
              TickerMode(
                enabled: currentIndex == 2,
                child: DonationCentersView(
                  controller: _donationCentersController,
                  onPlanBooking: (center) => _openBooking(center: center),
                ),
              ),

              // Tab 3: Geçmişim
              TickerMode(
                enabled: currentIndex == 3,
                child: DonationHistoryView(
                  controller: _donationHistoryController,
                  store: widget.store,
                ),
              ),

              // Tab 4: Profilim
              TickerMode(
                enabled: currentIndex == 4,
                child: ProfileView(
                  controller: _profileController,
                  themeController: widget.themeController,
                  store: widget.store,
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) =>
                _navigationController.setIndex(index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: AppStrings.navHome,
              ),
              NavigationDestination(
                icon: Icon(Icons.emergency_outlined),
                selectedIcon: Icon(Icons.emergency_rounded),
                label: AppStrings.navRequests,
              ),
              NavigationDestination(
                icon: Icon(Icons.place_outlined),
                selectedIcon: Icon(Icons.place_rounded),
                label: AppStrings.navCenters,
              ),
              NavigationDestination(
                icon: Icon(Icons.history_rounded),
                selectedIcon: Icon(Icons.history_edu_rounded),
                label: AppStrings.navHistory,
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: AppStrings.navProfile,
              ),
            ],
          ),
        );
      },
    );
  }
}
