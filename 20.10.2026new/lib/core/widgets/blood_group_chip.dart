import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/blood_group.dart';

class BloodGroupChip extends StatelessWidget {
  final BloodGroup group;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;
  final double? width;

  const BloodGroupChip({
    super.key,
    required this.group,
    this.isSelected = false,
    this.onTap,
    this.size = 36,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? AppColors.bloodRed
        : (isDark ? AppColors.darkSurfaceSubtle : AppColors.softRed);

    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.vibrantRed : AppColors.bloodRed);

    final borderColor = isSelected
        ? AppColors.bloodRed
        : (isDark ? AppColors.darkBorder : AppColors.bloodRed.withAlpha(50));

    final chipBox = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: size,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.bloodRed.withAlpha(80),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        group.label,
        style: TextStyle(
          color: textColor,
          fontSize: size * 0.38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: width != null ? chipBox : IntrinsicWidth(child: chipBox),
    );
  }
}
