import 'package:flutter/material.dart';

import '../../../../app/brand_colors.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../../../core/widgets/brand_title.dart';

/// Home header: navy gradient with the brand's sun and ribbon motifs.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brand.heroStart, brand.heroEnd],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -56,
              top: -56,
              child: ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brand.sun.withValues(alpha: .92),
                  ),
                  child: const SizedBox.square(dimension: 200),
                ),
              ),
            ),
            const Positioned(
              right: -20,
              bottom: 12,
              child: BrandMark(height: 120, opacity: .22),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandTitle(onDark: true),
                    const SizedBox(height: 28),
                    Text(
                      'MOBİLİTE & PAYLAŞIM',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: brand.gold,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Semantics(
                      header: true,
                      child: Text(
                        'Amacın ne?',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: brand.onHero,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Yolculuğun için ne yapmak istediğini seç.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: brand.onHeroMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
