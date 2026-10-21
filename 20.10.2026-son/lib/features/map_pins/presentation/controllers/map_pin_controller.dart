import 'package:flutter/foundation.dart';
import '../../domain/entities/map_pin.dart';

class MapPinController extends ChangeNotifier {
  MapPinController() {
    _initDefaultPins();
  }

  final List<MapPin> _pins = [];
  MapPin? _selectedPin;
  MapPinType? _typeFilter;

  List<MapPin> get pins => _typeFilter == null
      ? List.unmodifiable(_pins)
      : _pins.where((p) => p.type == _typeFilter).toList();

  MapPin? get selectedPin => _selectedPin;
  MapPinType? get typeFilter => _typeFilter;

  void _initDefaultPins() {
    _pins.addAll([
      const MapPin(
        id: 'pin-1',
        title: 'Tesla Model 3 Long Range',
        subtitle: 'Kadıköy Rıhtım • %90 Batarya',
        type: MapPinType.vehicle,
        normalizedX: 0.65,
        normalizedY: 0.55,
        batteryOrFuel: 90,
      ),
      const MapPin(
        id: 'pin-2',
        title: 'YolOrtağım Supercharger (300kW)',
        subtitle: 'Ataşehir Finans Merkezi • 4 Boş Soket',
        type: MapPinType.supercharger,
        normalizedX: 0.80,
        normalizedY: 0.40,
        batteryOrFuel: 100,
      ),
      const MapPin(
        id: 'pin-3',
        title: 'Segway Pro E-Scooter Hub',
        subtitle: 'Beşiktaş Meydan • 8 Müsait Scooter',
        type: MapPinType.scooterHub,
        normalizedX: 0.35,
        normalizedY: 0.35,
        batteryOrFuel: 78,
      ),
      const MapPin(
        id: 'pin-4',
        title: 'Merkezi Teslim & İade Noktası',
        subtitle: 'Levent Metro Çıkışı • 7/24 Açık',
        type: MapPinType.dropoffZone,
        normalizedX: 0.40,
        normalizedY: 0.22,
        batteryOrFuel: 100,
      ),
    ]);
  }

  void selectPin(MapPin? pin) {
    _selectedPin = pin;
    notifyListeners();
  }

  void setFilter(MapPinType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void addPin({
    required String title,
    required String subtitle,
    required MapPinType type,
    required double normalizedX,
    required double normalizedY,
  }) {
    final newPin = MapPin(
      id: 'pin-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      type: type,
      normalizedX: normalizedX.clamp(0.05, 0.95),
      normalizedY: normalizedY.clamp(0.05, 0.95),
    );
    _pins.add(newPin);
    _selectedPin = newPin;
    notifyListeners();
  }
}
