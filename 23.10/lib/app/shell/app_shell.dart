import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
        destinations: const [
          NavigationDestination(
            icon: Text('🤲', style: TextStyle(fontSize: 20)),
            selectedIcon: Text('🤲', style: TextStyle(fontSize: 22)),
            label: 'Maneviyat',
          ),
          NavigationDestination(
            icon: Text('📚', style: TextStyle(fontSize: 20)),
            selectedIcon: Text('📚', style: TextStyle(fontSize: 22)),
            label: 'Ders & Gelişim',
          ),
          NavigationDestination(
            icon: Text('🎟️', style: TextStyle(fontSize: 20)),
            selectedIcon: Text('🎟️', style: TextStyle(fontSize: 22)),
            label: 'Kendime Zaman',
          ),
        ],
      ),
    );
  }
}
