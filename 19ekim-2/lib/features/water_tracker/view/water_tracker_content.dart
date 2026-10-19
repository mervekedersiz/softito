import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/hydration_stats_row.dart';
import '../widgets/quick_add_bar.dart';
import '../widgets/water_circular_gauge.dart';
import '../widgets/workout_sync_badge.dart';

class WaterTrackerContent extends StatelessWidget {
  final WaterTrackerController controller;
  final VoidCallback onNavigateToWorkout;

  const WaterTrackerContent({
    super.key,
    required this.controller,
    required this.onNavigateToWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: controller.state,
      builder: (context, data, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterCircularGauge(
                currentMl: data.currentIntakeMl,
                goalMl: data.dailyGoalMl,
                progress: data.progressPercentage,
              ),
              const SizedBox(height: 20),
              HydrationStatsRow(
                streakDays: data.streakDays,
                remainingMl: data.remainingMl,
                intakeCount: data.intakeCount,
              ),
              const SizedBox(height: 20),
              QuickAddBar(onAdd: controller.addWater),
              const SizedBox(height: 18),
              WorkoutSyncBadge(
                burnedCalories: data.todayCaloriesBurned,
                workoutMinutes: data.workoutMinutes,
                onLogQuickWorkout: onNavigateToWorkout,
              ),
            ],
          ),
        );
      },
    );
  }
}
