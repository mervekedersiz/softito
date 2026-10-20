import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/donation_record.dart';

class LifeChainTimeline extends StatelessWidget {
  final List<TrackingEvent> events;

  const LifeChainTimeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // All standard 4 stages defined in the specification
    final stages = [
      TrackingStage.donated,
      TrackingStage.tested,
      TrackingStage.ready,
      TrackingStage.delivered,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.hub_outlined, color: AppColors.bloodRed, size: 20),
            const SizedBox(width: 8),
            Text(
              'Hayat Zinciri Takibi (Demo Süreci)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        ...stages.asMap().entries.map((entry) {
          final index = entry.key;
          final stage = entry.value;
          final isLast = index == stages.length - 1;

          final matchedEvent = events
              .where((e) => e.stage == stage)
              .firstOrNull;
          final isReached = matchedEvent != null;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline icon & connecting line
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isReached
                              ? AppColors.bloodRed
                              : (isDark
                                    ? AppColors.darkSurfaceSubtle
                                    : AppColors.lightSurfaceSubtle),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isReached
                                ? AppColors.bloodRed
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                            width: 1.5,
                          ),
                        ),
                        child: isReached
                            ? const Icon(
                                Icons.check_rounded,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: isReached
                                ? AppColors.bloodRed.withAlpha(150)
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Text info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stage.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isReached
                                ? (isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          matchedEvent?.note ?? stage.description,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        if (matchedEvent != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${matchedEvent.timestamp.day}.${matchedEvent.timestamp.month}.${matchedEvent.timestamp.year} — ${matchedEvent.timestamp.hour.toString().padLeft(2, '0')}:${matchedEvent.timestamp.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.bloodRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
