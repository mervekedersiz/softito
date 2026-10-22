import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/app_providers.dart';

sealed class BootstrapState {
  const BootstrapState();
}

class BootstrapLoading extends BootstrapState {
  const BootstrapLoading();
}

class BootstrapNeedsOnboarding extends BootstrapState {
  const BootstrapNeedsOnboarding();
}

class BootstrapReady extends BootstrapState {
  const BootstrapReady();
}

class BootstrapFailure extends BootstrapState {
  const BootstrapFailure(this.errorMessage);
  final String errorMessage;
}

class BootstrapController extends Notifier<BootstrapState> {
  @override
  BootstrapState build() {
    init();
    return const BootstrapLoading();
  }

  Future<void> init() async {
    state = const BootstrapLoading();
    try {
      // 1. Verify DB is accessible
      final db = ref.read(appDatabaseProvider);
      await db.customSelect('SELECT 1').get();

      // 2. Initialize notifications safely
      final notif = ref.read(notificationServiceProvider);
      await notif.initialize();

      // 3. Read preferences
      final prefs = ref.read(preferencesStoreProvider);
      if (!prefs.isOnboardingDone) {
        state = const BootstrapNeedsOnboarding();
      } else {
        state = const BootstrapReady();
      }
    } catch (e) {
      state = BootstrapFailure('Uygulama başlatılırken bir sorun oluştu: $e');
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(preferencesStoreProvider);
    await prefs.setOnboardingDone(true);
    state = const BootstrapReady();
  }
}

final bootstrapControllerProvider =
    NotifierProvider<BootstrapController, BootstrapState>(
      BootstrapController.new,
    );
