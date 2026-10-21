import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../../auth/domain/entities/user.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final auth = AppScope.of(context).auth;
    final currency = AppScope.of(context).currency;
    final feedback = AppScope.of(context).feedback;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Yönetici Paneli'),
        actions: [
          IconButton(
            tooltip: 'Yönetici Rolü Bilgisi',
            icon: const Icon(Icons.shield_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: auth,
        builder: (context, _) {
          final user = auth.currentUser;
          final isAdmin = user?.role == UserRole.admin;

          // Yetki bazlı sorgulama: Erişim Reddi Ekranı
          if (!isAdmin) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.gpp_bad, color: Colors.red, size: 54),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Erişim Reddedildi (403 Yetkisiz)',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bu sayfa yalnızca "Sistem Yöneticisi (Admin)" rolüne sahip kullanıcılar tarafından görüntülenebilir. Mevcut rolünüz: ${user?.role.title ?? "Misafir"}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.deepOrange),
                        onPressed: () {
                          auth.switchRole(UserRole.admin);
                          feedback.postSuccess(
                            title: 'Yetki Güncellendi',
                            message: 'Sistem Yöneticisi (Admin) rolüne geçiş yapıldı.',
                          );
                        },
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Tek Dokunuşla Admin Yetkisi Al'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Yetkili Admin Ekranı
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Admin Banner
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.deepOrange,
                                child: Icon(Icons.security, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Yönetim Masası (Admin)',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    '${user?.name} (${user?.email})',
                                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
                            onPressed: () => auth.switchRole(UserRole.customer),
                            child: const Text('Müşteri Rolüne Geç'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Fleet KPI Metrics
                    Row(
                      children: [
                        Expanded(
                          child: _AdminStatCard(
                            label: 'Toplam Filo',
                            value: '14 Araç',
                            icon: Icons.directions_car,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminStatCard(
                            label: 'Aktif Kirada',
                            value: '5 Araç',
                            icon: Icons.key,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminStatCard(
                            label: 'Düşük Depo Uyarısı',
                            value: '1 Araç (%15)',
                            icon: Icons.local_gas_station,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Real-Time Currency Management (Kur bazlı yönetim)
                    ListenableBuilder(
                      listenable: currency,
                      builder: (context, _) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Anlık Kur Yönetimi (Pricing Engine)',
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Tüm araç fiyatları bu kurlara endekslidir',
                                        style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                  FilledButton.tonalIcon(
                                    onPressed: () async {
                                      await currency.refreshLiveRates();
                                      feedback.postSuccess(
                                        title: 'Kurlar Güncellendi',
                                        message: 'Merkez Bankası canlı kurları başarıyla sorgulandı.',
                                      );
                                    },
                                    icon: const Icon(Icons.sync, size: 18),
                                    label: const Text('Kurları Sorgula'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final entry in currency.rates.entries)
                                    if (entry.key.code != 'TRY')
                                      Container(
                                        width: 100,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(entry.key.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₺${entry.value.rateAgainstTry}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: colors.primary,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              '${entry.value.changePercent >= 0 ? "+" : ""}${entry.value.changePercent}%',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: entry.value.changePercent >= 0 ? Colors.green : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Pending Booking Approvals (Başarılı / Başarısız durum ekrana basma testi)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Onay Bekleyen Rezervasyon Denetimi',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            _BookingApprovalTile(
                              bookingId: 'REZ-9821',
                              carName: 'Tesla Model 3 Long Range',
                              user: 'Ayşe Kaya (Sürücü)',
                              total: '₺4.900 (2 Gün)',
                              onApprove: () {
                                feedback.postSuccess(
                                  title: 'Rezervasyon Onaylandı',
                                  message: 'REZ-9821 talebi onaylandı ve araç tahsis edildi.',
                                );
                              },
                              onReject: () {
                                feedback.postFailure(
                                  title: 'Rezervasyon Reddedildi',
                                  message: 'REZ-9821 talebi yönetici tarafından iptal edildi.',
                                  code: 'REJECTED_BY_ADMIN',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }
}

class _BookingApprovalTile extends StatelessWidget {
  const _BookingApprovalTile({
    required this.bookingId,
    required this.carName,
    required this.user,
    required this.total,
    required this.onApprove,
    required this.onReject,
  });

  final String bookingId;
  final String carName;
  final String user;
  final String total;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(bookingId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Onay Bekliyor', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$carName • $user', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(total, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Onayla',
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: onApprove,
          ),
          IconButton(
            tooltip: 'Reddet',
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: onReject,
          ),
        ],
      ),
    );
  }
}
