import '../../../../core/models/eligibility_answer.dart';

class EligibilityQuestion {
  final String id;
  final String questionText;
  final String category;
  final String explanation;

  const EligibilityQuestion({
    required this.id,
    required this.questionText,
    required this.category,
    required this.explanation,
  });
}

class EligibilityState {
  final List<EligibilityQuestion> questions;
  final Map<String, AnswerType> answers;
  final bool isSubmitted;

  const EligibilityState({
    required this.questions,
    this.answers = const {},
    this.isSubmitted = false,
  });

  int get answeredCount =>
      answers.values.where((a) => a != AnswerType.unanswered).length;

  List<EligibilityQuestion> get reviewTopics {
    return questions.where((q) {
      final ans = answers[q.id];
      return ans == AnswerType.yes || ans == AnswerType.unsure;
    }).toList();
  }

  EligibilityState copyWith({
    List<EligibilityQuestion>? questions,
    Map<String, AnswerType>? answers,
    bool? isSubmitted,
  }) {
    return EligibilityState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
