import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../models/workout_model.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final WorkoutStateModel state;

  const WorkoutSummaryCard({
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
            const SizedBox(height: 16),
            _buildProgressBar(context),
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
            Icon(Icons.local_fire_department_rounded,
                color: context.accentGym, size: 24),
            const SizedBox(width: 8),
            Text(
              'Günlük Kalori ve Egzersiz',
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(
          context,
          'Yakılan Kalori',
          '${state.totalBurnedCalories} kcal',
          'Hedef: ${state.targetCalories} kcal',
          context.accentGym,
        ),
        _buildStatItem(
          context,
          'Toplam Süre',
          '${state.totalCompletedMinutes} dk',
          'Tamamlanan',
          context.accentHabit,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String sub,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: accentColor,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          sub,
          style: TextStyle(color: context.textMutedColor, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: state.calorieProgress,
        minHeight: 10,
        backgroundColor: context.cardBackgroundLight,
        valueColor: AlwaysStoppedAnimation<Color>(context.accentGym),
      ),
    );
  }
}
