import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_record_model.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_quick_add_card.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterRecordModel>(
      valueListenable: controller.state,
      builder: (context, record, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterProgressCard(record: record),
              const SizedBox(height: 16),
              WaterQuickAddCard(
                onAddAmount: controller.addWater,
                onReset: controller.resetWater,
              ),
            ],
          ),
        );
      },
    );
  }
}
