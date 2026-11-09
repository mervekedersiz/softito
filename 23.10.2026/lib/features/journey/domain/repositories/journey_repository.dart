import 'package:kendime_soz/core/result/result.dart';
import 'package:kendime_soz/core/time/local_date.dart';
import 'package:kendime_soz/features/habits/domain/entities/daily_check_in.dart';

class CompletionOutcome {
  const CompletionOutcome({
    required this.checkIn,
    this.rewardEarned = false,
    this.rewardTitle,
    this.awardedBadges = const [],
    this.warningMessage,
  });

  final DailyCheckIn checkIn;
  final bool rewardEarned;
  final String? rewardTitle;
  final List<String> awardedBadges;
  final String? warningMessage;
}

abstract class JourneyRepository {
  Future<Result<CompletionOutcome>> recordProgress({
    required String habitId,
    required LocalDate date,
    required int addManualValue,
    required DateTime nowUtc,
    String? note,
  });

  Future<Result<CompletionOutcome>> revertProgress({
    required String habitId,
    required LocalDate date,
    required DateTime nowUtc,
  });

  Future<Result<CompletionOutcome>> finalizeFocusSession({
    required String sessionId,
    required DateTime nowUtc,
  });
}
