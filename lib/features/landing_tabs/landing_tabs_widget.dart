import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' show ImageFilter;
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_page.dart';
import 'package:ghars_school/shared/main_app_bar/main_app_bar.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';

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
          title: '${context.translate(AppStrings.discount)}',
          onBackBtnClicked: () {
            selectTap(0);
          },
        );
        currentWidget = Container();
        break;
      case 2:
        currentAppBarWidget = MainAppBar(
          title: '${context.translate(AppStrings.settings)}',
          onBackBtnClicked: () {
            selectTap(0);
          },
        );
        currentWidget = Container();
        break;
      case 3:
        currentAppBarWidget = MainAppBar(
          hasCartBtn: true,
          title: '${context.translate(AppStrings.contactUs)}',
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
              bottomNavigationBar: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: BottomNavigationBar(
                        onTap: (index) {
                          selectTap(index);
                        },
                        currentIndex: currentIndex,
                        selectedItemColor: AppStyle.appColor,
                        unselectedItemColor: Colors.grey[400],
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        selectedLabelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.appColor,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[400],
                        ),
                        items: List.generate(4, (index) {
                          final isSelected = currentIndex == index;
                          String tooltip = '';
                          String icon = '';
                          switch (index) {
                            case 0:
                              icon = AppAssets.home;
                              tooltip = '${context.translate(AppStrings.home)}';
                              break;

                            case 2:
                              icon = AppAssets.settings;
                              tooltip =
                                  '${context.translate(AppStrings.settings)}';
                              break;
                            case 1:
                              icon = AppAssets.packages;
                              tooltip =
                                  '${context.translate(AppStrings.packages)}';
                              break;
                            case 3:
                              icon = AppAssets.restaurants;
                              tooltip =
                                  '${context.translate(AppStrings.restaurants)}';
                              break;

                            default:
                          }

                          return BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              icon,
                              height: isSelected ? 18.sp : 14.sp,
                              colorFilter: ColorFilter.mode(
                                isSelected ? AppStyle.appColor : Colors.grey[400]!,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: tooltip,
                            tooltip: tooltip,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
