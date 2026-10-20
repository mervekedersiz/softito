import 'package:flutter/material.dart';

import '../../../../app/app_destination.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/constants/rental_locations.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_vehicle_image.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/services/booking_validator.dart';
import '../widgets/booking_confirm_dialog.dart';
import '../widgets/date_time_form_field.dart';
import '../widgets/price_summary_card.dart';

/// Rental request form. Nothing is stored unless every field validates and
/// the user confirms the summary dialog.
class BookingFormPage extends StatefulWidget {
  const BookingFormPage({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _endKey = GlobalKey<FormFieldState<DateTime>>();

  String? _pickup;
  String? _return;
  late DateTime? _start = _nextFullHour();
  DateTime? _end;

  static DateTime _nextFullHour() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen hatalı alanları düzeltin.')),
      );
      return;
    }
    final deps = AppScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final vehicle = widget.vehicle;
    final pickup = _pickup!;
    final returnTo = _return!;
    final start = _start!;
    final end = _end!;

    final confirmed = await showBookingConfirmDialog(
      context,
      vehicle: vehicle,
      pickupLocation: pickup,
      returnLocation: returnTo,
      startAt: start,
      endAt: end,
    );
    if (confirmed != true) return;

    try {
      await deps.bookings.submit(
        vehicle: vehicle,
        pickupLocation: pickup,
        returnLocation: returnTo,
        startAt: start,
        endAt: end,
      );
    } on ArgumentError catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message.toString())));
      return;
    }
    deps.tab.value = AppDestination.bookings;
    navigator.popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Demo rezervasyon talebi oluşturuldu. '
          'Gerçek bir rezervasyon veya ödeme yapılmadı.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehicle = widget.vehicle;

    return Scaffold(
      appBar: AppBar(title: const Text('Kiralama talebi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _VehicleSummary(vehicle: vehicle),
                const SizedBox(height: 24),
                _locationField(
                  label: 'Alış konumu',
                  icon: Icons.trip_origin,
                  value: _pickup,
                  error: 'Alış konumunu seçin.',
                  onChanged: (v) => setState(() => _pickup = v),
                ),
                const SizedBox(height: 16),
                _locationField(
                  label: 'Teslim konumu',
                  icon: Icons.flag_outlined,
                  value: _return,
                  error: 'Teslim konumunu seçin.',
                  onChanged: (v) => setState(() => _return = v),
                ),
                const SizedBox(height: 16),
                DateTimeFormField(
                  label: 'Başlangıç tarihi ve saati',
                  icon: Icons.event_available,
                  initialValue: _start,
                  suggest: _nextFullHour,
                  validator: (v) => BookingValidator.start(v, DateTime.now()),
                  onChanged: (v) {
                    setState(() => _start = v);
                    if (_end != null) _endKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 16),
                DateTimeFormField(
                  key: _endKey,
                  label: 'Bitiş tarihi ve saati',
                  icon: Icons.event_busy,
                  suggest: () =>
                      (_start ?? _nextFullHour()).add(const Duration(days: 1)),
                  validator: (v) => BookingValidator.end(v, _start),
                  onChanged: (v) => setState(() => _end = v),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Başlanan her 24 saatlik süre 1 gün ücretlenir '
                        '(örn. 25 saat = 2 gün).',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PriceSummaryCard(
                  dailyPrice: vehicle.dailyPrice,
                  start: _start,
                  end: _end,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Talebi incele'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationField({
    required String label,
    required IconData icon,
    required String? value,
    required String error,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      items: [
        for (final location in rentalLocations)
          DropdownMenuItem(
            value: location,
            child: Text(location, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
      validator: (v) => BookingValidator.location(v, message: error),
    );
  }
}

class _VehicleSummary extends StatelessWidget {
  const _VehicleSummary({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: AppVehicleImage(
              asset: vehicle.imageAsset,
              semanticLabel: '${vehicle.name} görseli (temsili)',
              aspectRatio: 4 / 3,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${formatLira(vehicle.dailyPrice)} / gün (demo)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
