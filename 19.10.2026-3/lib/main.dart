import 'package:flutter/material.dart';
import 'core/extensions/theme_extensions.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/sport_habit_tracker/controllers/habit_controller.dart';
import 'features/sport_habit_tracker/views/habit_view.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/views/water_tracker_view.dart';
import 'features/workout/controllers/workout_controller.dart';
import 'features/workout/views/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

class SusadimApp extends StatefulWidget {
  const SusadimApp({super.key});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.state,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MainNavigationShell(themeController: _themeController),
        );
      },
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final ThemeController themeController;

  const MainNavigationShell({
    super.key,
    required this.themeController,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  late final HabitController _habitController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
    _habitController = HabitController();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _waterController.dispose();
    _workoutController.dispose();
    _habitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildSelectedTab(index),
          bottomNavigationBar: _buildBottomNav(index),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          _buildLogo(),
          const SizedBox(width: 12),
          _buildTitleColumn(),
        ],
      ),
      actions: [
        _buildThemeToggle(),
        _buildEnergyAction(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.accentWater, width: 1.5),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Susadım v1',
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Akıllı Su & Egzersiz Takibi',
          style: TextStyle(
            color: context.accentWater,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle() {
    final isDark = widget.themeController.isDarkMode;
    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: isDark ? Colors.amberAccent : context.accentWater,
      ),
      tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
      onPressed: widget.themeController.toggleTheme,
    );
  }

  Widget _buildEnergyAction() {
    return IconButton(
      icon: Icon(Icons.bolt_rounded, color: context.accentHabit),
      tooltip: 'Enerji & Durum',
      onPressed: () {},
    );
  }

  Widget _buildSelectedTab(int index) {
    switch (index) {
      case 0:
        return WaterTrackerView(controller: _waterController);
      case 1:
        return WorkoutView(controller: _workoutController);
      case 2:
        return HabitView(controller: _habitController);
      default:
        return WaterTrackerView(controller: _waterController);
    }
  }

  Widget _buildBottomNav(int index) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (newIndex) => _currentIndex.value = newIndex,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop_rounded, color: context.accentWater),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: const Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center_rounded, color: context.accentGym),
          label: 'Egzersiz',
        ),
        NavigationDestination(
          icon: const Icon(Icons.checklist_rounded),
          selectedIcon: Icon(Icons.task_alt_rounded, color: context.accentHabit),
          label: 'Alışkanlıklar',
        ),
      ],
    );
  }
}
