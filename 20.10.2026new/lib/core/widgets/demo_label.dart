import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DemoLabel extends StatelessWidget {
  final String text;
  final bool isProminent;

  const DemoLabel({
    super.key,
    this.text = 'Örnek veri',
    this.isProminent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isProminent ? 10 : 8,
        vertical: isProminent ? 4 : 2,
      ),
      decoration: BoxDecoration(
        color: isProminent
            ? (isDark ? AppColors.darkBlood : AppColors.softRed)
            : (isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isProminent
              ? AppColors.bloodRed.withAlpha(120)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: isProminent ? 13 : 11,
            color: isProminent
                ? AppColors.bloodRed
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: isProminent ? 11 : 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: isProminent
                  ? AppColors.bloodRed
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
