import 'package:flutter/material.dart';

/// Bottom-navigation / rail destinations of the app.
enum AppDestination {
  home('Ana Sayfa', Icons.home_outlined, Icons.home),
  vehicles('Araçlar', Icons.directions_car_outlined, Icons.directions_car),
  bookings(
    'Rezervasyonlar',
    Icons.confirmation_number_outlined,
    Icons.confirmation_number,
  ),
  favorites('Favoriler', Icons.favorite_border, Icons.favorite),
  profile('Profil', Icons.person_outline, Icons.person);

  const AppDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
