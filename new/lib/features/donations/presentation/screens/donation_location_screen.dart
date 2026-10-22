import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/donation_location.dart';
import '../../domain/repositories/device_location_service.dart';
import '../providers/donation_location_providers.dart';
import '../widgets/donation_map_picker.dart';

class DonationLocationScreen extends ConsumerStatefulWidget {
  final DonationLocationKind kind;
  const DonationLocationScreen({super.key, required this.kind});

  @override
  ConsumerState<DonationLocationScreen> createState() =>
      _DonationLocationScreenState();
}

class _DonationLocationScreenState
    extends ConsumerState<DonationLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _label = TextEditingController();
  final _address = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  GeoPoint? _point;
  bool _initialized = false;
  bool _locating = false;
  bool _saving = false;
  bool _opening = false;
  String? _error;
  String? _notice;

  bool get _busy => _locating || _saving || _opening;
  bool get _pickup => widget.kind == DonationLocationKind.pickup;

  @override
  void dispose() {
    _label.dispose();
    _address.dispose();
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  void _setPoint(GeoPoint point) {
    _point = point;
    _latitude.text = point.latitude.toStringAsFixed(6);
    _longitude.text = point.longitude.toStringAsFixed(6);
  }

  void _showError(Object error, String fallback) {
    if (!mounted) return;
    setState(() {
      _notice = null;
      _error = error is LocationFailure
          ? error.message
          : error is FormatException
          ? error.message
          : fallback;
    });
  }

  Future<void> _locate() async {
    setState(() {
      _locating = true;
      _error = null;
      _notice = null;
    });
    try {
      final point = await ref
          .read(deviceLocationServiceProvider)
          .currentPosition();
      if (!mounted) return;
      setState(() {
        _setPoint(point);
        _notice = 'Konum alındı. Pini kontrol edip kaydedin.';
      });
    } catch (error) {
      _showError(error, 'Konum alınamadı. Haritadan pin seçebilirsiniz.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _applyCoordinates() {
    try {
      final lat = double.tryParse(_latitude.text.trim().replaceAll(',', '.'));
      final lon = double.tryParse(_longitude.text.trim().replaceAll(',', '.'));
      if (lat == null || lon == null) {
        throw const FormatException('Enlem ve boylamı sayı olarak girin.');
      }
      final point = GeoPoint(lat, lon);
      setState(() {
        _setPoint(point);
        _error = null;
        _notice = null;
      });
    } catch (error) {
      _showError(error, 'Koordinatlar geçersiz.');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _busy) return;
    setState(() {
      _saving = true;
      _error = null;
      _notice = null;
    });
    try {
      await ref
          .read(donationLocationsProvider.notifier)
          .save(
            kind: widget.kind,
            point: _point,
            label: _label.text,
            address: _address.text,
          );
      if (!mounted) return;
      setState(() => _notice = 'Konum bu cihazda kaydedildi.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Konum kaydedildi.')));
    } catch (error) {
      _showError(
        error,
        'Konum kaydedilemedi. Önceki kayıt korundu; tekrar deneyin.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openDirections() async {
    final point = _point;
    if (point == null || _busy) return;
    setState(() {
      _opening = true;
      _error = null;
    });
    try {
      await ref.read(locationNavigationServiceProvider).openDirections(point);
    } catch (error) {
      _showError(error, 'Yol tarifi açılamadı. Tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _openAttribution() async {
    try {
      await ref.read(locationNavigationServiceProvider).openAttribution();
    } catch (error) {
      _showError(error, 'Harita kaynak bilgisi açılamadı.');
    }
  }

  Future<void> _remove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kayıtlı konum silinsin mi?'),
        content: const Text(
          'Bu cihazdaki kayıtlı pin ve adres açıklaması silinecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Konumu Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(donationLocationsProvider.notifier).remove(widget.kind);
      if (!mounted) return;
      setState(() {
        _point = null;
        _latitude.clear();
        _longitude.clear();
        _address.clear();
        _label.text = _pickup ? 'Kurye alım adresi' : 'Teslimat noktası';
        _notice = 'Kayıtlı konum silindi.';
      });
    } catch (error) {
      _showError(error, 'Konum silinemedi. Tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(donationLocationsProvider);
    final saved = locations.value?[widget.kind];
    return Scaffold(
      appBar: AppBar(
        title: Text(_pickup ? 'Kurye Teslimi' : 'Konuma Git'),
        actions: [
          if (saved != null)
            IconButton(
              tooltip: 'Kayıtlı konumu sil',
              onPressed: _busy ? null : _remove,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: locations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Kayıtlı konum yüklenemedi.'),
                TextButton(
                  onPressed: () => ref.invalidate(donationLocationsProvider),
                  child: const Text('Tekrar dene'),
                ),
              ],
            ),
          ),
        ),
        data: (_) {
          if (!_initialized) {
            _initialized = true;
            _label.text =
                saved?.label ??
                (_pickup ? 'Kurye alım adresi' : 'Teslimat noktası');
            _address.text = saved?.address ?? '';
            if (saved != null) _setPoint(saved.point);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _pickup
                            ? 'Paket nereden alınacak?'
                            : 'Teslimat noktanı belirle',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _pickup
                            ? 'Kurye için alım adresini haritadan seçip cihazına kaydet. Bu işlem kurye çağrısı oluşturmaz.'
                            : 'Haritaya dokunarak pin ekle. Pini taşımak için başka bir noktaya dokunabilirsin.',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.icon(
                          key: const Key('gps-location'),
                          onPressed: _busy ? null : _locate,
                          icon: _locating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.my_location),
                          label: Text(
                            _locating ? 'Konum alınıyor…' : 'Konumumu Al (GPS)',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Konum izni yalnız bu düğmeye bastığında istenir. İzin vermeden de pin seçebilirsin.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DonationMapPicker(
                        point: _point,
                        enabled: !_busy,
                        onPick: (point) => setState(() {
                          _setPoint(point);
                          _error = null;
                          _notice = null;
                        }),
                        onAttribution: _openAttribution,
                      ),
                      const SizedBox(height: 12),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _point == null
                              ? 'Henüz pin seçilmedi.'
                              : 'Seçilen pin: ${_point!.coordinates}',
                          key: const Key('selected-location'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      ExpansionTile(
                        title: const Text('Koordinat gir'),
                        subtitle: const Text(
                          'Harita yüklenmiyorsa da kullanılabilir.',
                        ),
                        tilePadding: EdgeInsets.zero,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _latitude,
                                  key: const Key('location-latitude'),
                                  enabled: !_busy,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                        signed: true,
                                      ),
                                  decoration: const InputDecoration(
                                    labelText: 'Enlem (−90 / 90)',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _longitude,
                                  key: const Key('location-longitude'),
                                  enabled: !_busy,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                        signed: true,
                                      ),
                                  decoration: const InputDecoration(
                                    labelText: 'Boylam (−180 / 180)',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              key: const Key('apply-coordinates'),
                              onPressed: _busy ? null : _applyCoordinates,
                              icon: const Icon(Icons.add_location_alt_outlined),
                              label: const Text('Pini Güncelle'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _label,
                        enabled: !_busy,
                        maxLength: 100,
                        key: const Key('location-label'),
                        decoration: const InputDecoration(
                          labelText: 'Konum adı',
                        ),
                        validator: (text) => text == null || text.trim().isEmpty
                            ? 'Konum adı girin.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _address,
                        enabled: !_busy,
                        key: const Key('location-address'),
                        maxLength: 500,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: _pickup
                              ? 'Alım adresi / kapı, kat, tarif (isteğe bağlı)'
                              : 'Adres açıklaması (isteğe bağlı)',
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            _error!,
                            key: const Key('location-error'),
                            style: const TextStyle(color: AppColors.danger),
                          ),
                        ),
                      ],
                      if (_notice != null) ...[
                        const SizedBox(height: 8),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            _notice!,
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        key: const Key('save-location'),
                        onPressed: _busy ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _pickup ? 'Alım Adresini Kaydet' : 'Konumu Kaydet',
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        key: const Key('route-location'),
                        onPressed: _point == null || _busy
                            ? null
                            : _openDirections,
                        icon: const Icon(Icons.directions_outlined),
                        label: const Text('Google Haritalar’da Yol Tarifi'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kaydettiğin pin ve adres bu cihazda tutulur. Yol tarifi açıldığında seçtiğin koordinat Google Haritalar’a iletilir.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
