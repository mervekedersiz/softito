import '../../../../core/result/result.dart';
import '../entities/focus_session.dart';

abstract class FocusRepository {
  Stream<FocusSession?> watchActiveSession();
  Future<Result<FocusSession?>> getActiveSession();
  Future<Result<FocusSession>> startSession({
    required String habitId,
    required int plannedSeconds,
    required DateTime startedAtUtc,
  });
  Future<Result<FocusSession>> pauseSession({
    required String sessionId,
    required DateTime pausedAtUtc,
  });
  Future<Result<FocusSession>> resumeSession({
    required String sessionId,
    required DateTime resumedAtUtc,
  });
  Future<Result<void>> cancelSession(String sessionId);
  Future<Result<List<FocusSession>>> getSessionsForHabit(String habitId);
}
