import 'package:flutter/material.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_filter.dart';
import '../controllers/vehicle_controller.dart';

/// Comprehensive Sahibinden-style filter modal with multi-modal categories,
/// fuel tank minimum percentage, year, km, and transmission.
class SahibindenFilterSheet extends StatefulWidget {
  const SahibindenFilterSheet({required this.controller, super.key});

  final VehicleController controller;

  static Future<void> show(BuildContext context, VehicleController controller) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SahibindenFilterSheet(controller: controller),
    );
  }

  @override
  State<SahibindenFilterSheet> createState() => _SahibindenFilterSheetState();
}

class _SahibindenFilterSheetState extends State<SahibindenFilterSheet> {
  late VehicleFilter _filter;
  double _minFuel = 0;

  @override
  void initState() {
    super.initState();
    _filter = widget.controller.filter;
    _minFuel = (_filter.minFuelPercent ?? 0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sahibinden Tarzı Detaylı Filtre',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filter = VehicleFilter.none;
                      _minFuel = 0;
                    });
                  },
                  child: const Text('Temizle'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Kategori / Mod Seçimi
            Text('Araç Türü / Mobilite Modu', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Tüm Modlar'),
                  selected: _filter.category == null,
                  onSelected: (s) => setState(() => _filter = _filter.withCategory(null)),
                ),
                for (final cat in VehicleCategory.values)
                  ChoiceChip(
                    label: Text(cat.label),
                    selected: _filter.category == cat,
                    onSelected: (s) => setState(() => _filter = _filter.withCategory(s ? cat : null)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Vites & Yakıt
            Text('Vites & Yakıt', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Otomatik'),
                  selected: _filter.transmission == Transmission.automatic,
                  onSelected: (s) => setState(() => _filter = _filter.withTransmission(s ? Transmission.automatic : null)),
                ),
                ChoiceChip(
                  label: const Text('Manuel'),
                  selected: _filter.transmission == Transmission.manual,
                  onSelected: (s) => setState(() => _filter = _filter.withTransmission(s ? Transmission.manual : null)),
                ),
                ChoiceChip(
                  label: const Text('Elektrik'),
                  selected: _filter.fuelType == FuelType.electric,
                  onSelected: (s) => setState(() => _filter = _filter.withFuelType(s ? FuelType.electric : null)),
                ),
                ChoiceChip(
                  label: const Text('Hibrit'),
                  selected: _filter.fuelType == FuelType.hybrid,
                  onSelected: (s) => setState(() => _filter = _filter.withFuelType(s ? FuelType.hybrid : null)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Depoyu söylüyor filtresi: En az depo/şarj yüzdesi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Depo / Şarj Seviyesi', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text(_minFuel == 0 ? 'Farketmez' : 'En az %${_minFuel.toInt()}'),
              ],
            ),
            Slider(
              value: _minFuel,
              min: 0,
              max: 90,
              divisions: 9,
              label: _minFuel == 0 ? 'Farketmez' : '%${_minFuel.toInt()}',
              onChanged: (v) {
                setState(() {
                  _minFuel = v;
                  _filter = _filter.withMinFuelPercent(v > 0 ? v.toInt() : null);
                });
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                widget.controller.updateFilter(_filter);
                Navigator.of(context).pop();
              },
              child: const Text('Filtreleri Uygula'),
            ),
          ],
        ),
      ),
    );
  }
}
