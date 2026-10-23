import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: 64,
          indicatorColor: const Color(0xFFECE5F9),
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded, size: 22),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                size: 22,
                color: Color(0xFF634F8E),
              ),
              label: 'Maneviyat',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined, size: 22),
              selectedIcon: Icon(
                Icons.menu_book_rounded,
                size: 22,
                color: Color(0xFF634F8E),
              ),
              label: 'Ders & Gelişim',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined, size: 22),
              selectedIcon: Icon(
                Icons.confirmation_number_rounded,
                size: 22,
                color: Color(0xFF634F8E),
              ),
              label: 'Kendime Zaman',
            ),
          ],
        ),
      ),
    );
  }
}
