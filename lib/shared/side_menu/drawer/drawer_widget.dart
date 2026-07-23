import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/features/landing_tabs/landing_tabs_manager.dart';
import 'package:ghars_school/features/onboarding/why_ghars_page.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_item.dart';

import '../../../app_core/app_core.dart';

/*
Created by: Mohammad Salah
Date: Monday 07 March 2022
Updated: 2026-07-23
*/

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  ValueNotifier<DrawerState>? _stateNotifier;
  AnimationController? _innerController;
  late final ValueNotifier<String> _langNotifier;

  @override
  void initState() {
    super.initState();
    _langNotifier = ValueNotifier<String>(locator<PrefsService>().appLanguage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = ZoomDrawer.of(context)?.stateNotifier;
    if (state != _stateNotifier) {
      _stateNotifier?.removeListener(_onStateChanged);
      _stateNotifier = state;
      _stateNotifier?.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _stateNotifier?.removeListener(_onStateChanged);
    _langNotifier.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    final state = _stateNotifier?.value;
    if (state == DrawerState.opening) {
      _innerController?.forward();
    } else if (state == DrawerState.closing) {
      _innerController?.reverse();
    }
  }

  void _changeLanguage(String currentLang) {
    final String nextLang = currentLang == 'en' ? 'ar' : 'en';
    final appLangManager = locator<AppLanguageManager>();

    // Close the drawer before language change to prevent UI glitching during transition
    ZoomDrawer.of(context)?.close();

    appLangManager.changeLanguage(Locale(nextLang));
    locator<PrefsService>().appLanguage = nextLang;
    _langNotifier.value = nextLang;
  }

  void _showComingSoon(BuildContext context, String title, bool isArabic) {
    showComingSoonDialog(context, title: title, isArabic: isArabic);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 6.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: AppStyle.bayZeroColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.twilight.withValues(alpha: 0.6),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.use<PrefsService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff8faf6),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff8faf6), Color(0xffedf4e8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ValueListenableBuilder<String>(
              valueListenable: _langNotifier,
              builder: (context, lang, _) {
                final user = prefs.userObj;
                final isAr = lang == 'ar';

                final contentWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Logo Section
                    Container(
                      margin: const EdgeInsets.only(
                        top: 35,
                        bottom: 15,
                        left: 35,
                        right: 35,
                      ),
                      height: 90.w,
                      width: 90.w,
                      child: Image.asset(
                        AppAssets.logoPng,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Logged in User Name or Welcome Title
                    if (user != null)
                      Container(
                        width: 200.sp,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '${user.name}',
                          style: TextStyle(
                            color: AppStyle.twilight,
                            fontSize: 14.sp,
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: isAr ? TextAlign.right : TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    const SizedBox(height: 10),

                    // --- SECTION: الرئيسية (Main) ---
                    if (user != null) ...[
                      _buildSectionHeader(isAr ? 'الرئيسية' : 'Main'),
                      DrawerItemWidget(
                        title:
                            context.translate('dashboardTitle') ?? 'Dashboard',
                        icon: Icon(
                          Icons.dashboard_rounded,
                          color: AppStyle.bayZeroColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          locator<LandingTabsManager>().tabIndex = 0;
                          ZoomDrawer.of(context)?.close();
                        },
                      ),
                    ],

                    // --- SECTION: خدمات أولياء الأمور (Parent Services) ---
                    if (user != null && user.userType == 'Parent') ...[
                      _buildSectionHeader(
                        context.translate('parentServices') ??
                            'Parent Services',
                      ),
                      DrawerItemWidget(
                        title:
                            context.translate('newStudentForm') ??
                            'New Student Form',
                        icon: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: AppStyle.blueCyan,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('newStudentForm') ??
                                'New Student Form',
                            isAr,
                          );
                        },
                      ),
                      DrawerItemWidget(
                        title:
                            context.translate('availableInterviews') ??
                            'Available Interviews',
                        icon: Icon(
                          Icons.event_available_rounded,
                          color: AppStyle.mauve,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('availableInterviews') ??
                                'Available Interviews',
                            isAr,
                          );
                        },
                      ),
                      DrawerItemWidget(
                        title:
                            context.translate('admissionsTitle') ??
                            'Admissions',
                        icon: Icon(
                          Icons.assignment_rounded,
                          color: AppStyle.secondaryColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('admissionsTitle') ??
                                'Admissions',
                            isAr,
                          );
                        },
                      ),
                      if (user.allStudent != null && user.allStudent! > 0)
                        DrawerItemWidget(
                          title:
                              context.translate('studentsTitle') ?? 'Students',
                          icon: Icon(
                            Icons.people_alt_rounded,
                            color: AppStyle.bayZeroColor,
                            size: 20.sp,
                          ),
                          onClick: () {
                            locator<LandingTabsManager>().tabIndex = 3;
                            ZoomDrawer.of(context)?.close();
                          },
                        ),
                      DrawerItemWidget(
                        title:
                            context.translate('notifications') ??
                            'Notifications',
                        icon: Icon(
                          Icons.notifications_active_rounded,
                          color: AppStyle.mauve,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('notifications') ??
                                'Notifications',
                            isAr,
                          );
                        },
                      ),
                    ],

                    // --- SECTION: خدمات الموظفين (Employee Services) ---
                    if (user != null && user.userType == 'Employee') ...[
                      _buildSectionHeader(
                        context.translate('employeeServices') ??
                            'Employee Services',
                      ),

                      DrawerItemWidget(
                        title:
                            context.translate('notifications') ??
                            'Notifications',
                        icon: Icon(
                          Icons.notifications_active_rounded,
                          color: AppStyle.mauve,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('notifications') ??
                                'Notifications',
                            isAr,
                          );
                        },
                      ),

                      if (user.roles != null &&
                          user.roles!.split(',').contains('MobileAdmin')) ...[
                        DrawerItemWidget(
                          title:
                              context.translate('admissionsTitle') ??
                              'Admissions',
                          icon: Icon(
                            Icons.admin_panel_settings_rounded,
                            color: AppStyle.secondaryColor,
                            size: 20.sp,
                          ),
                          onClick: () {
                            _showComingSoon(
                              context,
                              context.translate('admissionsTitle') ??
                                  'Admissions',
                              isAr,
                            );
                          },
                        ),
                        DrawerItemWidget(
                          title:
                              context.translate('admissionSchedule') ??
                              'Admission Schedule',
                          icon: Icon(
                            Icons.calendar_month_rounded,
                            color: AppStyle.blueCyan,
                            size: 20.sp,
                          ),
                          onClick: () {
                            _showComingSoon(
                              context,
                              context.translate('admissionSchedule') ??
                                  'Admission Schedule',
                              isAr,
                            );
                          },
                        ),
                        DrawerItemWidget(
                          title:
                              context.translate('interviewsSchedule') ??
                              'Interviews Schedule',
                          icon: Icon(
                            Icons.groups_rounded,
                            color: AppStyle.mauve,
                            size: 20.sp,
                          ),
                          onClick: () {
                            _showComingSoon(
                              context,
                              context.translate('interviewsSchedule') ??
                                  'Interviews Schedule',
                              isAr,
                            );
                          },
                        ),
                      ],

                      if (user.roles != null &&
                          user.roles!
                              .split(',')
                              .contains('BlockAttendance')) ...[
                        DrawerItemWidget(
                          title:
                              context.translate('blockAttendance') ??
                              'Block Attendance',
                          icon: Icon(
                            Icons.co_present_rounded,
                            color: AppStyle.bayZeroColor,
                            size: 20.sp,
                          ),
                          onClick: () {
                            _showComingSoon(
                              context,
                              context.translate('blockAttendance') ??
                                  'Block Attendance',
                              isAr,
                            );
                          },
                        ),
                        DrawerItemWidget(
                          title:
                              context.translate('dailyAbsence') ??
                              'Daily Absence',
                          icon: Icon(
                            Icons.person_off_rounded,
                            color: AppStyle.secondaryColor,
                            size: 20.sp,
                          ),
                          onClick: () {
                            _showComingSoon(
                              context,
                              context.translate('dailyAbsence') ??
                                  'Daily Absence',
                              isAr,
                            );
                          },
                        ),
                      ],
                    ],

                    // --- SECTION: الإعدادات العامة (General) ---
                    _buildSectionHeader(
                      context.translate('generalSettings') ??
                          'General Settings',
                    ),

                    DrawerItemWidget(
                      title: context.translate('whyGhars') ?? 'Why Ghars?',
                      icon: Icon(
                        Icons.help_outline_rounded,
                        color: AppStyle.blueCyan,
                        size: 20.sp,
                      ),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WhyGharsPage(),
                          ),
                        );
                      },
                    ),

                    DrawerItemWidget(
                      title: context.translate('aboutUs') ?? 'About Us',
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: AppStyle.mauve,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _showComingSoon(
                          context,
                          context.translate('aboutUs') ?? 'About Us',
                          isAr,
                        );
                      },
                    ),

                    if (user != null)
                      DrawerItemWidget(
                        title:
                            context.translate('changePassword') ??
                            'Change Password',
                        icon: Icon(
                          Icons.lock_reset_rounded,
                          color: AppStyle.twilight,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('changePassword') ??
                                'Change Password',
                            isAr,
                          );
                        },
                      ),

                    if (user != null)
                      DrawerItemWidget(
                        title:
                            context.translate(AppStrings.deleteAccount) ??
                            'Delete Account',
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: AppStyle.secondaryColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          ZoomDrawer.of(context)?.close();
                          logoutAndLoginDialogAndDeleteAccount(
                            context,
                            dialogAction: DialogAction.deleteAccount,
                            onClickLogoutBtn: () {
                              prefs.clearUserSession();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutesNames.onboardingPage,
                                (Route<dynamic> route) => false,
                              );
                            },
                          );
                        },
                      ),

                    DrawerItemWidget(
                      title: isAr ? 'English' : 'العربية',
                      icon: Icon(
                        Icons.language_rounded,
                        color: AppStyle.blueCyan,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _changeLanguage(lang);
                      },
                    ),

                    if (user == null)
                      DrawerItemWidget(
                        title:
                            context.translate('registrationForm') ??
                            'Registration Form',
                        icon: Icon(
                          Icons.person_add_alt_rounded,
                          color: AppStyle.bayZeroColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _showComingSoon(
                            context,
                            context.translate('registrationForm') ??
                                'Registration Form',
                            isAr,
                          );
                        },
                      ),

                    const SizedBox(height: 30),

                    // Log in / Log out button
                    Container(
                      height: 48,
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        bottom: 50,
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppStyle.appColor,
                          shadowColor: AppStyle.appColor.withValues(alpha: 0.3),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          context.translate(
                                user != null
                                    ? AppStrings.logout
                                    : AppStrings.login,
                                ) ??
                                '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          ZoomDrawer.of(context)?.close();
                          if (user != null) {
                            logoutAndLoginDialogAndDeleteAccount(
                              context,
                              dialogAction: DialogAction.logout,
                              onClickLogoutBtn: () {
                                prefs.clearUserSession();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutesNames.onboardingPage,
                                  (Route<dynamic> route) => false,
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutesNames.onboardingPage,
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );

                return lang == "en"
                    ? SlideInLeft(
                        manualTrigger: true,
                        controller: (controller) =>
                            _innerController = controller,
                        duration: const Duration(milliseconds: 500),
                        child: contentWidget,
                      )
                    : SlideInRight(
                        manualTrigger: true,
                        controller: (controller) =>
                            _innerController = controller,
                        duration: const Duration(milliseconds: 500),
                        child: contentWidget,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

