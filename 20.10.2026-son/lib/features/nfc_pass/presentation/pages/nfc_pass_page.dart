import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../controllers/nfc_controller.dart';

class NfcPassPage extends StatelessWidget {
  const NfcPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final nfc = AppScope.of(context).nfc;
    final feedback = AppScope.of(context).feedback;

    return Scaffold(
      appBar: AppBar(title: const Text('NFC & Günlük Sürüş Hakkı')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListenableBuilder(
              listenable: nfc,
              builder: (context, _) {
                final pass = nfc.pass;
                final state = nfc.state;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Physical Card Simulation Badge
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF415A77)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.contactless, color: Colors.cyanAccent, size: 32),
                                  const SizedBox(width: 8),
                                  Text(
                                    'YOL-PASS NFC',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: pass.hasRemainingQuota ? const Color(0xFF10B981) : Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  pass.hasRemainingQuota ? 'AKTİF GEÇİŞ' : 'KOTA DOLDU',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Text(
                            pass.cardId,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('KART SAHİBİ', style: TextStyle(color: Colors.white54, fontSize: 10)),
                                  Text(
                                    pass.holderName,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('KALAN SÜRÜŞ', style: TextStyle(color: Colors.white54, fontSize: 10)),
                                  Text(
                                    '${pass.remainingRides} / ${pass.totalDailyRides} Hak',
                                    style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quota Meter Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Günlük Sürüş Kotası', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                Text('${pass.remainingMinutes} dk kaldı', style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: pass.minutesRatio,
                                minHeight: 12,
                                backgroundColor: colors.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  pass.minutesRatio > 0.3 ? const Color(0xFF10B981) : Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Toplam Hak: ${pass.totalDailyMinutes} dk / gün', style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                                Text('%${(pass.minutesRatio * 100).toInt()} Müsait', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // NFC Hardware Scan Visualizer
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: state == NfcScanState.scanning
                            ? Colors.cyan.withValues(alpha: 0.1)
                            : (state == NfcScanState.success
                                ? Colors.green.withValues(alpha: 0.1)
                                : (state == NfcScanState.failedQuota
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : colors.surfaceContainerLow)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: state == NfcScanState.scanning
                              ? Colors.cyan
                              : (state == NfcScanState.success
                                  ? Colors.green
                                  : (state == NfcScanState.failedQuota ? Colors.red : colors.outlineVariant.withValues(alpha: 0.4))),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            state == NfcScanState.scanning
                                ? Icons.nfc
                                : (state == NfcScanState.success
                                    ? Icons.lock_open_rounded
                                    : (state == NfcScanState.failedQuota ? Icons.cancel : Icons.contactless)),
                            size: 64,
                            color: state == NfcScanState.scanning
                                ? Colors.cyan
                                : (state == NfcScanState.success
                                    ? Colors.green
                                    : (state == NfcScanState.failedQuota ? Colors.red : colors.primary)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state == NfcScanState.scanning
                                ? 'NFC Sinyali Aranıyor...'
                                : (state == NfcScanState.success
                                    ? 'Kilit Açıldı! Sürüş Başladı.'
                                    : (state == NfcScanState.failedQuota ? 'Sürüş Hakkı Yetersiz!' : 'NFC Dokundurmaya Hazır')),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (nfc.lastScanMessage != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              nfc.lastScanMessage!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    FilledButton.icon(
                      onPressed: state == NfcScanState.scanning
                          ? null
                          : () async {
                              final ok = await nfc.simulateTap();
                              if (ok) {
                                feedback.postSuccess(
                                  title: 'NFC Sürüş Başlatıldı',
                                  message: 'YOL-PASS okundu. Kalan süre: ${nfc.pass.remainingMinutes} dakika.',
                                );
                              } else {
                                feedback.postFailure(
                                  title: 'NFC Sürüş Reddedildi',
                                  message: 'Günlük sürüş limitiniz dolmuştur.',
                                  code: 'ERR_NFC_QUOTA',
                                );
                              }
                            },
                      icon: const Icon(Icons.nfc),
                      label: const Text('NFC Kartı Dokundur (Başarılı Senaryo)'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF0F766E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await nfc.simulateTap(forceQuotaExceeded: true);
                              feedback.postFailure(
                                title: 'Kota Aşım Hatası',
                                message: 'Günlük sürüş hakkınız tükendi.',
                                code: 'NFC_LIMIT',
                              );
                            },
                            icon: const Icon(Icons.error_outline, size: 18),
                            label: const Text('Kota Dolu Hatası'),
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              nfc.rechargeQuota();
                              feedback.postSuccess(
                                title: 'Kota Yenilendi',
                                message: '120 dakikalık günlük sürüş hakkı tanımlandı.',
                              );
                            },
                            icon: const Icon(Icons.restore, size: 18),
                            label: const Text('Hakkı Yenile'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
