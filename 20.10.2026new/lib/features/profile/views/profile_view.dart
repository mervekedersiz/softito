import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/blood_group_chip.dart';
import '../../../../core/widgets/demo_label.dart';
import '../../blood_groups/views/blood_groups_view.dart';
import '../../blood_groups/controllers/blood_groups_controller.dart';
import '../../../../core/data/demo_store.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_state.dart';
import '../widgets/donor_badge_card.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller;
  final ThemeController themeController;
  final DemoStore store;

  const ProfileView({
    super.key,
    required this.controller,
    required this.themeController,
    required this.store,
  });

  void _showEditProfileSheet(BuildContext context, ProfileState state) {
    final nameController = TextEditingController(
      text: state.profile.displayName,
    );
    final districtController = TextEditingController(
      text: state.profile.district,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profili Düzenle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad / Rumuz'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'İlçe / Bölge'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.updateNameAndDistrict(
                    nameController.text,
                    districtController.text,
                  );
                  Navigator.of(ctx).pop();
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareAwareness(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: AppStrings.awarenessShareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.shareCopied),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Profil'),
          ),
        ],
      ),
      body: ValueListenableBuilder<ProfileState>(
        valueListenable: controller,
        builder: (context, state, child) {
          final profile = state.profile;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Identity Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BloodGroupChip(
                            group: profile.bloodGroup,
                            size: 52,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => BloodGroupsView(
                                    controller: BloodGroupsController(store),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.displayName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${profile.district} • ${profile.bloodGroup.label}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Düzenle',
                            onPressed: () =>
                                _showEditProfileSheet(context, state),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildProfileStat(
                              'Tamamlanan Bağış',
                              '${state.completedDonationsCount}',
                              isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildProfileStat(
                              'Son Bağış',
                              state.lastDonationDate != null
                                  ? '${state.lastDonationDate!.day}.${state.lastDonationDate!.month}.${state.lastDonationDate!.year}'
                                  : 'Henüz yok',
                              isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Theme Switcher Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.themePreference,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeController,
                        builder: (context, themeMode, _) {
                          return SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.light,
                                icon: Icon(Icons.light_mode_outlined, size: 16),
                                label: Text(
                                  'Açık',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                icon: Icon(Icons.dark_mode_outlined, size: 16),
                                label: Text(
                                  'Koyu',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                            selected: {
                              themeMode == ThemeMode.dark
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                            },
                            onSelectionChanged: (set) =>
                                themeController.setThemeMode(set.first),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Share Awareness Button Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kan Kardeşliği & Farkındalık',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sosyal çevrenizde kan bağışının önemini hatırlatmak için hazır farkındalık mesajını kopyalayabilirsiniz.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _shareAwareness(context),
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: const Text(AppStrings.shareAwareness),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Badges Section
              Text(
                AppStrings.badgesTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...state.badges.map((b) => DonorBadgeCard(badge: b)),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceSubtle
            : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
