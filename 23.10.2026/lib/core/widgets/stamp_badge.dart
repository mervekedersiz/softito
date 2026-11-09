import 'package:flutter/material.dart';

enum StampType { green, pink }

class StampBadge extends StatelessWidget {
  const StampBadge({
    super.key,
    required this.text,
    this.type = StampType.green,
    this.angle = -0.08,
    this.showIcon = true,
  });

  final String text;
  final StampType type;
  final double angle;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final isGreen = type == StampType.green;
    final borderColor = isGreen
        ? const Color(0xFF3B6447)
        : const Color(0xFFE06D53);
    final bgColor = isGreen
        ? const Color(0xFF3B6447).withValues(alpha: 0.12)
        : const Color(0xFFFDE8E1).withValues(alpha: 0.6);
    final textColor = isGreen
        ? const Color(0xFF2E5339)
        : const Color(0xFFC75139);

    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                Icons.verified_rounded,
                size: 13,
                color: textColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
