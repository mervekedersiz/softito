import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Form field that picks a date, then a time, and stores a [DateTime].
///
/// [suggest] provides the date the pickers open on when nothing is chosen.
class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    required String label,
    required IconData icon,
    required DateTime Function() suggest,
    super.key,
    super.initialValue,
    super.validator,
    ValueChanged<DateTime?>? onChanged,
  }) : super(
         autovalidateMode: AutovalidateMode.onUserInteraction,
         builder: (state) {
           Future<void> pick() async {
             final base = state.value ?? suggest();
             final today = DateTime.now();
             final firstDate = DateTime(today.year, today.month, today.day);
             final date = await showDatePicker(
               context: state.context,
               initialDate: base.isBefore(firstDate) ? firstDate : base,
               firstDate: firstDate,
               lastDate: firstDate.add(const Duration(days: 365)),
               helpText: label,
             );
             if (date == null || !state.mounted) return;
             final time = await showTimePicker(
               context: state.context,
               initialTime: TimeOfDay.fromDateTime(base),
               helpText: label,
             );
             if (time == null || !state.mounted) return;
             final picked = DateTime(
               date.year,
               date.month,
               date.day,
               time.hour,
               time.minute,
             );
             state.didChange(picked);
             onChanged?.call(picked);
           }

           final value = state.value;
           return Semantics(
             button: true,
             label: value == null
                 ? '$label, seçilmedi'
                 : '$label, ${formatDateTime(value)}',
             excludeSemantics: true,
             onTap: pick,
             child: InkWell(
               onTap: pick,
               borderRadius: BorderRadius.circular(16),
               child: InputDecorator(
                 isEmpty: value == null,
                 decoration: InputDecoration(
                   labelText: label,
                   prefixIcon: Icon(icon),
                   suffixIcon: const Icon(Icons.edit_calendar),
                   errorText: state.errorText,
                 ),
                 child: Text(value == null ? '' : formatDateTime(value)),
               ),
             ),
           );
         },
       );
}
