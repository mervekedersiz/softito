import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/app_scope.dart';

Future<void> showPriceFilterSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const PriceFilterSheet(),
  );
}

/// Bottom sheet with min/max daily price fields. Min must be <= max.
class PriceFilterSheet extends StatefulWidget {
  const PriceFilterSheet({super.key});

  @override
  State<PriceFilterSheet> createState() => _PriceFilterSheetState();
}

class _PriceFilterSheetState extends State<PriceFilterSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _min;
  late final TextEditingController _max;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _min = TextEditingController();
    _max = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final filter = AppScope.of(context).vehicles.filter;
      _min.text = filter.minPrice?.toString() ?? '';
      _max.text = filter.maxPrice?.toString() ?? '';
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final amount = int.tryParse(text);
    if (amount == null || amount <= 0) return 'Geçerli bir tutar girin.';
    return null;
  }

  String? _validateMax(String? value) {
    final base = _validateAmount(value);
    if (base != null) return base;
    final min = int.tryParse(_min.text.trim());
    final max = int.tryParse(value?.trim() ?? '');
    if (min != null && max != null && min > max) {
      return 'Üst limit, alt limitten küçük olamaz.';
    }
    return null;
  }

  void _apply({required bool clear}) {
    final controller = AppScope.of(context).vehicles;
    if (!clear && !_formKey.currentState!.validate()) return;
    final min = clear ? null : int.tryParse(_min.text.trim());
    final max = clear ? null : int.tryParse(_max.text.trim());
    controller.updateFilter(controller.filter.withPriceRange(min, max));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Günlük fiyat aralığı', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _field(_min, 'En az (₺)', _validateAmount)),
                const SizedBox(width: 12),
                Expanded(child: _field(_max, 'En çok (₺)', _validateMax)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _apply(clear: true),
                    child: const Text('Temizle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _apply(clear: false),
                    child: const Text('Uygula'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    FormFieldValidator<String> validator,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
