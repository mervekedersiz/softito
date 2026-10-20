import 'package:flutter/foundation.dart';
import '../../../../core/data/demo_store.dart';
import '../../../../core/models/eligibility_answer.dart';
import '../models/eligibility_state.dart';

class EligibilityController extends ValueNotifier<EligibilityState> {
  final DemoStore _store;

  EligibilityController(this._store)
    : super(
        EligibilityState(
          questions: _createDefaultQuestions(),
          answers: _loadInitialAnswers(_store),
        ),
      );

  static List<EligibilityQuestion> _createDefaultQuestions() {
    return const [
      EligibilityQuestion(
        id: 'q_age_weight',
        category: 'Genel Kriterler',
        questionText:
            '18–65 yaş aralığında ve en az 50 kg ağırlığında mısınız?',
        explanation:
            'Kan hacmi güvenliği ve donör sağlığı için temel fiziksel gerekliliktir.',
      ),
      EligibilityQuestion(
        id: 'q_recent_donation',
        category: 'Bağış Aralığı',
        questionText:
            'Son dönemde (erkeklerde son 90 gün, kadınlarda son 120 gün içinde) kan bağışında bulundunuz mu?',
        explanation:
            'Vücudun demir depolarının ve eritrositlerin yenilenmesi için standart aralıklara dikkat edilir.',
      ),
      EligibilityQuestion(
        id: 'q_active_infection',
        category: 'Güncel Sağlık',
        questionText:
            'Şu anda ateş, boğaz ağrısı, aktif enfeksiyon veya grip belirtiniz var mı?',
        explanation:
            'Akut enfeksiyon sırasında kan bağışı donör ve alıcı güvenliği için ertelenebilir.',
      ),
      EligibilityQuestion(
        id: 'q_medication',
        category: 'İlaç Kullanımı',
        questionText:
            'Düzenli kullandığınız reçeteli ilaçlar (antibiyotik, kan sulandırıcı vb.) var mı?',
        explanation:
            'Bazı ilaçların kanda bulunması geçici erteleme gerektirebilir; merkez doktoruna bildirilmelidir.',
      ),
      EligibilityQuestion(
        id: 'q_medical_procedure',
        category: 'Tıbbi İşlemler',
        questionText:
            'Son 1 yıl içinde cerrahi operasyon, endoskopi veya kan transfüzyonu geçirdiniz mi?',
        explanation:
            'Girişimsel işlemler sonrası belirli izlem süreleri uygulanır.',
      ),
      EligibilityQuestion(
        id: 'q_tatoo_piercing',
        category: 'Cilt Delme İşlemleri',
        questionText:
            'Son 1 yıl içinde dövme, piercing, hacamat veya akupunktur yaptırdınız mı?',
        explanation:
            'Enfeksiyon riskine karşı koruyucu bekleme süresi merkez doktoru tarafından incelenir.',
      ),
      EligibilityQuestion(
        id: 'q_pregnancy',
        category: 'Gebelik & Emzirme',
        questionText:
            'Gebelik, son 9 ay içinde doğum veya aktif emzirme süreciniz var mı?',
        explanation:
            'Anne ve bebek sağlığının korunması için geçici bağış aralığı verilebilir.',
      ),
      EligibilityQuestion(
        id: 'q_travel',
        category: 'Seyahat',
        questionText:
            'Son 6 ay içinde sıtma riski taşıyan tropikal bir ülkeye seyahat ettiniz mi?',
        explanation:
            'Endemik enfeksiyon bölgelerine yapılan seyahatler sonrası standart tarama kuralları bulunur.',
      ),
    ];
  }

  static Map<String, AnswerType> _loadInitialAnswers(DemoStore store) {
    final map = <String, AnswerType>{};
    for (final entry in store.eligibilityAnswers.entries) {
      map[entry.key] = entry.value.answer;
    }
    return map;
  }

  void setAnswer(String questionId, AnswerType answer) {
    final updated = Map<String, AnswerType>.from(value.answers);
    updated[questionId] = answer;
    value = value.copyWith(
      answers: updated,
      isSubmitted: false, // Reset submit state if answers change
    );
  }

  void submitAnswers() {
    final storeAnswers = <String, EligibilityAnswer>{};
    for (final entry in value.answers.entries) {
      storeAnswers[entry.key] = EligibilityAnswer(
        questionId: entry.key,
        answer: entry.value,
      );
    }
    _store.saveEligibilityAnswers(storeAnswers);
    value = value.copyWith(isSubmitted: true);
  }

  void reset() {
    value = value.copyWith(answers: {}, isSubmitted: false);
  }
}
