import 'package:flutter/material.dart';
import '../../water_tracker/controllers/water_tracker_controller.dart';
import '../../water_tracker/models/water_tracker_model.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_summary_header.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController workoutController;
  final WaterTrackerController waterController;

  const WorkoutView({
    super.key,
    required this.workoutController,
    required this.waterController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: waterController.state,
      builder: (context, waterData, _) {
        return ValueListenableBuilder<int>(
          valueListenable: workoutController.totalWorkoutsCompleted,
          builder: (context, totalCompleted, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WorkoutSummaryHeader(
                    completedWorkouts: totalCompleted,
                    totalCalories: waterData.todayCaloriesBurned,
                    totalMinutes: waterData.workoutMinutes,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context),
                  const SizedBox(height: 14),
                  _buildWorkoutList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'ANTRENMAN LİSTESİ',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
        ),
        const Text(
          'Hidrasyon Destekli',
          style: TextStyle(color: Color(0xFF00C4D4), fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildWorkoutList() {
    return ValueListenableBuilder<List<WorkoutModel>>(
      valueListenable: workoutController.availableWorkouts,
      builder: (context, workouts, _) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return WorkoutCard(
              workout: workout,
              onComplete: () => _handleComplete(context, workout),
            );
          },
        );
      },
    );
  }

  void _handleComplete(BuildContext context, WorkoutModel workout) {
    workoutController.completeWorkout(
      workout,
      onLoggedToWaterTracker: (minutes, calories) {
        waterController.logWorkout(minutes, calories);
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${workout.title} kaydedildi! (+${workout.recommendedHydrationMl} ml hedef eklendi)'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
