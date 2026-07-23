import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/app_core/domain/user.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/home_dashboard_data.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/widgets/employee_dashboard.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/widgets/guest_dashboard.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/widgets/home_carousel.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/widgets/home_header.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/widgets/parent_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeManager _manager = locator<HomeManager>();

  @override
  void initState() {
    super.initState();
    _manager.initDashboard();
  }

  void _showComingSoon(String title, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: isArabic ? 'قريباً' : 'Coming Soon',
        description: isArabic
            ? 'ميزة $title ستتوفر في التحديث القادم.'
            : '$title feature will be available in the next update.',
        confirmBtnTxt: isArabic ? 'حسناً' : 'OK',
        onClickConfirmBtn: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.use<PrefsService>();
    final isArabic = prefs.appLanguage == 'ar';
    final user = prefs.userObj;

    return Scaffold(
      backgroundColor: const Color(0xfff8faf6), // Soft organic background
      body: RefreshIndicator(
        onRefresh: () => _manager.refreshDashboard(),
        color: AppStyle.appColor,
        child: Stack(
          children: [
            // Background organic gradient with soft glows
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffedf4e8), // Soft brand green tint
                    Color(0xfff5f8f3), // Very light organic tint
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Floating ambient glows
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.blueCyan.withValues(alpha: 0.05),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              top: 300.h,
              left: -150.w,
              child: Container(
                width: 350.w,
                height: 350.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.appColor.withValues(alpha: 0.04),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            SafeArea(
              child: Observer<HomeDashboardData>(
                stream: _manager.dashboardData$,
                onRetryClicked: () => _manager.initDashboard(),
                onSuccess: (context, dashboardData) {
                  final images = dashboardData.images;

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Header Section
                      SliverToBoxAdapter(
                        child: HomeHeader(user: user, isArabic: isArabic),
                      ),

                      // Carousel Section
                      if (images.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: HomeCarousel(images: images),
                          ),
                        ),

                      // Main Dashboard Content
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _buildRoleDashboard(
                            user,
                            dashboardData,
                            isArabic,
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Load proper dashboard widget based on role
  Widget _buildRoleDashboard(
    User? user,
    HomeDashboardData data,
    bool isArabic,
  ) {
    if (user?.token == null) {
      return GuestDashboard(isArabic: isArabic);
    } else if (user?.userType == 'Employee') {
      return EmployeeDashboard(
        data: data.employeeData,
        isArabic: isArabic,
        onShowComingSoon: (title) => _showComingSoon(title, isArabic),
      );
    } else {
      return ParentDashboard(
        data: data.parentData,
        isArabic: isArabic,
        onShowComingSoon: (title) => _showComingSoon(title, isArabic),
      );
    }
  }
}
