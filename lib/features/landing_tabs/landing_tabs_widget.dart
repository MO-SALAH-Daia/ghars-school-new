import 'package:flutter/material.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/calendar_page.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_page.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/services_page.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/student_profile_page.dart';
import 'package:ghars_school/shared/floating_bottom_nav_bar/floating_bottom_nav_bar.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';

import 'landing_tabs_manager.dart';

class LandingTabsWidget extends StatefulWidget {
  const LandingTabsWidget({super.key});

  static _LandingTabsWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LandingTabsWidgetState>();

  @override
  _LandingTabsWidgetState createState() => _LandingTabsWidgetState();
}

class _LandingTabsWidgetState extends State<LandingTabsWidget> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void selectTap(int tabIndex, {bool fromSeeAll = false}) {
    final currentTabIndex = locator<LandingTabsManager>().tabIndex;
    if (tabIndex == currentTabIndex && !fromSeeAll) {
      // Pop to first route if we tap the active tab again
      _navigatorKeys[tabIndex].currentState?.popUntil((route) => route.isFirst);
    } else {
      locator<LandingTabsManager>().tabIndex = tabIndex;
    }
  }

  Widget _buildNavigator(int index, Widget page) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final landingTabsManager = locator<LandingTabsManager>();

    return ValueListenableBuilder<int>(
      valueListenable: landingTabsManager.tabIndexNotifier,
      builder: (context, tabIndex, _) {
        return PopScope(
          canPop: tabIndex == 0,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            // 1. If side menu drawer is open, close it
            final drawerController = locator<ZoomDrawerController>();
            if (drawerController.isOpen?.call() == true) {
              drawerController.close?.call();
              return;
            }

            // 2. On any non-home tab (Services, Calendar, Student Profile):
            // Always switch back to Home tab!
            if (tabIndex != 0) {
              selectTap(0);
            }
          },
          child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: IndexedStack(
              index: tabIndex,
              children: [
                _buildNavigator(0, const HomePage()),
                _buildNavigator(1, const ServicesPage()),
                _buildNavigator(2, const CalendarPage()),
                _buildNavigator(3, const StudentProfilePage()),
              ],
            ),
            bottomNavigationBar: FloatingBottomNavBar(
              currentIndex: tabIndex,
              backgroundColor: Colors.white,
              activeColor: AppStyle.appColor,
              inactiveColor: const Color(0xff8c9682),
              onTap: (index) {
                selectTap(index);
              },
              items: [
                FloatingNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: '${context.translate(AppStrings.home)}',
                ),
                FloatingNavItem(
                  icon: Icons.widgets_outlined,
                  activeIcon: Icons.widgets,
                  label: '${context.translate(AppStrings.services)}',
                ),
                FloatingNavItem(
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  label: '${context.translate(AppStrings.calendar)}',
                ),
                FloatingNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: '${context.translate(AppStrings.studentProfile)}',
                ),
              ],
            ),
        ),
        );
      },
    );
  }
}
