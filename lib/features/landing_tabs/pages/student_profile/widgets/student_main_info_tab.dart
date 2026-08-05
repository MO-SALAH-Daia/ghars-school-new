import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';
import 'package:intl/intl.dart';

class StudentMainInfoTab extends StatelessWidget {
  final StudentDto student;

  const StudentMainInfoTab({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final isAr = locator<PrefsService>().appLanguage == "ar";

    final stage = isAr
        ? (student.regStageName1 ?? student.regStageName2 ?? '')
        : (student.regStageName2 ?? student.regStageName1 ?? '');

    final grade = isAr
        ? (student.studntGradeName1 ?? student.studntGradeName2 ?? '')
        : (student.studntGradeName2 ?? student.studntGradeName1 ?? '');

    final className = isAr
        ? (student.studntClassName1 ?? student.studntClassName2 ?? '')
        : (student.studntClassName2 ?? student.studntClassName1 ?? '');

    String formattedBirthDate = '-';
    if (student.birthDate != null && student.birthDate!.isNotEmpty) {
      try {
        formattedBirthDate = DateFormat('dd-MM-yyyy').format(
          DateTime.parse(student.birthDate!),
        );
      } catch (_) {
        formattedBirthDate = student.birthDate!;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          _StudentInfoItemWidget(
            icon: Icons.badge_outlined,
            title: isAr ? 'الرقم المدني' : 'Civil ID',
            value: student.idNo ?? '-',
          ),
          _StudentInfoItemWidget(
            icon: Icons.cake_outlined,
            title: isAr ? 'تاريخ الميلاد' : 'Date of Birth',
            value: formattedBirthDate,
          ),
          _StudentInfoItemWidget(
            icon: Icons.school_outlined,
            title: isAr ? 'المرحلة الدراسية' : 'School Stage',
            value: stage.isNotEmpty ? stage : '-',
          ),
          _StudentInfoItemWidget(
            icon: Icons.class_outlined,
            title: isAr ? 'الصف الدراسي' : 'Grade',
            value: grade.isNotEmpty ? grade : '-',
          ),
          _StudentInfoItemWidget(
            icon: Icons.meeting_room_outlined,
            title: isAr ? 'الفصل' : 'Class',
            value: className.isNotEmpty ? className : '-',
          ),
        ],
      ),
    );
  }
}

class _StudentInfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StudentInfoItemWidget({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppStyle.bayZeroColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppStyle.bayZeroColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppStyle.twilight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
