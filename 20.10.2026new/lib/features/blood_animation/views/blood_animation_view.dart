import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/demo_label.dart';
import '../controllers/blood_animation_controller.dart';
import '../models/blood_animation_state.dart';
import '../widgets/animated_blood_bag.dart';

class BloodAnimationView extends StatelessWidget {
  final BloodAnimationController controller;

  const BloodAnimationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBlood : AppColors.softRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.invert_colors_rounded,
                        color: AppColors.bloodRed,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.simulationTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.simulationSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const DemoLabel(text: 'Ders Demosu', isProminent: true),
              ],
            ),
            const SizedBox(height: 16),

            // Animated Blood Bag Display
            Center(
              child: AnimatedBloodBag(
                controller: controller,
                width: 220,
                height: 290,
              ),
            ),
            const SizedBox(height: 12),

            // Status Indicator Chip
            ValueListenableBuilder<BloodAnimationState>(
              valueListenable: controller,
              builder: (context, state, child) {
                Color statusColor;
                IconData statusIcon;
                String statusText;

                switch (state.status) {
                  case AnimationStatusState.idle:
                    statusColor = isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary;
                    statusIcon = Icons.hourglass_empty_rounded;
                    statusText = AppStrings.simulationIdle;
                    break;
                  case AnimationStatusState.running:
                    statusColor = AppColors.vibrantRed;
                    statusIcon = Icons.motion_photos_on_rounded;
                    statusText = AppStrings.simulationRunning;
                    break;
                  case AnimationStatusState.paused:
                    statusColor = AppColors.warning;
                    statusIcon = Icons.pause_circle_outline_rounded;
                    statusText = AppStrings.simulationPaused;
                    break;
                  case AnimationStatusState.completed:
                    statusColor = AppColors.success;
                    statusIcon = Icons.check_circle_outline_rounded;
                    statusText = AppStrings.simulationCompleted;
                    break;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withAlpha(80),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Control Buttons
            ValueListenableBuilder<BloodAnimationState>(
              valueListenable: controller,
              builder: (context, state, child) {
                return Row(
                  children: [
                    // Primary Action (Start / Pause / Resume)
                    Expanded(flex: 3, child: _buildPrimaryButton(state)),
                    const SizedBox(width: 8),
                    // Reset Button
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: state.isIdle
                            ? null
                            : () => controller.reset(),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text(AppStrings.simulationReset),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Informational Disclaimer
            Text(
              AppStrings.simulationNotice,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BloodAnimationState state) {
    if (state.isIdle) {
      return ElevatedButton.icon(
        onPressed: () => controller.start(),
        icon: const Icon(Icons.play_arrow_rounded, size: 18),
        label: const Text(AppStrings.simulationStart),
      );
    } else if (state.isRunning) {
      return ElevatedButton.icon(
        onPressed: () => controller.pause(),
        icon: const Icon(Icons.pause_rounded, size: 18),
        label: const Text(AppStrings.simulationPause),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: Colors.white,
        ),
      );
    } else if (state.isPaused) {
      return ElevatedButton.icon(
        onPressed: () => controller.resume(),
        icon: const Icon(Icons.play_arrow_rounded, size: 18),
        label: const Text(AppStrings.simulationResume),
      );
    } else {
      // Completed
      return ElevatedButton.icon(
        onPressed: () => controller.reset(),
        icon: const Icon(Icons.replay_rounded, size: 18),
        label: const Text('Yeniden Oynat'),
      );
    }
  }
}
