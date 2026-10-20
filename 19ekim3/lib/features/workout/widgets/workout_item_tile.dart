import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../models/workout_model.dart';

class WorkoutItemTile extends StatelessWidget {
  final WorkoutItemModel workout;
  final VoidCallback onToggle;

  const WorkoutItemTile({
    super.key,
    required this.workout,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: workout.isCompleted
              ? context.accentHabit.withAlpha(90)
              : context.borderColor,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _buildLeadingIcon(context),
        title: Text(
          workout.title,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration:
                workout.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${workout.category} • ${workout.durationMinutes} dk • ${workout.calories} kcal',
          style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
        ),
        trailing: IconButton(
          icon: Icon(
            workout.isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: workout.isCompleted
                ? context.accentHabit
                : context.textMutedColor,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.cardBackgroundLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.fitness_center_rounded,
        color: context.accentGym,
        size: 20,
      ),
    );
  }
}
