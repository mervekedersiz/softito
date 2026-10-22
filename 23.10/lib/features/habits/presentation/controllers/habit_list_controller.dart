import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/time/local_date.dart';
import '../../domain/entities/daily_check_in.dart';
import '../../domain/entities/habit.dart';

class HabitWithCheckIn {
  const HabitWithCheckIn({required this.habit, this.checkIn});

  final Habit habit;
  final DailyCheckIn? checkIn;

  bool get isCompleted => checkIn?.isCompleted ?? false;
  int get currentProgressValue =>
      (checkIn?.manualValue ?? 0) + ((checkIn?.sessionSeconds ?? 0) ~/ 60);
}

class SelectedDateNotifier extends Notifier<LocalDate> {
  @override
  LocalDate build() {
    final clock = ref.watch(clockProvider);
    return LocalDate.fromDateTime(clock.now());
  }

  void selectDate(LocalDate date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, LocalDate>(
  SelectedDateNotifier.new,
);

final habitsWithCheckInsProvider =
    StreamProvider.family<List<HabitWithCheckIn>, HabitCategory>((
      ref,
      category,
    ) {
      final habitRepo = ref.watch(habitRepositoryProvider);
      final selectedDate = ref.watch(selectedDateProvider);

      return habitRepo.watchHabits(category: category).asyncMap((habits) async {
        final list = <HabitWithCheckIn>[];
        for (final h in habits) {
          final checkInResult = await habitRepo.getCheckIn(h.id, selectedDate);
          list.add(
            HabitWithCheckIn(habit: h, checkIn: checkInResult.dataOrNull),
          );
        }
        return list;
      });
    });
