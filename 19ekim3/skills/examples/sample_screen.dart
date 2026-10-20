import 'package:flutter/material.dart';

// ==============================================================================
// 1. MODEL KATMANI (models/activity_model.dart)
// ==============================================================================

/// İmmutable (değişmez) Aktivite Veri Modeli
class ActivityModel {
  final String title;
  final int completedMinutes;
  final int targetMinutes;
  final int streakDays;
  final DateTime lastUpdated;

  const ActivityModel({
    required this.title,
    required this.completedMinutes,
    required this.targetMinutes,
    required this.streakDays,
    required this.lastUpdated,
  });

  /// İlerleme oranı (%0.0 - %1.0)
  double get progressRatio => targetMinutes > 0
      ? (completedMinutes / targetMinutes).clamp(0.0, 1.0)
      : 0.0;

  /// Kalan süre (dakika)
  int get remainingMinutes =>
      (targetMinutes - completedMinutes).clamp(0, targetMinutes);

  /// Hedef tamamlandı mı?
  bool get isGoalReached => completedMinutes >= targetMinutes;

  /// İmmutable güncelleme için copyWith deseni
  ActivityModel copyWith({
    String? title,
    int? completedMinutes,
    int? targetMinutes,
    int? streakDays,
    DateTime? lastUpdated,
  }) {
    return ActivityModel(
      title: title ?? this.title,
      completedMinutes: completedMinutes ?? this.completedMinutes,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      streakDays: streakDays ?? this.streakDays,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// JSON dönüşümü
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completedMinutes': completedMinutes,
      'targetMinutes': targetMinutes,
      'streakDays': streakDays,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// JSON'dan model üretimi
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      title: json['title'] as String? ?? 'Günlük Egzersiz',
      completedMinutes: (json['completedMinutes'] as num?)?.toInt() ?? 0,
      targetMinutes: (json['targetMinutes'] as num?)?.toInt() ?? 60,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 1,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

// ==============================================================================
// 2. CONTROLLER KATMANI (controllers/activity_controller.dart)
// ==============================================================================

/// Reaktif ValueNotifier Tabanlı Durum Yöneticisi
class ActivityController {
  final ValueNotifier<ActivityModel> state = ValueNotifier<ActivityModel>(
    ActivityModel(
      title: 'Fitness & Kardiyo',
      completedMinutes: 25,
      targetMinutes: 60,
      streakDays: 4,
      lastUpdated: DateTime.now(),
    ),
  );

  ActivityModel get current => state.value;

  /// Dakika ekleme aksiyonu
  void addMinutes(int minutes) {
    if (minutes <= 0) return;
    final newMinutes = current.completedMinutes + minutes;
    state.value = current.copyWith(
      completedMinutes: newMinutes,
      lastUpdated: DateTime.now(),
    );
  }

  /// Aktiviteyi sıfırlama aksiyonu
  void resetActivity() {
    state.value = current.copyWith(
      completedMinutes: 0,
      lastUpdated: DateTime.now(),
    );
  }

  /// Seri artırma aksiyonu
  void incrementStreak() {
    state.value = current.copyWith(
      streakDays: current.streakDays + 1,
      lastUpdated: DateTime.now(),
    );
  }

  /// Bellek sızıntılarını önlemek için dispose metodu
  void dispose() {
    state.dispose();
  }
}

// ==============================================================================
// 3. WIDGET KATMANI (widgets/activity_summary_card.dart)
// ==============================================================================

/// Aktivite Özet Kartı - 40 satır altı parçalanmış alt metotlar
class ActivitySummaryCard extends StatelessWidget {
  final ActivityModel model;

  const ActivitySummaryCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildProgressRow(context),
            const SizedBox(height: 14),
            _buildProgressBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.fitness_center_rounded, color: Colors.cyan, size: 22),
            const SizedBox(width: 8),
            Text(
              model.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.withAlpha(38),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department_rounded,
                  color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text(
                '${model.streakDays} Gün Seri',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (model.progressRatio * 100).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${model.completedMinutes} dk / ${model.targetMinutes} dk',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              model.isGoalReached
                  ? '🎉 Günlük hedef başarıyla tamamlandı!'
                  : 'Hedefe kalan: ${model.remainingMinutes} dakika',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: model.isGoalReached ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        Text(
          '%$percent',
          style: const TextStyle(
            color: Colors.cyan,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: model.progressRatio,
        minHeight: 10,
        backgroundColor: Colors.grey.withAlpha(50),
        valueColor: AlwaysStoppedAnimation<Color>(
          model.isGoalReached ? Colors.green : Colors.cyan,
        ),
      ),
    );
  }
}

// ==============================================================================
// 4. WIDGET KATMANI (widgets/activity_quick_action_card.dart)
// ==============================================================================

/// Hızlı Aksiyon Kartı
class ActivityQuickActionCard extends StatelessWidget {
  final ValueChanged<int> onAddMinutes;
  final VoidCallback onReset;
  final VoidCallback onIncrementStreak;

  const ActivityQuickActionCard({
    super.key,
    required this.onAddMinutes,
    required this.onReset,
    required this.onIncrementStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hızlı Süre Ekle',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildActionButtons(),
            const Divider(height: 24),
            _buildSecondaryActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAddMinutes(15),
            child: const Text('+15 dk'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAddMinutes(30),
            child: const Text('+30 dk'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAddMinutes(45),
            child: const Text('+45 dk'),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onIncrementStreak,
          icon: const Icon(Icons.star_rounded, size: 18),
          label: const Text('Seriyi Kutla'),
        ),
        TextButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Sıfırla'),
        ),
      ],
    );
  }
}

// ==============================================================================
// 5. VIEW KATMANI (views/activity_screen_view.dart)
// ==============================================================================

/// Reaktif Ekran Görünümü
class ActivityTrackerScreen extends StatelessWidget {
  final ActivityController controller;

  const ActivityTrackerScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivite & Spor Takibi'),
        centerTitle: false,
      ),
      body: ValueListenableBuilder<ActivityModel>(
        valueListenable: controller.state,
        builder: (context, model, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ActivitySummaryCard(model: model),
                const SizedBox(height: 16),
                ActivityQuickActionCard(
                  onAddMinutes: controller.addMinutes,
                  onReset: controller.resetActivity,
                  onIncrementStreak: controller.incrementStreak,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
