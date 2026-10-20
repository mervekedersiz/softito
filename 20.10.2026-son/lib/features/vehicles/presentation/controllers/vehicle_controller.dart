import 'package:flutter/foundation.dart';

import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_filter.dart';
import '../../domain/repositories/vehicle_repository.dart';

enum LoadStatus { loading, ready, error }

/// Loads vehicles and holds the active [VehicleFilter].
class VehicleController extends ChangeNotifier {
  VehicleController(this._repository);

  final VehicleRepository _repository;

  LoadStatus _status = LoadStatus.loading;
  List<Vehicle> _all = const [];
  VehicleFilter _filter = VehicleFilter.none;
  bool _disposed = false;

  LoadStatus get status => _status;
  List<Vehicle> get all => _all;
  VehicleFilter get filter => _filter;
  List<Vehicle> get visible => _filter.apply(_all);

  Vehicle? byId(String id) {
    for (final vehicle in _all) {
      if (vehicle.id == id) return vehicle;
    }
    return null;
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    _notify();
    try {
      _all = await _repository.getVehicles();
      _status = LoadStatus.ready;
    } catch (_) {
      _status = LoadStatus.error;
    }
    _notify();
  }

  void updateFilter(VehicleFilter filter) {
    _filter = filter;
    _notify();
  }

  void clearFilter() => updateFilter(VehicleFilter.none);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
