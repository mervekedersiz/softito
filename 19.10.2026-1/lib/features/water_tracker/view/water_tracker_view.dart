import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/core/widgets/app_logo.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/widget/animated_water_glass.dart';
import 'package:susadim/features/water_tracker/widget/quick_water_buttons.dart';
import 'package:susadim/features/water_tracker/widget/water_log_tile.dart';

class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  final WaterTrackerController controller;

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
                Text('Susadım • Su Takibi'),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Sıfırla',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: controller.resetToday,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              AnimatedWaterGlass(
                progress: controller.progress,
                drankMl: controller.totalDrankMl,
                goalMl: controller.dailyGoalMl,
              ),
              const SizedBox(height: 28),
              QuickWaterButtons(onAddWater: controller.addWater),
              const SizedBox(height: 28),
              _WaterHistorySection(controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class _WaterHistorySection extends StatelessWidget {
  const _WaterHistorySection({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    final logs = controller.logs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bugünkü Kayıtlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (logs.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Henüz su tüketimi kaydedilmedi.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          )
        else
          ...logs.map(
            (log) => WaterLogTile(
              key: ValueKey(log.id),
              log: log,
              onDelete: () => controller.removeLog(log.id),
            ),
          ),
      ],
    );
  }
}
