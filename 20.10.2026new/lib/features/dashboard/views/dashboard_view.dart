import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/widgets/blood_group_chip.dart';
import '../../../../core/widgets/demo_label.dart';
import '../../blood_animation/controllers/blood_animation_controller.dart';
import '../../blood_animation/views/blood_animation_view.dart';
import '../../donation_history/widgets/donation_bar_chart.dart';
import '../../profile/widgets/donor_badge_card.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_state.dart';
import '../widgets/donation_summary_card.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller;
  final BloodAnimationController animationController;
  final DemoStore store;
  final VoidCallback onNavigateToBooking;
  final VoidCallback onNavigateToEligibility;
  final VoidCallback onNavigateToBloodValues;
  final VoidCallback onNavigateToBloodGroups;
  final VoidCallback onNavigateToRequests;
  final VoidCallback onNavigateToHistory;

  const DashboardView({
    super.key,
    required this.controller,
    required this.animationController,
    required this.store,
    required this.onNavigateToBooking,
    required this.onNavigateToEligibility,
    required this.onNavigateToBloodValues,
    required this.onNavigateToBloodGroups,
    required this.onNavigateToRequests,
    required this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.bloodRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              AppStrings.appName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Ders Prototipi', isProminent: true),
          ),
        ],
      ),
      body: ValueListenableBuilder<DashboardState>(
        valueListenable: controller,
        builder: (context, state, child) {
          final profile = state.profile;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              // User Header Greeting Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Merhaba, ${profile.displayName}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Bölge: ${profile.district} • ${state.completedDonationsCount} Bağış',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        BloodGroupChip(
                          group: profile.bloodGroup,
                          size: 42,
                          onTap: onNavigateToBloodGroups,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Interactive Blood Animation Main Card (Hortumdan akan kan ve kan torbası dolumu)
              BloodAnimationView(controller: animationController),
              const SizedBox(height: 8),

              // Quick Actions Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.quickActions,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            context,
                            icon: Icons.calendar_month_rounded,
                            label: AppStrings.bookDonation,
                            color: AppColors.bloodRed,
                            onTap: onNavigateToBooking,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionButton(
                            context,
                            icon: Icons.assignment_outlined,
                            label: AppStrings.preScreeningForm,
                            color: AppColors.info,
                            onTap: onNavigateToEligibility,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            context,
                            icon: Icons.show_chart_rounded,
                            label: AppStrings.myBloodValues,
                            color: AppColors.warning,
                            onTap: onNavigateToBloodValues,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionButton(
                            context,
                            icon: Icons.bloodtype_outlined,
                            label: AppStrings.bloodGroupsGuide,
                            color: isDark
                                ? AppColors.vibrantRed
                                : AppColors.deepCrimson,
                            onTap: onNavigateToBloodGroups,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Upcoming Appointment Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DonationSummaryCard(
                  nextAppointment: state.nextAppointment,
                  store: store,
                  onBookTap: onNavigateToBooking,
                  onManageTap: onNavigateToHistory,
                ),
              ),
              const SizedBox(height: 16),

              // Monthly Donation Summary Chart Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.monthlyDonationSummary,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: onNavigateToHistory,
                              child: const Text(
                                'Geçmişi Gör',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DonationBarChart(
                          monthlyData: state.monthlyDonations,
                          height: 140,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Urgent Needs Summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.urgentNeedsNearYou,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: onNavigateToRequests,
                          child: const Text(
                            AppStrings.viewAllNeeds,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ...state.nearbyRequests.map((req) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: BloodGroupChip(
                            group: req.bloodGroup,
                            size: 36,
                            width: 48,
                          ),
                          title: Text(
                            '${req.recipientAlias} • ${req.district}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          subtitle: Text(
                            '${req.demoDistanceKm} km (${AppStrings.sampleDistance}) • ${req.urgency.label}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: onNavigateToRequests,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Last Earned Badge Card
              if (state.lastEarnedBadge != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.lastEarnedBadge,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DonorBadgeCard(badge: state.lastEarnedBadge!),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
