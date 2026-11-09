import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/reward.dart';

class RewardDetailSheet extends StatefulWidget {
  const RewardDetailSheet({
    super.key,
    required this.reward,
    required this.onSavePlan,
    required this.onRemovePlan,
  });

  final Reward reward;
  final Future<void> Function({
    required DateTime planAtUtc,
    required String planTimezone,
    String? placeName,
    String? planNote,
  })
  onSavePlan;
  final Future<void> Function() onRemovePlan;

  @override
  State<RewardDetailSheet> createState() => _RewardDetailSheetState();
}

class _RewardDetailSheetState extends State<RewardDetailSheet> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late final TextEditingController _placeController;
  late final TextEditingController _noteController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final r = widget.reward;
    _selectedDate = r.planAtUtc != null
        ? r.planAtUtc!.toLocal()
        : DateTime.now().add(const Duration(days: 1));
    _selectedTime = r.planAtUtc != null
        ? TimeOfDay.fromDateTime(r.planAtUtc!.toLocal())
        : const TimeOfDay(hour: 14, minute: 0);

    _placeController = TextEditingController(text: r.placeName ?? '');
    _noteController = TextEditingController(text: r.planNote ?? '');
  }

  @override
  void dispose() {
    _placeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitPlan() async {
    setState(() => _isSaving = true);
    final plannedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    ).toUtc();

    try {
      await widget.onSavePlan(
        planAtUtc: plannedDateTime,
        planTimezone: DateTime.now().timeZoneName,
        placeName: _placeController.text.trim().isNotEmpty
            ? _placeController.text.trim()
            : null,
        planNote: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : null,
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = widget.reward;
    final dateFormat = DateFormat('d MMMM yyyy, EEEE', 'tr_TR');

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
                Text(r.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ödül Planı Oluştur',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Date picker tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_rounded),
              title: const Text('Planlanan Tarih'),
              subtitle: Text(dateFormat.format(_selectedDate)),
              trailing: TextButton(
                onPressed: _pickDate,
                child: const Text('Değiştir'),
              ),
            ),
            // Time picker tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time_rounded),
              title: const Text('Saat'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: TextButton(
                onPressed: _pickTime,
                child: const Text('Değiştir'),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Mekan / Konum Adı (İsteğe bağlı)',
                hintText: 'Örn: Kadıköy Moda Sahili veya Şehir Müzesi',
                prefixIcon: Icon(Icons.place_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Özel Not / Plan Detayı',
                hintText: 'Örn: Fotoğraf makinesini yanıma almayı unutma!',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              maxLength: 500,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isSaving ? null : _submitPlan,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded),
              label: const Text('Planı Onayla ve Kaydet'),
            ),
            if (r.isPlanned) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  await widget.onRemovePlan();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text(
                  'Planı Kaldır (Kazanıldı durumuna dön)',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
