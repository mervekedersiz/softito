import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/widgets/action_feedback.dart';
import 'settings_controller.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final notifier = ref.read(settingsControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.settings_outlined),
                const SizedBox(width: 8),
                Text(
                  'Uygulama Ayarları',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Theme selection
            Text(
              'Görünüm Teması',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Sistem'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Açık'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Koyu'),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (set) {
                notifier.setThemeMode(set.first);
              },
            ),

            const SizedBox(height: 20),
            // Default section
            Text(
              'Açılış Bölümü',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Varsayılan Başlangıç Ekranı'),
              subtitle: Text(
                settings.defaultSection == 'spiritual'
                    ? 'Maneviyat ve İyilik 🤲'
                    : 'Ders ve Gelişim 📚',
              ),
              trailing: DropdownButton<String>(
                value: settings.defaultSection,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'study',
                    child: Text('📚 Ders ve Gelişim'),
                  ),
                  DropdownMenuItem(
                    value: 'spiritual',
                    child: Text('🤲 Maneviyat'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) notifier.setDefaultSection(val);
                },
              ),
            ),

            const SizedBox(height: 12),
            // Notification privacy
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Bildirimde Başlığı Gizle'),
              subtitle: const Text(
                'Kilit ekranında alışkanlık adı yerine "Kendin için küçük bir adım zamanı" metnini gösterir.',
                style: TextStyle(fontSize: 12),
              ),
              value: settings.hideNotificationTitle,
              onChanged: (val) => notifier.setHideNotificationTitle(val),
            ),

            const SizedBox(height: 12),
            // Notification permission trigger
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text('Bildirim İzni Durumu'),
              subtitle: const Text(
                'Zamanlanmış hatırlatıcıların ulaşması için bildirim izni gerekir.',
              ),
              trailing: OutlinedButton(
                onPressed: () async {
                  final notif = ref.read(notificationServiceProvider);
                  final granted = await notif.requestPermission();
                  if (context.mounted) {
                    if (granted) {
                      ActionFeedback.showSuccess(
                        context,
                        'Bildirim izni verildi! 🔔',
                      );
                    } else {
                      ActionFeedback.showInfo(
                        context,
                        'Bildirim izni verilmedi veya desteklenmiyor.',
                      );
                    }
                  }
                },
                child: const Text('İzin İste'),
              ),
            ),

            const Divider(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    'Kendime Söz 🎟️',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sürüm 1.0 • Çevrimdışı Alışkanlık & Yaşam Takip\nClean Architecture & Drift SQLite ile güçlendirildi.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
