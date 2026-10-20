import 'package:flutter/material.dart';

import '../../../../app/app_destination.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/widgets/demo_notice_banner.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/home_hero.dart';
import '../widgets/home_sections.dart';
import '../widgets/module_card.dart';

/// Landing screen: "Amacın ne?" with the available and upcoming modules.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const HomeHero(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DemoNoticeBanner(),
                    const SizedBox(height: 16),
                    ModuleCard(
                      icon: Icons.directions_car,
                      title: 'Araba Kirala',
                      description:
                          'Manuel, otomatik veya elektrikli araçları incele.',
                      onTap: () => deps.tab.value = AppDestination.vehicles,
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Ne tür araç arıyorsun?'),
                    const SizedBox(height: 12),
                    const CategoryShortcuts(),
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Popüler araçlar'),
                    const SizedBox(height: 12),
                    const PopularVehicles(),
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Yakında'),
                    const SizedBox(height: 12),
                    const ModuleCard(
                      icon: Icons.alt_route,
                      title: 'Arabanın Ortağı',
                      description: 'Güzergâhını paylaş, yolculuğa ortak ol.',
                    ),
                    const SizedBox(height: 12),
                    const ModuleCard(
                      icon: Icons.luggage,
                      title: 'Bagajı Kullan',
                      description:
                          'Boş bagaj alanını eşya taşımak için kullan.',
                    ),
                    const SizedBox(height: 12),
                    const ModuleCard(
                      icon: Icons.school,
                      title: 'Acemiyim',
                      description: 'Deneyimli sürücülerle sürüş mentorluğu.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
