import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/core/widgets/app_logo.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/widget/calorie_burn_card.dart';
import 'package:susadim/features/workout/widget/quick_workout_buttons.dart';
import 'package:susadim/features/workout/widget/treadmill_runner.dart';
import 'package:susadim/features/workout/widget/workout_list_item.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({
    super.key,
    required this.controller,
  });

  final WorkoutController controller;

  void _showAddWorkoutSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => _AddWorkoutForm(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLogo.small(),
                SizedBox(width: 10),
                Text('Antrenman & Kalori'),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Egzersiz Ekle',
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: () => _showAddWorkoutSheet(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              CalorieBurnCard(
                caloriesBurned: controller.totalCaloriesBurned,
                calorieGoal: controller.dailyCalorieGoal,
                totalMinutes: controller.totalMinutes,
                progress: controller.calorieProgress,
              ),
              const SizedBox(height: 20),
              const TreadmillRunner(isRunning: true),
              const SizedBox(height: 20),
              QuickWorkoutButtons(onAddQuickWorkout: controller.addWorkout),
              const SizedBox(height: 24),
              _WorkoutSection(controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class _WorkoutSection extends StatelessWidget {
  const _WorkoutSection({required this.controller});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bugünkü Antrenmanlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Bugün henüz antrenman eklenmedi.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          )
        else
          ...items.map(
            (item) => WorkoutListItem(
              key: ValueKey(item.id),
              workout: item,
              onDelete: () => controller.removeWorkout(item.id),
            ),
          ),
      ],
    );
  }
}

class _AddWorkoutForm extends StatefulWidget {
  const _AddWorkoutForm({required this.controller});

  final WorkoutController controller;

  @override
  State<_AddWorkoutForm> createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<_AddWorkoutForm> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _calorieController = TextEditingController(text: '200');
  String _selectedCategory = 'Ağırlık';

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final duration = int.tryParse(_durationController.text) ?? 30;
    final calories = int.tryParse(_calorieController.text) ?? 200;

    if (title.isEmpty) return;

    widget.controller.addWorkout(
      title: title,
      category: _selectedCategory,
      durationMinutes: duration,
      caloriesBurned: calories,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Yeni Antrenman Ekle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Antrenman Adı (örn: Bacak Günü)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            dropdownColor: AppColors.surfaceLight,
            items: const [
              DropdownMenuItem(value: 'Ağırlık', child: Text('Ağırlık')),
              DropdownMenuItem(value: 'Kardiyo', child: Text('Kardiyo')),
              DropdownMenuItem(value: 'Esneme', child: Text('Esneme')),
              DropdownMenuItem(value: 'HIIT', child: Text('HIIT')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
            decoration: const InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Süre (dk)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _calorieController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Kalori (kcal)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonLime,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: const Text('Kaydet', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
