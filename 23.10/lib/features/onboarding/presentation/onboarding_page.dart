import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/di/app_providers.dart';
import '../../../../core/time/local_date.dart';
import '../../habits/domain/entities/habit.dart';
import '../../habits/domain/entities/habit_plan.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Set<int> _selectedTemplateIndices = {0, 1};

  final List<Map<String, dynamic>> _starterTemplates = [
    {
      'title': '25 dk Odaklanarak Ders / Kod',
      'emoji': '💻',
      'category': HabitCategory.study,
      'subcategory': 'Ders',
      'targetType': HabitTargetType.duration,
      'targetValue': 25,
      'unit': 'dk',
      'rewardEligible': true,
    },
    {
      'title': 'Günde 10 Sayfa Kitap Oku',
      'emoji': '📖',
      'category': HabitCategory.study,
      'subcategory': 'Okuma',
      'targetType': HabitTargetType.count,
      'targetValue': 10,
      'unit': 'sayfa',
      'rewardEligible': true,
    },
    {
      'title': 'Günün Şükrü ve Tefekkürü',
      'emoji': '🤲',
      'category': HabitCategory.spiritual,
      'subcategory': 'Maneviyat',
      'targetType': HabitTargetType.check,
      'targetValue': 1,
      'unit': 'kez',
      'rewardEligible': false,
    },
    {
      'title': 'Birine İyilik Yap veya Tebessüm Et',
      'emoji': '🤝',
      'category': HabitCategory.spiritual,
      'subcategory': 'İyilik',
      'targetType': HabitTargetType.check,
      'targetValue': 1,
      'unit': 'kez',
      'rewardEligible': false,
    },
  ];

  Future<void> _finishOnboarding({bool includeTemplates = true}) async {
    if (includeTemplates && _selectedTemplateIndices.isNotEmpty) {
      final repo = ref.read(habitRepositoryProvider);
      final now = DateTime.now().toUtc();
      final today = LocalDate.fromDateTime(DateTime.now());

      for (final idx in _selectedTemplateIndices) {
        final t = _starterTemplates[idx];
        final habitId = 'init_hab_${idx}_${now.millisecondsSinceEpoch}';
        final planId = 'init_plan_${idx}_${now.millisecondsSinceEpoch}';

        final habit = Habit(
          id: habitId,
          title: t['title'] as String,
          emoji: t['emoji'] as String,
          category: t['category'] as HabitCategory,
          subcategory: t['subcategory'] as String,
          createdAtUtc: now,
        );

        final plan = HabitPlan(
          id: planId,
          habitId: habitId,
          effectiveFromDate: today,
          weekdays: const [1, 2, 3, 4, 5, 6, 7],
          targetType: t['targetType'] as HabitTargetType,
          targetValue: t['targetValue'] as int,
          unit: t['unit'] as String,
          rewardEligible: t['rewardEligible'] as bool,
        );

        await repo.createHabit(habit: habit, plan: plan);
      }
    }

    final bootstrap = ref.read(bootstrapControllerProvider.notifier);
    await bootstrap.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kendime Söz 🎟️',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _finishOnboarding(includeTemplates: false),
                    child: const Text('Atla'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  // Slide 1: Welcome & Philosophy
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '🌱',
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Kendin İçin Bir Söz Ver',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Maneviyat ve iyilikle iç dünyana iyi gel, ders ve gelişimle geleceğine yatırım yap. Küçük alışkanlıklarla zinciri kırmadan devam et.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Slide 2: Reward Ticket System
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2B6A0)
                                .withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '🎟️',
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Kişisel Ödül Biletleri',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tamamladığın her planlı adım aktif ödül biletini doldurur. Hedefe ulaştığında kendine bir müze gezisi, sahil yürüyüşü veya kahve molası hediye et!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Slide 3: Starter Habit Templates
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Başlangıç İçin Seç',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'İstediğin alışkanlıkları seçerek hemen başlayabilirsin:',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _starterTemplates.length,
                            itemBuilder: (context, idx) {
                              final t = _starterTemplates[idx];
                              final isSelected = _selectedTemplateIndices
                                  .contains(idx);
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (sel) {
                                    setState(() {
                                      if (sel == true) {
                                        _selectedTemplateIndices.add(idx);
                                      } else {
                                        _selectedTemplateIndices.remove(idx);
                                      }
                                    });
                                  },
                                  title: Text('${t['emoji']} ${t['title']}'),
                                  subtitle: Text(
                                    '${t['subcategory']} • ${t['targetValue']} ${t['unit']}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(3, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding(includeTemplates: true);
                      }
                    },
                    child: Text(_currentPage < 2 ? 'İleri' : 'Hemen Başla'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
