import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';
import 'package:intl/intl.dart';

class StudentLateTab extends StatelessWidget {
  final List<StudentAttendenceAbsenceLate> attendances;

  const StudentLateTab({super.key, required this.attendances});

  @override
  Widget build(BuildContext context) {
    // Filter tardiness
    final lates = attendances
        .where((a) => a.attLateMins != null && a.attLateMins! > 0)
        .toList();

    if (lates.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: Center(
          child: Text(
            locator<PrefsService>().appLanguage == "ar"
                ? 'لا يوجد تأخير'
                : 'No tardiness found',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );
    }

    final isAr = locator<PrefsService>().appLanguage == "ar";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: List.generate(lates.length, (index) {
          final item = lates[index];
          final date = item.attDate != null
              ? DateFormat('dd-MM-yyyy').format(DateTime.parse(item.attDate!))
              : '-';

          final dayName = item.day_namear ?? '-';

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.orange.shade100),
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
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.timer_rounded,
                    color: Colors.orange.shade400,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.twilight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: Colors.grey.shade600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    isAr
                        ? '${item.attLateMins} دقيقة'
                        : '${item.attLateMins} Min',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
