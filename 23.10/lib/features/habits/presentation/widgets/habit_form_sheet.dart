import 'package:flutter/material.dart';

import '../../../../core/time/local_date.dart';
import '../../../../core/validation/validators.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_plan.dart';

class HabitFormSheet extends StatefulWidget {
  const HabitFormSheet({
    super.key,
    this.initialHabit,
    this.defaultCategory = HabitCategory.study,
    required this.onSave,
  });

  final Habit? initialHabit;
  final HabitCategory defaultCategory;
  final Future<void> Function(Habit habit, HabitPlan plan) onSave;

  @override
  State<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends State<HabitFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedEmoji;
  late final TextEditingController _titleController;
  late final TextEditingController _subcategoryController;
  late final TextEditingController _targetValueController;
  late final TextEditingController _unitController;

  late HabitCategory _category;
  late HabitTargetType _targetType;
  late Set<int> _selectedWeekdays;
  late bool _rewardEligible;
  bool _isSaving = false;

  final List<String> _emojiCatalog = [
    '📚',
    '📖',
    '💻',
    '📝',
    '🎯',
    '⏳',
    '💡',
    '🧠',
    '🤲',
    '🌱',
    '🕊️',
    '🤝',
    '☕',
    '🚶‍♂️',
    '🧘',
    '🌟',
  ];

  @override
  void initState() {
    super.initState();
    final h = widget.initialHabit;
    final plan = h?.currentPlan;

    _category = h?.category ?? widget.defaultCategory;
    _selectedEmoji = h?.emoji ?? _category.defaultEmoji;
    _titleController = TextEditingController(text: h?.title ?? '');
    _subcategoryController = TextEditingController(
      text:
          h?.subcategory ??
          (_category == HabitCategory.spiritual ? 'Maneviyat' : 'Ders'),
    );

    _targetType = plan?.targetType ?? HabitTargetType.check;
    _targetValueController = TextEditingController(
      text: (plan?.targetValue ?? 1).toString(),
    );
    _unitController = TextEditingController(text: plan?.unit ?? 'kez');
    _selectedWeekdays = plan != null
        ? plan.weekdays.toSet()
        : {1, 2, 3, 4, 5, 6, 7};
    _rewardEligible =
        plan?.rewardEligible ?? (_category == HabitCategory.study);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subcategoryController.dispose();
    _targetValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir tekrar günü seçmelisiniz.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final habitId =
        widget.initialHabit?.id ??
        'hab_${DateTime.now().millisecondsSinceEpoch}';
    final planId =
        widget.initialHabit?.currentPlan?.id ??
        'plan_${DateTime.now().millisecondsSinceEpoch}';

    final parsedTarget = int.tryParse(_targetValueController.text.trim()) ?? 1;

    final habit = Habit(
      id: habitId,
      title: _titleController.text.trim(),
      emoji: _selectedEmoji,
      category: _category,
      subcategory: _subcategoryController.text.trim().isEmpty
          ? 'Genel'
          : _subcategoryController.text.trim(),
      createdAtUtc: widget.initialHabit?.createdAtUtc ?? DateTime.now().toUtc(),
    );

    final plan = HabitPlan(
      id: planId,
      habitId: habitId,
      effectiveFromDate: LocalDate.fromDateTime(DateTime.now()),
      weekdays: _selectedWeekdays.toList()..sort(),
      targetType: _targetType,
      targetValue: _targetType == HabitTargetType.check ? 1 : parsedTarget,
      unit: _targetType == HabitTargetType.check
          ? 'kez'
          : _unitController.text.trim(),
      rewardEligible: _rewardEligible,
    );

    try {
      await widget.onSave(habit, plan);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekdayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    widget.initialHabit == null
                        ? 'Yeni Alışkanlık Ekle'
                        : 'Alışkanlığı Düzenle',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Emoji selection
              Text('Simge Seç', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _emojiCatalog.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final em = _emojiCatalog[index];
                    final isSel = _selectedEmoji == em;
                    return InkWell(
                      onTap: () => setState(() => _selectedEmoji = em),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSel
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: isSel
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(em, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Alışkanlık Başlığı',
                  hintText: 'Örn: 25 dk Kodlama veya 5 Vakit Namaz',
                ),
                validator: validateHabitTitle,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<HabitCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Bölüm'),
                      items: HabitCategory.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text('${cat.defaultEmoji} ${cat.displayName}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _subcategoryController,
                      decoration: const InputDecoration(
                        labelText: 'Alt Kategori',
                        hintText: 'Örn: Okuma, Ders',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<HabitTargetType>(
                initialValue: _targetType,
                decoration: const InputDecoration(labelText: 'Hedef Türü'),
                items: HabitTargetType.values.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t.displayName));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _targetType = val;
                      if (val == HabitTargetType.duration) {
                        _unitController.text = 'dk';
                        _targetValueController.text = '25';
                      } else if (val == HabitTargetType.count) {
                        _unitController.text = 'sayfa';
                        _targetValueController.text = '10';
                      } else {
                        _unitController.text = 'kez';
                        _targetValueController.text = '1';
                      }
                    });
                  }
                },
              ),
              if (_targetType != HabitTargetType.check) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _targetValueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hedef Değer',
                        ),
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          if (n == null || n <= 0) return 'Pozitif sayı girin';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _unitController,
                        decoration: const InputDecoration(
                          labelText: 'Birim (dk, sayfa, soru vb.)',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Text('Tekrar Günleri', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final dayIndex = i + 1;
                  final isSelected = _selectedWeekdays.contains(dayIndex);
                  return FilterChip(
                    label: Text(weekdayNames[i]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedWeekdays.add(dayIndex);
                        } else {
                          if (_selectedWeekdays.length > 1) {
                            _selectedWeekdays.remove(dayIndex);
                          }
                        }
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ödül Biletine Dahil Et 🎟️'),
                subtitle: const Text(
                  'Bu alışkanlık tamamlandığında aktif ödül biletine 1 adım kazandırır.',
                  style: TextStyle(fontSize: 12),
                ),
                value: _rewardEligible,
                onChanged: (val) => setState(() => _rewardEligible = val),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isSaving ? null : _submit,
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
                label: Text(
                  widget.initialHabit == null
                      ? 'Alışkanlığı Kaydet'
                      : 'Değişiklikleri Kaydet',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
