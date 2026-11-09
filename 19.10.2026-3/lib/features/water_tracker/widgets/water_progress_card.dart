import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../models/water_record_model.dart';

class WaterProgressCard extends StatelessWidget {
  final WaterRecordModel record;

  const WaterProgressCard({
    super.key,
    required this.record,
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
            const SizedBox(height: 20),
            _buildProgressRow(context),
            const SizedBox(height: 18),
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
            Icon(Icons.water_drop_rounded,
                color: context.accentWater, size: 22),
            const SizedBox(width: 8),
            Text(
              'Günlük Su Takibi',
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Chip(
          backgroundColor: context.cardBackgroundLight,
          side: BorderSide(color: context.borderColor),
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          label: Text(
            'Hedef: 2.5L',
            style: TextStyle(color: context.accentWater, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    final percent = (record.progressRatio * 100).toInt();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${record.currentIntakeMl} ml',
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            Text(
              'Kalan: ${record.remainingMl} ml (${record.glassCount} bardak)',
              style: TextStyle(
                color: context.textSecondaryColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          '%$percent',
          style: TextStyle(
            color: context.accentWater,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: record.progressRatio,
        minHeight: 12,
        backgroundColor: context.cardBackgroundLight,
        valueColor: AlwaysStoppedAnimation<Color>(context.accentWater),
      ),
    );
  }
}
