import 'package:flutter/foundation.dart';

/// Session-only set of favorite vehicle ids.
class FavoritesController extends ChangeNotifier {
  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFavorite(String vehicleId) => _ids.contains(vehicleId);

  void toggle(String vehicleId) {
    if (!_ids.remove(vehicleId)) _ids.add(vehicleId);
    notifyListeners();
  }
}
