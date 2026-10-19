import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';
import '../../navigation/view/main_navigation_shell.dart';
import '../../workout/controllers/workout_controller.dart';
import '../controllers/water_tracker_controller.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;
  final ThemeController themeController;
  final WorkoutController? workoutController;

  const WaterTrackerView({
    super.key,
    required this.controller,
    required this.themeController,
    this.workoutController,
  });

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      waterController: controller,
      workoutController: workoutController ?? WorkoutController(),
      themeController: themeController,
    );
  }
}
