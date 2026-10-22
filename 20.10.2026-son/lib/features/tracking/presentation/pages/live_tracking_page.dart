import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/feedback/app_feedback.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.of(context).telemetry.startTracking();
    });
  }

  @override
  void dispose() {
    // Note: will be stopped when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final telemetry = AppScope.of(context).telemetry;
    final feedback = AppScope.of(context).feedback;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      appBar: AppBar(
        title: const Text('Premium Canlı Takip & Telemetri'),
        backgroundColor: const Color(0xFF0A0F1D),
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.redAccent),
            ),
            child: const Row(
              children: [
                Icon(Icons.fiber_manual_record, color: Colors.redAccent, size: 14),
                SizedBox(width: 4),
                Text('CANLI GPS', style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListenableBuilder(
              listenable: telemetry,
              builder: (context, _) {
                final data = telemetry.telemetry;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Simulated Real-Time I-Frame / Video Stream Radar Container
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Dark high-tech radar simulation background
                            CustomPaint(
                              painter: _RadarBackgroundPainter(),
                            ),
                            // Camera watermark & timestamp overlay (i-frame style)
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'iFrame: stream://yol-telemetry/cam-01 • 1080p ${data.streamFps}fps',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    color: Colors.cyanAccent,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Açı: ${data.cameraAngle}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // Center Cockpit Crosshair & Speed indicator
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.6), width: 2),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${data.speedKmH}',
                                            style: const TextStyle(
                                              fontFamily: 'monospace',
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const Text(
                                            'KM/S',
                                            style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Bottom HUD details
                            Positioned(
                              left: 14,
                              bottom: 12,
                              child: Text(
                                'GPS: ${data.latitude.toStringAsFixed(4)}° N, ${data.longitude.toStringAsFixed(4)}° E',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 14,
                              bottom: 12,
                              child: Row(
                                children: [
                                  _AngleChip(label: 'Kokpit', isSelected: data.cameraAngle == 'Ön Kokpit', onTap: () => telemetry.switchCamera('Ön Kokpit')),
                                  const SizedBox(width: 4),
                                  _AngleChip(label: 'Uydu Radar', isSelected: data.cameraAngle == 'Uydu Radar', onTap: () => telemetry.switchCamera('Uydu Radar')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Telemetry Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.electric_bolt,
                            iconColor: Colors.amber,
                            title: 'Motor Gücü',
                            value: '${data.rpmOrKw} kW',
                            subtitle: 'Anlık Güç Çıkışı',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.battery_charging_full,
                            iconColor: const Color(0xFF10B981),
                            title: 'Batarya / Depo',
                            value: '%${data.fuelOrBatteryPercent}',
                            subtitle: 'Kalan Menzil: 430 km',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.alt_route,
                            iconColor: Colors.cyanAccent,
                            title: 'Rakım',
                            value: '${data.altitudeMeters} m',
                            subtitle: 'Hassas Barometre',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Remote Controls Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161F33),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Uzaktan Araç Kontrolü (Canlı IoT)',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  onPressed: () {
                                    telemetry.toggleDoors();
                                    final locked = telemetry.telemetry.isDoorsLocked;
                                    feedback.post(
                                      title: locked ? 'Kapılar Kilitlendi' : 'Kapı Kilidi Açıldı',
                                      message: 'Telemetri komutu araca iletildi.',
                                      status: AppFeedbackStatus.success,
                                    );
                                  },
                                  icon: Icon(data.isDoorsLocked ? Icons.lock : Icons.lock_open),
                                  label: Text(data.isDoorsLocked ? 'Kapı Kilitli' : 'Kapı Açık'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: data.isDoorsLocked ? Colors.teal.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  onPressed: () {
                                    telemetry.toggleLights();
                                    feedback.post(
                                      title: 'Farlar Tetiklendi',
                                      message: 'Araç aydınlatma durumu güncellendi.',
                                      status: AppFeedbackStatus.info,
                                    );
                                  },
                                  icon: Icon(data.areLightsOn ? Icons.lightbulb : Icons.lightbulb_outline),
                                  label: Text(data.areLightsOn ? 'Farlar Açık' : 'Farlar Kapalı'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    feedback.postSuccess(
                                      title: 'Korna Çalındı (Bip-Bip)',
                                      message: 'Park alanında araç konumu için sinyal verildi.',
                                    );
                                  },
                                  icon: const Icon(Icons.volume_up, size: 18),
                                  label: const Text('Korna Çal'),
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    feedback.postFailure(
                                      title: 'SOS Acil Çağrı Gönderildi',
                                      message: 'Acil durum ekiplerine GPS koordinatları iletildi.',
                                      code: 'SOS_ACTIVE',
                                    );
                                  },
                                  icon: const Icon(Icons.warning, color: Colors.redAccent, size: 18),
                                  label: const Text('Acil Durum (SOS)'),
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

class _AngleChip extends StatelessWidget {
  const _AngleChip({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyanAccent : Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 9)),
        ],
      ),
    );
  }
}

class _RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00ADB5).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 50, paint);
    canvas.drawCircle(center, 90, paint);
    canvas.drawCircle(center, 130, paint);

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
