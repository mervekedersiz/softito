import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/chef_ai/presentation/screens/chef_ai_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/donations/presentation/screens/create_donation_screen.dart';
import '../../features/donations/presentation/screens/donation_draft_detail_screen.dart';
import '../../features/donations/presentation/screens/donation_history_screen.dart';
import '../../features/donations/presentation/screens/donations_screen.dart';
import '../../features/donations/presentation/screens/donation_location_screen.dart';
import '../../features/donations/domain/entities/donation_location.dart';
import '../../features/donations/presentation/screens/eligible_foods_screen.dart';
import '../../features/inventory/presentation/screens/food_detail_screen.dart';
import '../../features/inventory/presentation/screens/food_form_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/onboarding/data/onboarding_preferences.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../../features/recipes/presentation/screens/recipes_screen.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../theme/app_colors.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingAsync = ref.watch(onboardingPreferencesProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (state.matchedLocation == '/splash') {
        return null;
      }
      if (onboardingAsync.isLoading) return null;

      final isCompleted = onboardingAsync.value ?? false;
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!isCompleted && !isOnboarding) {
        return '/onboarding';
      }

      if (isCompleted && isOnboarding) {
        return '/dashboard';
      }

      if (state.matchedLocation == '/') {
        return '/splash';
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.danger,
              ),
              const SizedBox(height: 16),
              const Text(
                '404 - Sayfa Bulunamadı',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Aradığınız sayfa mevcut değil: ${state.uri}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Ana Sayfaya Dön'),
              ),
            ],
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: RouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                name: RouteNames.inventory,
                builder: (context, state) => const InventoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recipes',
                name: RouteNames.recipes,
                builder: (context, state) => const RecipesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                name: RouteNames.statistics,
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Food product routes
      GoRoute(
        path: '/products/new',
        name: RouteNames.productNew,
        builder: (context, state) => const FoodFormScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        name: RouteNames.productDetail,
        builder: (context, state) =>
            FoodDetailScreen(foodId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/products/:id/edit',
        name: RouteNames.productEdit,
        builder: (context, state) =>
            FoodFormScreen(foodId: state.pathParameters['id']),
      ),
      // Recipe routes
      GoRoute(
        path: '/recipes/:id',
        name: RouteNames.recipeDetail,
        builder: (context, state) =>
            RecipeDetailScreen(recipeId: state.pathParameters['id']!),
      ),
      // Chef AI route
      GoRoute(
        path: '/chef-ai',
        name: RouteNames.chefAi,
        builder: (context, state) => const ChefAiScreen(),
      ),
      // Donation routes
      GoRoute(
        path: '/donations',
        name: RouteNames.donations,
        builder: (context, state) => const DonationsScreen(),
      ),
      GoRoute(
        path: '/donations/eligible',
        name: RouteNames.eligibleDonations,
        builder: (context, state) => const EligibleFoodsScreen(),
      ),
      GoRoute(
        path: '/donations/drafts/new',
        name: RouteNames.newDonationDraft,
        builder: (context, state) => const CreateDonationScreen(),
      ),
      GoRoute(
        path: '/donations/drafts/:draftId',
        name: RouteNames.donationDraftDetail,
        builder: (context, state) => DonationDraftDetailScreen(
          draftId: state.pathParameters['draftId']!,
        ),
      ),
      GoRoute(
        path: '/donations/locations/:kind',
        name: RouteNames.donationLocation,
        builder: (context, state) {
          final kind = switch (state.pathParameters['kind']) {
            'destination' => DonationLocationKind.destination,
            'pickup' => DonationLocationKind.pickup,
            _ => null,
          };
          if (kind == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Konum bulunamadı')),
              body: Center(
                child: TextButton(
                  onPressed: () => context.go('/donations'),
                  child: const Text('Bağış ekranına dön'),
                ),
              ),
            );
          }
          return DonationLocationScreen(kind: kind);
        },
      ),
      GoRoute(
        path: '/donations/history',
        name: RouteNames.donationHistory,
        builder: (context, state) => const DonationHistoryScreen(),
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryMint,
        elevation: 2,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Özet',
          ),
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen, color: AppColors.primary),
            label: 'Envanter',
          ),
          NavigationDestination(
            icon: Icon(Icons.soup_kitchen_outlined),
            selectedIcon: Icon(Icons.soup_kitchen, color: AppColors.primary),
            label: 'Bugün Pişir',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart, color: AppColors.primary),
            label: 'İstatistik',
          ),
        ],
      ),
    );
  }
}
