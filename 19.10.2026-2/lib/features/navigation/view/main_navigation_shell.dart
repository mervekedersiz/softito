import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../water_tracker/controllers/water_tracker_controller.dart';
import '../../water_tracker/view/water_tracker_content.dart';
import '../../water_tracker/widgets/header_logo_bar.dart';
import '../../workout/controllers/workout_controller.dart';
import '../../workout/view/workout_view.dart';

class MainNavigationShell extends StatefulWidget {
  final WaterTrackerController waterController;
  final WorkoutController workoutController;
  final ThemeController themeController;

  const MainNavigationShell({
    super.key,
    required this.waterController,
    required this.workoutController,
    required this.themeController,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late final ValueNotifier<int> _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _currentTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: widget.themeController.themeMode,
                builder: (context, _, _) {
                  return HeaderLogoBar(
                    onReset: widget.waterController.resetWater,
                    onToggleTheme: widget.themeController.toggleTheme,
                    isDark: widget.themeController.isDark,
                  );
                },
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _currentTab,
                builder: (context, activeIndex, _) {
                  return IndexedStack(
                    index: activeIndex,
                    children: [
                      WaterTrackerContent(
                        controller: widget.waterController,
                        onNavigateToWorkout: () => _currentTab.value = 1,
                      ),
                      WorkoutView(
                        workoutController: widget.workoutController,
                        waterController: widget.waterController,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _currentTab,
        builder: (context, activeIndex, _) {
          return NavigationBar(
            selectedIndex: activeIndex,
            onDestinationSelected: (index) => _currentTab.value = index,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
            indicatorColor: AppColors.neonCyan.withValues(alpha: 0.18),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop_rounded, color: AppColors.neonCyan),
                label: 'Su Takibi',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center_rounded, color: AppColors.neonLime),
                label: 'Egzersiz',
              ),
            ],
          );
        },
      ),
    );
  }
}
