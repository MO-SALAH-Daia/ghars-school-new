import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' show ImageFilter;
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_page.dart';
import 'package:ghars_school/shared/main_app_bar/main_app_bar.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';
import 'package:ghars_school/shared/floating_bottom_nav_bar/floating_bottom_nav_bar.dart';

import 'landing_tabs_manager.dart';

class LandingTabsWidget extends StatefulWidget {
  const LandingTabsWidget({super.key});

  /// To Call any method from outside
  static _LandingTabsWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LandingTabsWidgetState>();

  @override
  _LandingTabsWidgetState createState() => _LandingTabsWidgetState();
}

class _LandingTabsWidgetState extends State<LandingTabsWidget> {
  int currentIndex = 0;
  Widget currentWidget = HomePage();
  Widget currentAppBarWidget = const MainAppBar(
    hasDrawerBtn: true,
    hasNotificationBtn: true,
    hasCartBtn: true,
  );

  void selectTap(int tabIndex, {bool fromSeeAll = false}) {
    currentIndex = tabIndex;
    switch (tabIndex) {
      case 0:
        currentAppBarWidget = const MainAppBar(
          hasDrawerBtn: true,
          hasNotificationBtn: true,
          hasCartBtn: true,
        );
        currentWidget = const HomePage();
        break;
      case 1:
        currentAppBarWidget = MainAppBar(
          hasCartBtn: true,
          title: '${context.translate(AppStrings.services)}',
          onBackBtnClicked: () {
            selectTap(0);
          },
        );
        currentWidget = Container();
        break;
      case 2:
        currentAppBarWidget = MainAppBar(
          title: '${context.translate(AppStrings.calendar)}',
          onBackBtnClicked: () {
            selectTap(0);
          },
        );
        currentWidget = Container();
        break;
      case 3:
        currentAppBarWidget = MainAppBar(
          hasCartBtn: true,
          title: '${context.translate(AppStrings.studentProfile)}',
          onBackBtnClicked: () {
            selectTap(0);
          },
        );
        currentWidget = Container();
        break;
      default:
        currentAppBarWidget = const MainAppBar();
        currentWidget = HomePage();
        break;
    }

    locator<LandingTabsManager>().tabIndex = tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final landingTabsManager = context.use<LandingTabsManager>();
    return GestureDetector(
      onTap: () {
        ZoomDrawer.of(context)?.close();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (currentIndex == 0) {
            return true;
          } else {
            selectTap(0);
            return false;
          }
        },
        child: ValueListenableBuilder<int>(
          valueListenable: landingTabsManager.tabIndexNotifier,
          builder: (context, tabIndex, _) {
            if (tabIndex == 1 && landingTabsManager.fromSeeAll) {
              selectTap(1, fromSeeAll: true);
            }
            if (tabIndex == 3 && landingTabsManager.fromSeeAll) {
              selectTap(3, fromSeeAll: true);
            }
            if (tabIndex == 4 && landingTabsManager.fromSeeAll) {
              selectTap(4, fromSeeAll: true);
            }
            return Scaffold(
              // key: tabsScaffoldKey,
              // drawer: const AppDrawer(),
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              extendBody: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.h),
                // child: SafeArea(
                child: currentAppBarWidget,
                // ),
              ),
              body: Container(color: Colors.white, child: currentWidget),
              bottomNavigationBar: FloatingBottomNavBar(
                currentIndex: currentIndex,
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
            );
          },
        ),
      ),
    );
  }
}
