import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/student_profile_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/widgets/student_absence_tab.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/widgets/student_header.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/widgets/student_late_tab.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/widgets/student_main_info_tab.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/widgets/student_selector_dropdown.dart';
import 'package:ghars_school/shared/main_app_bar/main_app_bar.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final StudentProfileManager _manager = locator<StudentProfileManager>();
  final HomeManager _homeManager = locator<HomeManager>();

  @override
  void initState() {
    super.initState();
    _manager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: MainAppBar(
          title: locator<PrefsService>().appLanguage == "ar"
              ? 'ملف الطالب'
              : 'Student Profile',
          hasDrawerBtn: true,
        ),
      ),
      body: Observer(
        stream: _homeManager.dashboardData$,
        onWaiting: (context) => const FormsStateHandling(
          managerState: ManagerState.loading,
          child: SizedBox.shrink(),
        ),
        onSuccess: (context, homeData) {
          final students = homeData.parentData?.studentDtos ?? [];

          if (students.isEmpty) {
            return Center(
              child: Text(
                locator<PrefsService>().appLanguage == "ar"
                    ? 'لا توجد بيانات'
                    : 'No students found',
              ),
            );
          }

          return Observer(
            stream: _manager.selectedStudent$,
            onSuccess: (context, selectedStudent) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: StudentSelectorDropdown(
                        students: students,
                        selectedStudent: selectedStudent,
                        onChanged: (student) {
                          if (student != null) {
                            _manager.selectStudent(student);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Observer(
                      stream: _manager.state$,
                      onSuccess: (context, state) {
                        if (state == ManagerState.loading) {
                          return const FormsStateHandling(
                            managerState: ManagerState.loading,
                            child: SizedBox.shrink(),
                          );
                        }
                        if (state == ManagerState.error) {
                          return Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Center(
                              child: Text(
                                locator<PrefsService>().appLanguage == "ar"
                                    ? 'لا توجد بيانات'
                                    : 'Error loading data',
                              ),
                            ),
                          );
                        }

                        return Observer(
                          stream: _manager.studentDetails$,
                          onSuccess: (context, details) {
                            if (details == null ||
                                details.result == null ||
                                details.result!.studentDto == null) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                StudentHeader(
                                  studentDetails: details.result!.studentDto,
                                ),
                                SizedBox(height: 14.h),
                                Observer(
                                  stream: _manager.selectedTab$,
                                  onSuccess: (context, selectedIndex) {
                                    final isAr =
                                        locator<PrefsService>().appLanguage ==
                                        "ar";
                                    final sectionNames = [
                                      isAr ? 'الرئيسية' : 'Home',
                                      isAr ? 'دفتر الدرجات' : 'Grade Book',
                                      isAr ? 'المدرسين' : 'Teachers',
                                      isAr ? 'الغياب' : 'Absences',
                                      isAr ? 'التأخيرات' : 'Tardiness',
                                      isAr ? 'الرعاية المدرسية' : 'School Care',
                                      isAr
                                          ? 'حسابات الطالب'
                                          : 'Student Accounts',
                                      isAr
                                          ? 'تعديل المرفقات'
                                          : 'Edit Attachments',
                                    ];
                                    final currentTitle =
                                        sectionNames[selectedIndex %
                                            sectionNames.length];

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.03,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 3.5.w,
                                                  height: 14.h,
                                                  decoration: BoxDecoration(
                                                    color: AppStyle.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2.r,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  currentTitle,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppStyle.twilight,
                                                    fontFamily: 'Cairo',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                locator<ZoomDrawerController>()
                                                    .toggle
                                                    ?.call();
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.menu_open_rounded,
                                                      size: 17.sp,
                                                      color:
                                                          AppStyle.bayZeroColor,
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      isAr
                                                          ? 'الأقسام'
                                                          : 'Sections',
                                                      style: TextStyle(
                                                        fontSize: 11.5.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppStyle
                                                            .bayZeroColor,
                                                        fontFamily: 'Cairo',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Observer(
                                  stream: _manager.selectedTab$,
                                  onSuccess: (context, selectedIndex) {
                                    final studentDto =
                                        details.result!.studentDto!;
                                    final attendances =
                                        studentDto
                                            .studentAttendenceAbsenceLate ??
                                        [];

                                    switch (selectedIndex) {
                                      case 0:
                                        return StudentMainInfoTab(
                                          student: studentDto,
                                        );
                                      case 1:
                                        return Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: Text(
                                              locator<PrefsService>()
                                                          .appLanguage ==
                                                      "ar"
                                                  ? 'دفتر الدرجات'
                                                  : 'Grade Book',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        );
                                      case 2:
                                        return Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: Text(
                                              locator<PrefsService>()
                                                          .appLanguage ==
                                                      "ar"
                                                  ? 'المدرسين'
                                                  : 'Teachers',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        );
                                      case 3:
                                        return StudentAbsenceTab(
                                          attendances: attendances,
                                        );
                                      case 4:
                                        return StudentLateTab(
                                          attendances: attendances,
                                        );
                                      case 5:
                                        return Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: Text(
                                              locator<PrefsService>()
                                                          .appLanguage ==
                                                      "ar"
                                                  ? 'الرعاية المدرسية'
                                                  : 'School Care',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        );
                                      case 6:
                                        return Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: Text(
                                              locator<PrefsService>()
                                                          .appLanguage ==
                                                      "ar"
                                                  ? 'حسابات الطالب'
                                                  : 'Student Accounts',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        );
                                      case 7:
                                        return Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: Text(
                                              locator<PrefsService>()
                                                          .appLanguage ==
                                                      "ar"
                                                  ? 'تعديل المرفقات'
                                                  : 'Edit Attachments',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        );
                                      default:
                                        return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 110.h),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
