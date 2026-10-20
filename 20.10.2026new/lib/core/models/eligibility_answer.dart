enum AnswerType {
  yes('Evet'),
  no('Hayır'),
  unsure('Emin Değilim'),
  unanswered('Yanıtsız');

  final String label;
  const AnswerType(this.label);

  static AnswerType fromString(String? val) {
    if (val == null) return AnswerType.unanswered;
    return AnswerType.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => AnswerType.unanswered,
    );
  }
}

class EligibilityAnswer {
  final String questionId;
  final AnswerType answer;

  const EligibilityAnswer({required this.questionId, required this.answer});

  EligibilityAnswer copyWith({String? questionId, AnswerType? answer}) {
    return EligibilityAnswer(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'answer': answer.name,
  };

  factory EligibilityAnswer.fromJson(Map<String, dynamic> json) {
    return EligibilityAnswer(
      questionId: json['questionId'] as String,
      answer: AnswerType.fromString(json['answer'] as String?),
    );
  }
}
