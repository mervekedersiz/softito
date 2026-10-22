import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/time/local_date.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../controllers/progress_controller.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  final _reflectionController = TextEditingController();
  bool _isSavingNote = false;

  @override
  void initState() {
    super.initState();
    _loadTodayReflection();
  }

  Future<void> _loadTodayReflection() async {
    final clock = ref.read(clockProvider);
    final today = LocalDate.fromDateTime(clock.now());
    final repo = ref.read(progressRepositoryProvider);
    final res = await repo.getReflection(today);
    final text = res.dataOrNull;
    if (text != null && mounted) {
      _reflectionController.text = text;
    }
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  Future<void> _saveReflection() async {
    setState(() => _isSavingNote = true);
    final clock = ref.read(clockProvider);
    final today = LocalDate.fromDateTime(clock.now());
    final repo = ref.read(progressRepositoryProvider);

    final res = await repo.saveReflection(
      date: today,
      text: _reflectionController.text.trim(),
      updatedAtUtc: clock.nowUtc(),
    );

    setState(() => _isSavingNote = false);
    if (res.isSuccess && mounted) {
      ActionFeedback.showSuccess(context, 'Günün notu kaydedildi! ✍️');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(progressSummaryProvider);
    final badgesAsync = ref.watch(badgesListProvider);

    final clock = ref.watch(clockProvider);
    final today = LocalDate.fromDateTime(clock.now());
    final dateFormat = DateFormat('d MMMM yyyy', 'tr_TR');

    return Scaffold(
      appBar: AppBar(title: const Text('İlerlemem ve Rozetler')),
      body: summaryAsync.when(
        loading: () =>
            const LoadingState(message: 'İlerleme analiz ediliyor...'),
        error: (err, _) => ErrorState(
          message: 'İstatistikler yüklenemedi.',
          onRetry: () => ref.refresh(progressSummaryProvider),
        ),
        data: (summary) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Rate Cards
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              summary.weeklyRate.formattedDisplay,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Haftalık Oran',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${summary.weeklyRate.completed}/${summary.weeklyRate.planned} Hedef',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      color: const Color(0xFFF2B6A0).withValues(alpha: 0.25),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              summary.monthlyRate.formattedDisplay,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD67D3E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Aylık Oran',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${summary.monthlyRate.completed}/${summary.monthlyRate.planned} Hedef',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Heatmap Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Katkı Izgarası (Son 60 Gün)',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Zinciri Kırma 🔥',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Heatmap Grid
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: summary.heatmapCells.map((cell) {
                          Color cellColor;
                          if (!cell.isPlanned) {
                            cellColor = theme
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3);
                          } else if (cell.completedCount == 0) {
                            cellColor = theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.5);
                          } else if (cell.ratio < 0.5) {
                            cellColor = theme.colorScheme.primary.withValues(
                              alpha: 0.35,
                            );
                          } else if (cell.ratio < 1.0) {
                            cellColor = theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            );
                          } else {
                            cellColor = theme.colorScheme.primary;
                          }

                          return InkWell(
                            onTap: () {
                              final text = cell.isPlanned
                                  ? '${cell.date.key}: ${cell.completedCount}/${cell.plannedCount} hedef • %${(cell.ratio * 100).round()}'
                                  : '${cell.date.key}: Planlı hedef yok';
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(text),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: cellColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Az',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 10,
                            height: 10,
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 10,
                            height: 10,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.35,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 10,
                            height: 10,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 10,
                            height: 10,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Çok',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Badges Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Başarı Rozetleri 🏅',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      badgesAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (err, stack) =>
                            const Text('Rozetler yüklenemedi.'),
                        data: (badges) {
                          return Column(
                            children: badges.map((b) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: b.isEarned
                                      ? theme.colorScheme.primaryContainer
                                            .withValues(alpha: 0.3)
                                      : theme
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: b.isEarned
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.4,
                                          )
                                        : theme.colorScheme.outlineVariant
                                              .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: b.isEarned
                                            ? Colors.amber.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.grey.withValues(
                                                alpha: 0.1,
                                              ),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        b.emoji,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: b.isEarned
                                              ? null
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            b.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: b.isEarned
                                                  ? theme.colorScheme.primary
                                                  : Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            b.description,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (b.isEarned)
                                      const Icon(
                                        Icons.verified_rounded,
                                        color: Colors.amber,
                                        size: 22,
                                      )
                                    else
                                      const Icon(
                                        Icons.lock_outline_rounded,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Daily Reflection Note
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit_note_rounded),
                          const SizedBox(width: 8),
                          Text(
                            'Günün Kişisel Notu (${dateFormat.format(today.toDateTime())})',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _reflectionController,
                        maxLines: 3,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          hintText: 'Bugün nasıldı? Kendin için ne hissettin? Küçük bir hatıra bırak...',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: _isSavingNote ? null : _saveReflection,
                          icon: _isSavingNote
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_rounded, size: 18),
                          label: const Text('Notu Kaydet'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
