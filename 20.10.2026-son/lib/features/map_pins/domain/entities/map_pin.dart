import 'package:flutter/material.dart';

enum MapPinType {
  vehicle('Kiralık Araç', Icons.directions_car, Color(0xFF3B82F6)),
  supercharger('Hızlı Şarj', Icons.ev_station, Color(0xFF10B981)),
  dropoffZone('Teslim Noktası', Icons.local_parking, Color(0xFF8B5CF6)),
  scooterHub('Mikro Mobilite', Icons.electric_scooter, Color(0xFFF59E0B));

  const MapPinType(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class MapPin {
  const MapPin({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.normalizedX,
    required this.normalizedY,
    this.batteryOrFuel = 85,
    this.isAvailable = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final MapPinType type;
  final double normalizedX; // 0.0 to 1.0 relative to map width
  final double normalizedY; // 0.0 to 1.0 relative to map height
  final int batteryOrFuel;
  final bool isAvailable;
}
