import 'package:flutter/foundation.dart';

class LandingTabsManager {
  final ValueNotifier<int> _tabIndexNotifier = ValueNotifier<int>(0);

  ValueNotifier<int> get tabIndexNotifier => _tabIndexNotifier;

  int get tabIndex => _tabIndexNotifier.value;

  set tabIndex(int index) => _tabIndexNotifier.value = index;

  void resetTabIndex() {
    tabIndex = 0;
  }

  bool fromSeeAll = false;
}
