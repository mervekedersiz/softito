import 'package:flutter/material.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerCard extends StatelessWidget {
  final WaterTrackerModel model;
  final VoidCallback? onIncrement;
  final VoidCallback? onToggle;

  const WaterTrackerCard({
    super.key,
    required this.model,
    this.onIncrement,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildContent(context),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          model.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Icon(
          model.isCompleted
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: model.isCompleted ? Colors.green : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      'Mevcut Değer: ${model.value}',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onToggle != null)
          TextButton(
            onPressed: onToggle,
            child: Text(model.isCompleted ? 'Geri Al' : 'Tamamla'),
          ),
        const SizedBox(width: 8),
        if (onIncrement != null)
          ElevatedButton.icon(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Artır'),
          ),
      ],
    );
  }
}
