import 'package:flutter/material.dart';

import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_plan.dart';

class NumericProgressSheet extends StatefulWidget {
  const NumericProgressSheet({
    super.key,
    required this.habit,
    required this.currentValue,
    required this.onSave,
  });

  final Habit habit;
  final int currentValue;
  final void Function(int addValue, String? note) onSave;

  @override
  State<NumericProgressSheet> createState() => _NumericProgressSheetState();
}

class _NumericProgressSheetState extends State<NumericProgressSheet> {
  late int _addValue;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final plan = widget.habit.currentPlan;
    final isDuration = plan?.targetType == HabitTargetType.duration;
    _addValue = isDuration ? 15 : 5;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plan = widget.habit.currentPlan;
    final unit = plan?.unit ?? '';
    final target = plan?.targetValue ?? 1;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(widget.habit.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habit.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hedef: $target $unit • Şu ana kadar: ${widget.currentValue} $unit',
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
          const SizedBox(height: 24),
          Text(
            'Eklenecek Miktar ($unit)',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (_addValue > 1) {
                    setState(() => _addValue--);
                  }
                },
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+$_addValue $unit',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton.filledTonal(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _addValue++),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick choice chips
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [1, 5, 10, 25].map((amt) {
              return ActionChip(
                label: Text('+$amt'),
                onPressed: () => setState(() => _addValue = amt),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Kişisel Not (İsteğe bağlı)',
              hintText: 'Bugünkü ilerlemen hakkında bir şeyler yaz...',
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
            maxLength: 500,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              widget.onSave(
                _addValue,
                _noteController.text.trim().isNotEmpty
                    ? _noteController.text.trim()
                    : null,
              );
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Kaydet ve Tamamla'),
          ),
        ],
      ),
    );
  }
}
