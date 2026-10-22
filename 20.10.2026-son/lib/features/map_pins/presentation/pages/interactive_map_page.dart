import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../domain/entities/map_pin.dart';

class InteractiveMapPage extends StatefulWidget {
  const InteractiveMapPage({super.key});

  @override
  State<InteractiveMapPage> createState() => _InteractiveMapPageState();
}

class _InteractiveMapPageState extends State<InteractiveMapPage> {
  bool _addPinMode = false;

  void _onMapTapped(TapUpDetails details, BoxConstraints constraints) {
    final x = details.localPosition.dx / constraints.maxWidth;
    final y = details.localPosition.dy / constraints.maxHeight;

    if (_addPinMode) {
      _showAddPinDialog(x, y);
    } else {
      AppScope.of(context).mapPins.selectPin(null);
    }
  }

  Future<void> _showAddPinDialog(double x, double y) async {
    final titleCtrl = TextEditingController(text: 'Yeni İstasyon Noktası');
    final subCtrl = TextEditingController(text: 'Kullanıcı tarafından eklendi');
    MapPinType selectedType = MapPinType.vehicle;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_location_alt, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text('Haritaya Pin Ekle'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Harita Koordinatı: X: ${(x * 100).toInt()}% • Y: ${(y * 100).toInt()}%',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Pin Başlığı'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subCtrl,
                decoration: const InputDecoration(labelText: 'Açıklama / Konum Detayı'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<MapPinType>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'Pin Türü'),
                items: [
                  for (final type in MapPinType.values)
                    DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(type.icon, color: type.color, size: 18),
                          const SizedBox(width: 8),
                          Text(type.label),
                        ],
                      ),
                    ),
                ],
                onChanged: (t) => setDlgState(() => selectedType = t ?? MapPinType.vehicle),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Pini Haritaya Bırak'),
            ),
          ],
        ),
      ),
    );

    if (result == true && mounted) {
      AppScope.of(context).mapPins.addPin(
        title: titleCtrl.text.trim(),
        subtitle: subCtrl.text.trim(),
        type: selectedType,
        normalizedX: x,
        normalizedY: y,
      );
      setState(() => _addPinMode = false);

      AppScope.of(context).feedback.postSuccess(
        title: 'Harita Pini Eklendi',
        message: '${titleCtrl.text} noktası harita üzerinde görüntülendi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final mapPins = AppScope.of(context).mapPins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İnteraktif Harita & Pinler'),
        actions: [
          IconButton(
            tooltip: _addPinMode ? 'Pin Modunu Kapat' : 'Haritaya Pin Ekle',
            icon: Icon(_addPinMode ? Icons.pin_drop : Icons.add_location_alt_outlined),
            color: _addPinMode ? Colors.amber : null,
            onPressed: () {
              setState(() => _addPinMode = !_addPinMode);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_addPinMode
                      ? 'Harita üzerine dokunarak istediğiniz yere pin ekleyebilirsiniz.'
                      : 'Pin ekleme modu kapatıldı.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: mapPins,
        builder: (context, _) {
          final pins = mapPins.pins;
          final selected = mapPins.selectedPin;

          return Column(
            children: [
              // Pin Type Filter Bar
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Tüm Pinler'),
                        selected: mapPins.typeFilter == null,
                        onSelected: (_) => mapPins.setFilter(null),
                      ),
                    ),
                    for (final type in MapPinType.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(type.icon, size: 16, color: type.color),
                          label: Text(type.label),
                          selected: mapPins.typeFilter == type,
                          onSelected: (_) => mapPins.setFilter(mapPins.typeFilter == type ? null : type),
                        ),
                      ),
                  ],
                ),
              ),
              if (_addPinMode)
                Container(
                  color: Colors.amber.withValues(alpha: 0.15),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(
                    children: [
                      Icon(Icons.touch_app, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'PİN EKLEME MODU AÇIK: Haritada istediğiniz konuma dokunun.',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              // Map Viewport Canvas
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final mapW = constraints.maxWidth;
                    final mapH = constraints.maxHeight;

                    return GestureDetector(
                      onTapUp: (details) => _onMapTapped(details, constraints),
                      child: Stack(
                        children: [
                          // Vector Map Background
                          CustomPaint(
                            size: Size(mapW, mapH),
                            painter: _CityVectorMapPainter(),
                          ),
                          // Dropped Pins
                          for (final pin in pins)
                            Positioned(
                              left: (pin.normalizedX * mapW) - 20,
                              top: (pin.normalizedY * mapH) - 40,
                              child: GestureDetector(
                                onTap: () => mapPins.selectPin(pin),
                                child: _PinMarkerWidget(
                                  pin: pin,
                                  isSelected: selected?.id == pin.id,
                                ),
                              ),
                            ),
                          // Pin Details Card at bottom
                          if (selected != null)
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: selected.type.color.withValues(alpha: 0.2),
                                        child: Icon(selected.type.icon, color: selected.type.color, size: 28),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              selected.title,
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              selected.subtitle,
                                              style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton.filledTonal(
                                        icon: const Icon(Icons.navigation),
                                        tooltip: 'Buraya Git',
                                        onPressed: () {
                                          AppScope.of(context).feedback.postSuccess(
                                            title: 'Rota Başlatıldı',
                                            message: '${selected.title} noktasına navigasyon hazırlandı.',
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PinMarkerWidget extends StatelessWidget {
  const _PinMarkerWidget({required this.pin, required this.isSelected});

  final MapPin pin;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = pin.type.color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSelected ? 44 : 36,
          height: isSelected ? 44 : 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: isSelected ? 12 : 6,
                spreadRadius: isSelected ? 3 : 1,
              ),
            ],
          ),
          child: Icon(pin.type.icon, color: Colors.white, size: isSelected ? 22 : 18),
        ),
        Container(
          width: 4,
          height: 6,
          color: Colors.black87,
        ),
      ],
    );
  }
}

class _CityVectorMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Water body (Bosphorus style)
    final waterPaint = Paint()..color = const Color(0xFF1E3A5F).withValues(alpha: 0.25);
    final waterPath = Path()
      ..moveTo(size.width * 0.45, 0)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.4, size.width * 0.35, size.height)
      ..lineTo(size.width * 0.55, size.height)
      ..quadraticBezierTo(size.width * 0.70, size.height * 0.4, size.width * 0.60, 0)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Roads and blocks
    final roadPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.22)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final highwayPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.35)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    // Major Highway
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.30), highwayPaint);
    canvas.drawLine(Offset(0, size.height * 0.70), Offset(size.width, size.height * 0.65), highwayPaint);

    // City grid streets
    for (double i = 40; i < size.width; i += 70) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), roadPaint);
    }
    for (double j = 40; j < size.height; j += 60) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
