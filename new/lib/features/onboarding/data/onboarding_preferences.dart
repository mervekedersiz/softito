import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inventory/presentation/providers/inventory_providers.dart';

final onboardingPreferencesProvider =
    AsyncNotifierProvider<OnboardingPreferencesNotifier, bool>(
  OnboardingPreferencesNotifier.new,
);

class OnboardingPreferencesNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    final storage = ref.read(storageServiceProvider);
    await storage.setOnboardingCompleted(true);
    state = const AsyncValue.data(true);
  }

  Future<void> resetOnboarding() async {
    final storage = ref.read(storageServiceProvider);
    await storage.setOnboardingCompleted(false);
    state = const AsyncValue.data(false);
  }
}
