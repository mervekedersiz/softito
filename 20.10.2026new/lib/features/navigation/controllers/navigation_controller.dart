import 'package:flutter/foundation.dart';

class NavigationController extends ValueNotifier<int> {
  NavigationController([super.value = 0]);

  void setIndex(int index) {
    if (index >= 0 && index <= 4 && value != index) {
      value = index;
    }
  }

  void goToHome() => setIndex(0);
  void goToRequests() => setIndex(1);
  void goToCenters() => setIndex(2);
  void goToHistory() => setIndex(3);
  void goToProfile() => setIndex(4);
}
