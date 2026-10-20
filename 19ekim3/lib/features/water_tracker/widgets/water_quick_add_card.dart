import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extensions.dart';

class WaterQuickAddCard extends StatelessWidget {
  final ValueChanged<int> onAddAmount;
  final VoidCallback onReset;

  const WaterQuickAddCard({
    super.key,
    required this.onAddAmount,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hızlı Su Ekle',
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            _buildButtonsGrid(context),
            const SizedBox(height: 12),
            _buildResetButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsGrid(BuildContext context) {
    return Row(
      children: [
        _buildAmountButton(context, 200, '200 ml', Icons.local_cafe_outlined),
        const SizedBox(width: 8),
        _buildAmountButton(context, 250, '250 ml', Icons.water_drop_outlined),
        const SizedBox(width: 8),
        _buildAmountButton(context, 500, '500 ml', Icons.sports_bar_outlined),
      ],
    );
  }

  Widget _buildAmountButton(
      BuildContext context, int amount, String label, IconData icon) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.borderColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: context.cardBackgroundLight,
        ),
        onPressed: () => onAddAmount(amount),
        child: Column(
          children: [
            Icon(icon, color: context.accentWater, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onReset,
        icon: Icon(Icons.refresh_rounded, size: 16, color: context.textMutedColor),
        label: Text(
          'Bugünü Sıfırla',
          style: TextStyle(color: context.textMutedColor, fontSize: 12),
        ),
      ),
    );
  }
}
