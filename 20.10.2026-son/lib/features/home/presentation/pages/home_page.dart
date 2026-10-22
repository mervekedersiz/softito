import 'package:flutter/material.dart';

import '../../../../app/app_destination.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/demo_notice_banner.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/domain/entities/user.dart';
import '../widgets/home_hero.dart';
import '../widgets/home_sections.dart';
import '../widgets/module_card.dart';

/// Landing screen: "Amacın ne?" with the available and upcoming multi-modal mobility services.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currency = deps.currency;
    final auth = deps.auth;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Top Bar with Currency Selector & Role Switcher
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Currency Badge
                  ListenableBuilder(
                    listenable: currency,
                    builder: (context, _) => ActionChip(
                      avatar: Text(
                        currency.selected.symbol,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      label: Text(
                        '${currency.selected.code} Kur',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      onPressed: () => AppRouter.showCurrencyPicker(context, currency),
                    ),
                  ),
                  // User Role Badge & Login / Admin Access
                  ListenableBuilder(
                    listenable: auth,
                    builder: (context, _) {
                      final user = auth.currentUser;
                      final isAdmin = user?.role == UserRole.admin;

                      return Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ActionChip(
                            avatar: Icon(
                              isAdmin ? Icons.admin_panel_settings : Icons.person,
                              size: 14,
                              color: isAdmin ? Colors.deepOrange : colors.primary,
                            ),
                            label: Text(
                              user != null ? '${user.name.split(" ").first} (${isAdmin ? "Admin" : "Üye"})' : 'Giriş',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isAdmin ? Colors.deepOrange : null,
                              ),
                            ),
                            onPressed: () => AppRouter.pushLogin(context),
                          ),
                          IconButton.filledTonal(
                            tooltip: 'Kayıt Ol',
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.person_add, size: 16),
                            onPressed: () => AppRouter.pushRegister(context),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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
                    // Core Car Rental Module Card
                    ModuleCard(
                      icon: Icons.directions_car,
                      title: 'Araba Kirala',
                      description:
                          'Manuel, otomatik veya elektrikli araçları incele.',
                      onTap: () => deps.tab.value = AppDestination.vehicles,
                    ),
                    const SizedBox(height: 16),
                    // Multi-Modal Advanced Feature Cards
                    const SectionHeader(title: 'Çok Modlu Ulaşım & Akıllı Servisler'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ServiceActionCard(
                            icon: Icons.map_outlined,
                            iconColor: const Color(0xFF3B82F6),
                            title: 'Harita & Pin Ekle',
                            subtitle: 'İnteraktif haritada yeni pinler oluşturun',
                            onTap: () => AppRouter.pushMap(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ServiceActionCard(
                            icon: Icons.contactless_outlined,
                            iconColor: const Color(0xFF10B981),
                            title: 'NFC Sürüş Kotası',
                            subtitle: 'Günlük sürüş hakkı & temassız kilit açma',
                            onTap: () => AppRouter.pushNfcPass(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ServiceActionCard(
                            icon: Icons.radar,
                            iconColor: Colors.cyanAccent,
                            title: 'Canlı Takip (iFrame)',
                            subtitle: 'Gerçek zamanlı hız, telemetri & kamera',
                            onTap: () => AppRouter.pushLiveTracking(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ServiceActionCard(
                            icon: Icons.credit_card,
                            iconColor: Colors.deepPurpleAccent,
                            title: '3D Kredi Kartı',
                            subtitle: 'Başarı/Hata simülasyonlu ödeme ekranı',
                            onTap: () {
                              final firstCar = deps.vehicles.all.isNotEmpty
                                  ? deps.vehicles.all.first
                                  : null;
                              if (firstCar != null) {
                                AppRouter.pushPayment(
                                  context,
                                  vehicle: firstCar,
                                  totalAmountTry: firstCar.dailyPrice,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _ServiceActionCard(
                      icon: Icons.shield,
                      iconColor: Colors.deepOrange,
                      title: 'Admin Yönetim Paneli (Yetki Bazlı)',
                      subtitle: 'Filo, anlık kur ve rezervasyon onaylama/reddetme denetimi',
                      onTap: () => AppRouter.pushAdmin(context),
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

class _ServiceActionCard extends StatelessWidget {
  const _ServiceActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
