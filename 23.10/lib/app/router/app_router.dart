import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/habits/presentation/pages/habit_detail_page.dart';
import '../../features/habits/presentation/pages/spiritual_page.dart';
import '../../features/habits/presentation/pages/study_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/rewards/presentation/pages/rewards_page.dart';
import '../bootstrap/app_bootstrap_controller.dart';
import '../di/app_providers.dart';
import '../shell/app_shell.dart';
import 'route_paths.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(bootstrapControllerProvider, (prev, next) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = RouterRefreshListenable(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.bootstrap,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final bootstrapState = ref.read(bootstrapControllerProvider);
      final currentLoc = state.uri.path;

      if (bootstrapState is BootstrapLoading ||
          bootstrapState is BootstrapFailure) {
        return currentLoc == RoutePaths.bootstrap ? null : RoutePaths.bootstrap;
      }

      if (bootstrapState is BootstrapNeedsOnboarding) {
        return currentLoc == RoutePaths.onboarding
            ? null
            : RoutePaths.onboarding;
      }

      if (bootstrapState is BootstrapReady) {
        if (currentLoc == RoutePaths.bootstrap ||
            currentLoc == RoutePaths.onboarding) {
          final prefs = ref.read(preferencesStoreProvider);
          return prefs.defaultSection == 'spiritual'
              ? RoutePaths.spiritual
              : RoutePaths.study;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.bootstrap,
        builder: (context, state) => const _BootstrapScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.spiritual,
                builder: (context, state) => const SpiritualPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.study,
                builder: (context, state) => const StudyPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.rewards,
                builder: (context, state) => const RewardsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RoutePaths.habitDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return HabitDetailPage(habitId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RoutePaths.progress,
        builder: (context, state) => const ProgressPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'Sayfa Bulunamadı',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Aradığınız sayfa mevcut değil: ${state.uri.path}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(RoutePaths.study),
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    ),
  );
});

class _BootstrapScreen extends ConsumerWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bootstrapControllerProvider);
    final theme = Theme.of(context);

    if (state is BootstrapFailure) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Veriler Açılırken Sorun Oluştu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(state.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(bootstrapControllerProvider.notifier).init(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🎟️', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 24),
            Text(
              'Kendime Söz',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Alışkanlık ve Yaşam Takip',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
