import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../models/habit_model.dart';

class HabitStreakCard extends StatelessWidget {
  final HabitStateModel state;

  const HabitStreakCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildStatsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.bolt_rounded, color: context.accentHabit, size: 24),
            const SizedBox(width: 8),
            Text(
              'Alışkanlık Serisi (Streak)',
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatBox(
          context,
          'Toplam Seri',
          '${state.totalStreaks} Gün',
          context.accentHabit,
        ),
        Container(
          width: 1,
          height: 40,
          color: context.borderColor,
        ),
        _buildStatBox(
          context,
          'Bugün Yapılan',
          '${state.completedTodayCount} / ${state.habits.length}',
          context.accentWater,
        ),
      ],
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: context.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
