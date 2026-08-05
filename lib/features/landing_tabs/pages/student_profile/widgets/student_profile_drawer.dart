import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/student_profile_manager.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_item.dart';

class StudentProfileDrawer extends StatelessWidget {
  const StudentProfileDrawer({super.key});

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
    final bool isAr = locator<PrefsService>().appLanguage == "ar";
    final manager = locator<StudentProfileManager>();

    final List<(IconData, String)> menuItems = [
      (Icons.home_rounded, isAr ? 'الرئيسية' : 'Home'),
      (Icons.grade_rounded, isAr ? 'دفتر الدرجات' : 'Grade Book'),
      (Icons.person_rounded, isAr ? 'المدرسين' : 'Teachers'),
      (Icons.cancel_rounded, isAr ? 'الغياب' : 'Absences'),
      (Icons.timer_rounded, isAr ? 'التأخيرات' : 'Tardiness'),
      (
        Icons.health_and_safety_rounded,
        isAr ? 'الرعاية المدرسية' : 'School Care',
      ),
      (
        Icons.account_balance_wallet_rounded,
        isAr ? 'حسابات الطالب' : 'Student Accounts',
      ),
      (Icons.attachment_rounded, isAr ? 'تعديل المرفقات' : 'Edit Attachments'),
    ];

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
            child: Observer<StudentDto?>(
              stream: manager.selectedStudent$,
              onSuccess: (context, selectedStudent) {
                final studentName = isAr
                    ? (selectedStudent?.name1 ?? selectedStudent?.name2 ?? '')
                    : (selectedStudent?.name2 ?? selectedStudent?.name1 ?? '');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Logo / Header Section
                    Container(
                      margin: EdgeInsets.only(
                        top: 25.h,
                        bottom: 12.h,
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50.w,
                            width: 50.w,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              AppAssets.logoPng,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAr ? 'ملف الطالب' : 'Student Profile',
                                  style: TextStyle(
                                    color: AppStyle.bayZeroColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                if (studentName.isNotEmpty)
                                  Text(
                                    studentName,
                                    style: TextStyle(
                                      color: AppStyle.twilight,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    _buildSectionHeader(
                      isAr ? 'أقسام ملف الطالب' : 'Student Sections',
                    ),

                    // 8 Menu Items
                    Observer<int>(
                      stream: manager.selectedTab$,
                      onSuccess: (context, selectedIndex) {
                        return Column(
                          children: List.generate(menuItems.length, (index) {
                            final isSelected = selectedIndex == index;
                            final item = menuItems[index];

                            return DrawerItemWidget(
                              title: item.$2,
                              icon: Icon(
                                item.$1,
                                color: isSelected
                                    ? AppStyle.appColor
                                    : AppStyle.bayZeroColor,
                                size: 20.sp,
                              ),
                              onClick: () {
                                manager.selectTab(index);
                                ZoomDrawer.of(context)?.close();
                              },
                            );
                          }),
                        );
                      },
                    ),

                    SizedBox(height: 30.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
