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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.badge_outlined,
            title: locator<PrefsService>().appLanguage == "ar"
                ? 'الرقم المدني'
                : 'Civil ID',
            value: student.idNo ?? '-',
          ),
          _buildInfoCard(
            icon: Icons.cake_outlined,
            title: locator<PrefsService>().appLanguage == "ar"
                ? 'تاريخ الميلاد'
                : 'Date of Birth',
            value: student.birthDate != null
                ? DateFormat(
                    'dd-MM-yyyy',
                  ).format(DateTime.parse(student.birthDate!))
                : '-',
          ),
          _buildInfoCard(
            icon: Icons.email_outlined,
            title: context.translate(AppStrings.emailAddress) ?? 'Email',
            value:
                (student.studentEmails != null &&
                    student.studentEmails!.isNotEmpty)
                ? student.studentEmails!.first.email ?? '-'
                : '-',
          ),
          _buildInfoCard(
            icon: Icons.phone_outlined,
            title: context.translate(AppStrings.phoneNumber) ?? 'Mobile',
            value: student.tel1 ?? student.tel2 ?? '-',
          ),
          _buildInfoCard(
            icon: Icons.school_outlined,
            title: locator<PrefsService>().appLanguage == "ar"
                ? 'المدرسة'
                : 'School',
            value: () {
              final isAr = locator<PrefsService>().appLanguage == "ar";
              return isAr
                  ? (student.regStageName1 ?? student.regStageName2 ?? '')
                  : (student.regStageName2 ?? student.regStageName1 ?? '');
            }(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
