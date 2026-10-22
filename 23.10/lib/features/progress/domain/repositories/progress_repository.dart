import '../../../../core/result/result.dart';
import '../../../../core/time/local_date.dart';
import '../entities/badge.dart';

abstract class ProgressRepository {
  Stream<List<AppBadge>> watchBadges();
  Future<Result<List<AppBadge>>> getBadges();
  Future<Result<void>> awardBadge({
    required String code,
    required DateTime earnedAtUtc,
    String? evidenceId,
  });
  Stream<String?> watchReflection(LocalDate date);
  Future<Result<String?>> getReflection(LocalDate date);
  Future<Result<void>> saveReflection({
    required LocalDate date,
    required String text,
    required DateTime updatedAtUtc,
  });
}
