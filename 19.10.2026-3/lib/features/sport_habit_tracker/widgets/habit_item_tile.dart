import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../models/habit_model.dart';

class HabitItemTile extends StatelessWidget {
  final HabitItemModel habit;
  final VoidCallback onToggle;

  const HabitItemTile({
    super.key,
    required this.habit,
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
          color: habit.isDoneToday
              ? context.accentHabit.withAlpha(90)
              : context.borderColor,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _buildLeadingIcon(context),
        title: Text(
          habit.title,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration:
                habit.isDoneToday ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '🔥 ${habit.streakDays} günlük seri',
          style: TextStyle(
            color: habit.isDoneToday ? context.accentHabit : context.textSecondaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            habit.isDoneToday
                ? Icons.check_circle_rounded
                : Icons.circle_outlined,
            color: habit.isDoneToday
                ? context.accentHabit
                : context.textMutedColor,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (habit.iconKey) {
      case 'water':
        icon = Icons.water_drop_rounded;
        color = context.accentWater;
        break;
      case 'steps':
        icon = Icons.directions_walk_rounded;
        color = context.accentGym;
        break;
      case 'stretch':
        icon = Icons.self_improvement_rounded;
        color = context.isDarkMode ? AppColors.neonPurple : AppColors.lightPurple;
        break;
      default:
        icon = Icons.fitness_center_rounded;
        color = context.accentHabit;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.cardBackgroundLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
