import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/eligibility_answer.dart';
import '../../../../core/widgets/demo_label.dart';
import '../controllers/eligibility_controller.dart';
import '../models/eligibility_state.dart';
import '../widgets/eligibility_question_card.dart';
import '../widgets/eligibility_summary.dart';

class EligibilityView extends StatefulWidget {
  final DemoStore store;

  const EligibilityView({super.key, required this.store});

  @override
  State<EligibilityView> createState() => _EligibilityViewState();
}

class _EligibilityViewState extends State<EligibilityView> {
  late final EligibilityController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EligibilityController(widget.store);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.eligibilityTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Sıfırla',
            onPressed: () => _controller.reset(),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: DemoLabel(text: 'Bilgilendirme'),
          ),
        ],
      ),
      body: ValueListenableBuilder<EligibilityState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header description card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.softRed.withAlpha(80),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.bloodRed.withAlpha(50),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.bloodRed,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bu form kan bağışından önce kendinizi değerlendirmeniz içindir. Kesin uygunluk kararı bağış merkezindeki sağlık görevlileri tarafından verilir.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // If submitted: show summary
              if (state.isSubmitted) ...[
                EligibilitySummary(
                  state: state,
                  onDismiss: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
              ],

              // Progress status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ön Bilgi Soruları (${state.questions.length} Soru)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '${state.answeredCount} / ${state.questions.length} Yanıtlandı',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bloodRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Questions
              ...state.questions.map((q) {
                final currentAns = state.answers[q.id] ?? AnswerType.unanswered;
                return EligibilityQuestionCard(
                  question: q,
                  currentAnswer: currentAns,
                  onAnswerSelected: (ans) => _controller.setAnswer(q.id, ans),
                );
              }),
              const SizedBox(height: 20),

              // Save button
              ElevatedButton.icon(
                onPressed: () {
                  _controller.submitAnswers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.responsesSaved),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text(AppStrings.saveResponses),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
