import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../../../core/widgets/demo_notice_banner.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/widgets/role_switch_bar.dart';

/// Theme choice, user role status, wallet, and system administration access.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final deps = AppScope.of(context);
    final themeController = deps.theme;
    final auth = deps.auth;
    final currency = deps.currency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            tooltip: 'Para Birimi & Canlı Kur',
            icon: const Icon(Icons.currency_exchange),
            onPressed: () => AppRouter.showCurrencyPicker(context, currency),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // User Header
              ListenableBuilder(
                listenable: auth,
                builder: (context, _) {
                  final user = auth.currentUser;

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: colors.primary,
                        child: const BrandMark(height: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Misafir kullanıcı',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              user?.email ?? 'Giriş ve hesap sistemi yok (demo)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (user == null)
                        FilledButton(
                          onPressed: () => AppRouter.pushLogin(context),
                          child: const Text('Giriş Yap'),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => auth.logout(),
                          child: const Text('Çıkış'),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              // Role Switch Bar (Yetki bazlı sorgulama ve test)
              const RoleSwitchBar(),
              const SizedBox(height: 16),
              // Wallet & NFC Quota Card
              ListenableBuilder(
                listenable: Listenable.merge([auth, currency, deps.nfc]),
                builder: (context, _) {
                  final user = auth.currentUser;
                  final balance = user?.walletBalanceTry ?? 4500.0;
                  final pass = deps.nfc.pass;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cüzdan Bakiyesi', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(
                                    currency.format(balance),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: colors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () => AppRouter.pushNfcPass(context),
                                icon: const Icon(Icons.contactless, size: 16),
                                label: Text('${pass.remainingMinutes} dk Sürüş'),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Aktif Para Birimi: ${currency.selected.displayName} (${currency.selected.code})',
                                style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                              ),
                              GestureDetector(
                                onTap: () => AppRouter.showCurrencyPicker(context, currency),
                                child: Text(
                                  'Değiştir',
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Quick Nav Shortcuts: Admin, Live Tracking, Map
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => AppRouter.pushAdmin(context),
                      icon: const Icon(Icons.shield_outlined, size: 18),
                      label: const Text('Admin Masası'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => AppRouter.pushLiveTracking(context),
                      icon: const Icon(Icons.radar, size: 18),
                      label: const Text('Canlı Takip'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Görünüm'),
              const SizedBox(height: 12),
              ListenableBuilder(
                listenable: themeController,
                builder: (context, _) => SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto),
                      label: Text('Sistem'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode),
                      label: Text('Açık'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode),
                      label: Text('Koyu'),
                    ),
                  ],
                  selected: {themeController.mode},
                  onSelectionChanged: (s) => themeController.setMode(s.first),
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Hakkında'),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YolOrtağım · Çok Modlu Mobilite & Paylaşım',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sürüm 2.0.0 (Clean Architecture & Multi-Modal)',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bu uygulama Clean Architecture prensiplerine uygun '
                        'geliştirilmiştir. Canlı kur sorgulama, 3D kredi kartı '
                        'tasarımı, NFC günlük sürüş kotası, Sahibinden filtreleme '
                        've gerçek zamanlı telemetri takibi özelliklerini içerir.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const DemoNoticeBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
