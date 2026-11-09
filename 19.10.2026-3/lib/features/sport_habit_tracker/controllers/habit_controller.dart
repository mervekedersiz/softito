import 'package:flutter/foundation.dart';
import '../models/habit_model.dart';

class HabitController {
  final ValueNotifier<HabitStateModel> state = ValueNotifier<HabitStateModel>(
    const HabitStateModel(
      habits: [
        HabitItemModel(
          id: 'h1',
          title: 'Sabah Aç Karnına 500ml Su',
          streakDays: 14,
          isDoneToday: true,
          iconKey: 'water',
        ),
        HabitItemModel(
          id: 'h2',
          title: 'Günde 8.000 Adım & Yürüyüş',
          streakDays: 9,
          isDoneToday: false,
          iconKey: 'steps',
        ),
        HabitItemModel(
          id: 'h3',
          title: 'Fitness & Ağırlık Antrenmanı',
          streakDays: 6,
          isDoneToday: true,
          iconKey: 'gym',
        ),
        HabitItemModel(
          id: 'h4',
          title: 'Akşam 10 dk Mobilite & Esneme',
          streakDays: 4,
          isDoneToday: false,
          iconKey: 'stretch',
        ),
      ],
    ),
  );

  HabitStateModel get current => state.value;

  void toggleHabit(String id) {
    final updated = current.habits.map((h) {
      if (h.id == id) {
        final newDone = !h.isDoneToday;
        final newStreak = newDone ? h.streakDays + 1 : (h.streakDays > 0 ? h.streakDays - 1 : 0);
        return h.copyWith(isDoneToday: newDone, streakDays: newStreak);
      }
      return h;
    }).toList();

    state.value = current.copyWith(habits: updated);
  }

  void dispose() {
    state.dispose();
  }
}
