import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/workout_item_tile.dart';
import '../widgets/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WorkoutStateModel>(
      valueListenable: controller.state,
      builder: (context, state, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            WorkoutSummaryCard(state: state),
            const SizedBox(height: 20),
            _buildSectionHeader(context),
            const SizedBox(height: 12),
            ...state.workouts.map(
              (w) => WorkoutItemTile(
                workout: w,
                onToggle: () => controller.toggleWorkoutCompletion(w.id),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'Günün Egzersizleri',
        style: TextStyle(
          color: context.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
