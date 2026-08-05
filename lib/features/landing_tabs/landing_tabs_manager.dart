import 'package:flutter/foundation.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/student_profile_manager.dart';

class LandingTabsManager {
  final ValueNotifier<int> _tabIndexNotifier = ValueNotifier<int>(0);

  ValueNotifier<int> get tabIndexNotifier => _tabIndexNotifier;

  int get tabIndex => _tabIndexNotifier.value;

  set tabIndex(int index) {
    if (index == 3) {
      if (locator.isRegistered<StudentProfileManager>()) {
        locator<StudentProfileManager>().selectTab(0);
      }
    }
    _tabIndexNotifier.value = index;
  }

  void resetTabIndex() {
    tabIndex = 0;
  }

  bool fromSeeAll = false;
}
