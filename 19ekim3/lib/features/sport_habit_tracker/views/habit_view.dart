import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../controllers/habit_controller.dart';
import '../models/habit_model.dart';
import '../widgets/habit_item_tile.dart';
import '../widgets/habit_streak_card.dart';

class HabitView extends StatelessWidget {
  final HabitController controller;

  const HabitView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HabitStateModel>(
      valueListenable: controller.state,
      builder: (context, state, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            HabitStreakCard(state: state),
            const SizedBox(height: 20),
            _buildSectionHeader(context),
            const SizedBox(height: 12),
            ...state.habits.map(
              (h) => HabitItemTile(
                habit: h,
                onToggle: () => controller.toggleHabit(h.id),
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
        'Günlük Hedefler ve Rutinler',
        style: TextStyle(
          color: context.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
