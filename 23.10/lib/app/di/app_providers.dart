import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/time/clock.dart';
import '../../features/focus/data/repositories/focus_repository_impl.dart';
import '../../features/focus/domain/repositories/focus_repository.dart';
import '../../features/habits/data/repositories/habit_repository_impl.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/journey/data/repositories/journey_repository_impl.dart';
import '../../features/journey/domain/repositories/journey_repository.dart';
import '../../features/progress/data/repositories/progress_repository_impl.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import '../../features/rewards/data/repositories/reward_repository_impl.dart';
import '../../features/rewards/domain/repositories/reward_repository.dart';
import '../../infrastructure/database/app_database.dart';
import '../../infrastructure/notifications/local_notification_service.dart';
import '../../infrastructure/preferences/preferences_store.dart';

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final preferencesStoreProvider = Provider<PreferencesStore>((ref) {
  throw UnimplementedError(
    'PreferencesStore must be overridden in ProviderScope',
  );
});

final notificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepositoryImpl(ref.watch(appDatabaseProvider));
});

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  return RewardRepositoryImpl(ref.watch(appDatabaseProvider));
});

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  return FocusRepositoryImpl(ref.watch(appDatabaseProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(ref.watch(appDatabaseProvider));
});

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return JourneyRepositoryImpl(ref.watch(appDatabaseProvider));
});
