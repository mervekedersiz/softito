import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/donation_location.dart';

class DonationMapPicker extends StatefulWidget {
  final GeoPoint? point;
  final bool enabled;
  final ValueChanged<GeoPoint> onPick;
  final VoidCallback onAttribution;

  const DonationMapPicker({
    super.key,
    required this.point,
    required this.onPick,
    required this.onAttribution,
    this.enabled = true,
  });

  @override
  State<DonationMapPicker> createState() => _DonationMapPickerState();
}

class _DonationMapPickerState extends State<DonationMapPicker> {
  final _controller = MapController();
  bool _ready = false;
  bool _tilesFailed = false;
  int _retry = 0;

  @override
  void didUpdateWidget(covariant DonationMapPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_ready && widget.point != null && widget.point != oldWidget.point) {
      final point = widget.point!;
      _controller.move(
        LatLng(point.latitude, point.longitude),
        _controller.camera.zoom < 14 ? 15 : _controller.camera.zoom,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoom(double delta) {
    if (!_ready) return;
    final camera = _controller.camera;
    _controller.move(camera.center, (camera.zoom + delta).clamp(2, 19));
  }

  @override
  Widget build(BuildContext context) {
    final point = widget.point;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 340,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: point == null
                    ? const LatLng(20, 0)
                    : LatLng(point.latitude, point.longitude),
                initialZoom: point == null ? 2 : 15,
                minZoom: 2,
                maxZoom: 19,
                onMapReady: () => _ready = true,
                onTap: (_, position) {
                  if (widget.enabled) {
                    widget.onPick(
                      GeoPoint(
                        position.latitude,
                        ((position.longitude + 180) % 360) - 180,
                      ),
                    );
                  }
                },
              ),
              children: [
                TileLayer(
                  key: ValueKey(_retry),
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.freshtrack.app.freshtrack',
                  maxNativeZoom: 19,
                  errorTileCallback: (_, __, ___) {
                    if (mounted && !_tilesFailed) {
                      setState(() => _tilesFailed = true);
                    }
                  },
                ),
                if (point != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(point.latitude, point.longitude),
                        width: 48,
                        height: 48,
                        alignment: Alignment.topCenter,
                        child: Semantics(
                          label: 'Seçilen konum pini',
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 48,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                child: Column(
                  children: [
                    IconButton(
                      tooltip: 'Yakınlaştır',
                      onPressed: widget.enabled ? () => _zoom(1) : null,
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(
                      tooltip: 'Uzaklaştır',
                      onPressed: widget.enabled ? () => _zoom(-1) : null,
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.white.withValues(alpha: 0.94),
                child: TextButton(
                  onPressed: widget.onAttribution,
                  child: const Text(
                    '© OpenStreetMap contributors',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            if (_tilesFailed)
              Positioned(
                left: 12,
                right: 72,
                top: 12,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harita yüklenemedi. GPS veya koordinat girişiyle konum seçebilirsiniz.',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _tilesFailed = false;
                            _retry++;
                          }),
                          child: const Text('Haritayı tekrar yükle'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
