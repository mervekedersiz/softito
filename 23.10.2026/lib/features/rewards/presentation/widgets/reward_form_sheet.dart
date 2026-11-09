import 'package:flutter/material.dart';
import 'package:kendime_soz/core/validation/validators.dart';
import 'package:kendime_soz/features/habits/domain/entities/habit.dart';

class RewardFormSheet extends StatefulWidget {
  const RewardFormSheet({
    super.key,
    required this.availableHabits,
    required this.onSave,
  });

  final List<Habit> availableHabits;
  final Future<void> Function({
    required String title,
    required String emoji,
    required String description,
    required int targetSteps,
    required List<String> habitIds,
  })
  onSave;

  @override
  State<RewardFormSheet> createState() => _RewardFormSheetState();
}

class _RewardFormSheetState extends State<RewardFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _stepsController = TextEditingController(text: '8');

  String _selectedEmoji = '🎟️';
  late Set<String> _selectedHabitIds;
  bool _isSaving = false;

  final List<String> _emojiCatalog = [
    '🎟️',
    '☕',
    '🍕',
    '🎬',
    '🚴',
    '🏛️',
    '🏕️',
    '🍰',
    '🎮',
    '🏖️',
    '✈️',
    '🎁',
    '🎧',
    '🎳',
    '🎨',
    '🎪',
  ];

  @override
  void initState() {
    super.initState();
    // Default select all available habits that have rewardEligible
    _selectedHabitIds = widget.availableHabits
        .where((h) => h.currentPlan?.rewardEligible ?? false)
        .map((h) => h.id)
        .toSet();

    // If none are eligible, pre-select all study habits
    if (_selectedHabitIds.isEmpty) {
      _selectedHabitIds = widget.availableHabits.map((h) => h.id).toSet();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedHabitIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bu ödüle katkı sağlayacak en az bir alışkanlık seçmelisiniz.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final steps = int.tryParse(_stepsController.text.trim()) ?? 8;

    try {
      await widget.onSave(
        title: _titleController.text.trim(),
        emoji: _selectedEmoji,
        description: _descController.text.trim(),
        targetSteps: steps,
        habitIds: _selectedHabitIds.toList(),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  const Text('🎟️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    'Yeni Ödül Bileti Oluştur',
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
              Text('Bilet Simgesi', style: theme.textTheme.labelMedium),
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
                  labelText: 'Ödül Adı',
                  hintText: 'Örn: Müze Gezisi veya Sahilde Kahve',
                ),
                validator: validateRewardTitle,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Kişisel Açıklama / Motivasyon Notu',
                  hintText: 'Örn: Hafta içi odaklanıp pazar günü kendime güzel bir mola hediye edeceğim.',
                ),
                maxLength: 500,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Gereken Tamamlama Adımı (Varsayılan: 8)',
                  helperText: 'Her seçili alışkanlık bir günde en fazla 1 adım kazandırır.',
                ),
                validator: (v) => validateTargetSteps(int.tryParse(v ?? '')),
              ),
              const SizedBox(height: 16),
              Text(
                'Bu Ödüle Katkı Sağlayacak Alışkanlıklar',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (widget.availableHabits.isEmpty)
                Text(
                  'Henüz bir alışkanlık yok. Önce ana sayfadan alışkanlık eklemelisiniz.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                )
              else
                ...widget.availableHabits.map((h) {
                  final isChecked = _selectedHabitIds.contains(h.id);
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('${h.emoji} ${h.title}'),
                    subtitle: Text(
                      h.subcategory,
                      style: const TextStyle(fontSize: 11),
                    ),
                    value: isChecked,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedHabitIds.add(h.id);
                        } else {
                          _selectedHabitIds.remove(h.id);
                        }
                      });
                    },
                  );
                }),
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
                label: const Text('Ödül Biletini Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
