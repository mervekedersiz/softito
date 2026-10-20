import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/eligibility_answer.dart';
import '../models/eligibility_state.dart';

class EligibilityQuestionCard extends StatelessWidget {
  final EligibilityQuestion question;
  final AnswerType currentAnswer;
  final ValueChanged<AnswerType> onAnswerSelected;

  const EligibilityQuestionCard({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    question.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                if (currentAnswer != AnswerType.unanswered)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: currentAnswer == AnswerType.yes
                        ? AppColors.warning
                        : (currentAnswer == AnswerType.unsure
                              ? AppColors.info
                              : AppColors.success),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              question.questionText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              question.explanation,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Segmented options: Evet, Hayır, Emin Değilim
            SegmentedButton<AnswerType>(
              segments: const [
                ButtonSegment(
                  value: AnswerType.yes,
                  label: Text('Evet', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: AnswerType.no,
                  label: Text('Hayır', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: AnswerType.unsure,
                  label: Text('Emin Değilim', style: TextStyle(fontSize: 12)),
                ),
              ],
              selected: currentAnswer == AnswerType.unanswered
                  ? {}
                  : {currentAnswer},
              emptySelectionAllowed: true,
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  onAnswerSelected(selection.first);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
