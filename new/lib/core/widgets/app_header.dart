import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String subtitle;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool showBackButton;

  const AppHeader({
    super.key,
    required this.subtitle,
    this.onNotificationTap,
    this.onProfileTap,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          else
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.kitchen,
                color: Colors.white,
                size: 20,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'FreshTrack',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryMint,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'TAZE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_outlined, size: 24),
                Positioned(
                  top: -2,
                  right: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: onNotificationTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Aktif bildirimleriniz güncel ve devrede.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onProfileTap ??
                () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kullanıcı Profili & Ayarlar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const ListTile(
                                leading: Icon(Icons.verified_user_outlined),
                                title: Text('FreshTrack Hane Üyesi'),
                                subtitle: Text('Yerel cihaz veritabanı aktif'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.slideshow_outlined,
                                    color: AppColors.primary),
                                title: const Text('Onboarding Tanıtım Ekranı'),
                                subtitle: Text('Uygulama tanıtımını incele'),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios, size: 14),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/onboarding');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.rocket_launch_outlined,
                                    color: AppColors.primary),
                                title: const Text('Açılış (Splash) Ekranı'),
                                subtitle: const Text(
                                    'Açılış logosu ve yükleme animasyonunu gör'),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios, size: 14),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/splash');
                                },
                              ),
                              const ListTile(
                                leading: Icon(Icons.info_outline),
                                title: Text('Sürüm'),
                                subtitle:
                                    Text('FreshTrack v1.0.0 (Offline-First)'),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Kapat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(20),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.primaryDark,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
