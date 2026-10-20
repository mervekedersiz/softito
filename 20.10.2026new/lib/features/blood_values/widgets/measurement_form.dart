import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/blood_measurement.dart';

class MeasurementFormSheet extends StatefulWidget {
  final MeasurementType initialType;
  final Function({
    required MeasurementType type,
    required String rawValue,
    required DateTime measuredAt,
    required String source,
    String? rawMin,
    String? rawMax,
  })
  onSave;

  const MeasurementFormSheet({
    super.key,
    required this.initialType,
    required this.onSave,
  });

  @override
  State<MeasurementFormSheet> createState() => _MeasurementFormSheetState();
}

class _MeasurementFormSheetState extends State<MeasurementFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late MeasurementType _selectedType;
  late DateTime _selectedDate;

  late final TextEditingController _valueController;
  late final TextEditingController _sourceController;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedDate = DateTime.now();
    _valueController = TextEditingController();
    _sourceController = TextEditingController();
    _minController = TextEditingController();
    _maxController = TextEditingController();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _sourceController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        type: _selectedType,
        rawValue: _valueController.text,
        measuredAt: _selectedDate,
        source: _sourceController.text,
        rawMin: _minController.text.isNotEmpty ? _minController.text : null,
        rawMax: _maxController.text.isNotEmpty ? _maxController.text : null,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.addMeasurement,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Measurement Type Selector
              DropdownButtonFormField<MeasurementType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Gösterge Türü'),
                items: MeasurementType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text('${t.label} (${t.standardUnit})'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedType = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Value Input (Supports comma/dot)
              TextFormField(
                controller: _valueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText:
                      '${AppStrings.measurementValue} (${_selectedType.standardUnit})',
                  hintText: 'Örn: 14,2',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Değer boş bırakılamaz.';
                  }
                  final normalized = val.replaceAll(',', '.').trim();
                  final numVal = double.tryParse(normalized);
                  if (numVal == null || numVal <= 0) {
                    return 'Geçerli ve pozitif bir sayı giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Date Picker Field
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: AppStrings.measurementDate,
                    suffixIcon: Icon(Icons.calendar_today_rounded, size: 20),
                  ),
                  child: Text(
                    '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Source
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(
                  labelText: AppStrings.measurementSource,
                  hintText: 'Örn: Şişli Etfal Hastanesi',
                ),
              ),
              const SizedBox(height: 12),

              // Optional Reference Range
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Ref. Min (İsteğe bağlı)',
                        hintText: '13.0',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _maxController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Ref. Max (İsteğe bağlı)',
                        hintText: '17.5',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Ölçümü Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
