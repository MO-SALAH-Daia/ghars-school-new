import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';

class StudentStatsBar extends StatelessWidget {
  final StudentDto studentDetails;

  const StudentStatsBar({super.key, required this.studentDetails});

  @override
  Widget build(BuildContext context) {
    final isAr = locator<PrefsService>().appLanguage == "ar";

    // 1. Calculate actual absences
    final absenceList =
        studentDetails.studentAttendenceAbsenceLate
            ?.where((element) => element.isAbsence == true)
            .toList() ??
        [];
    final absenceCount = absenceList.length;

    // 2. Calculate actual tardiness (late)
    final lateList =
        studentDetails.studentAttendenceAbsenceLate
            ?.where(
              (element) =>
                  element.attLateMins != null && element.attLateMins! > 0,
            )
            .toList() ??
        [];
    final lateCount = lateList.length;

    // 3. Stage name
    final stage = isAr
        ? (studentDetails.regStageName1 ?? studentDetails.regStageName2 ?? '')
        : (studentDetails.regStageName2 ?? studentDetails.regStageName1 ?? '');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              title: isAr ? 'الغياب' : 'Absences',
              value: '$absenceCount',
              // unit: isAr ? 'يوم' : 'days',
              unit: '',
              icon: Icons.calendar_today_rounded,
              color: const Color(0xFFE53935),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _StatCard(
              title: isAr ? 'التأخيرات' : 'Tardiness',
              value: '$lateCount',
              // unit: isAr ? 'مرة' : 'times',
              unit: '',
              icon: Icons.access_time_rounded,
              color: const Color(0xFFFB8C00),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _StatCard(
              title: isAr ? 'المرحلة' : 'Stage',
              value: stage.isNotEmpty ? stage : '-',
              unit: '',
              icon: Icons.school_rounded,
              color: AppStyle.bayZeroColor,
              isTextValue: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isTextValue;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.isTextValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isTextValue ? 12.sp : 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.twilight,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              if (unit.isNotEmpty) ...[
                SizedBox(width: 3.w),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade500,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
