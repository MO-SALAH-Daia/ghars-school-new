import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';
import 'package:intl/intl.dart';

class StudentAbsenceTab extends StatelessWidget {
  final List<StudentAttendenceAbsenceLate> attendances;

  const StudentAbsenceTab({super.key, required this.attendances});

  @override
  Widget build(BuildContext context) {
    final absences = attendances.where((a) => a.isAbsence == true).toList();

    if (absences.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: Center(
          child: Text(
            locator<PrefsService>().appLanguage == "ar"
                ? 'لا يوجد غياب'
                : 'No absences found',
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
        children: List.generate(absences.length, (index) {
          final absence = absences[index];
          final date = absence.attDate != null
              ? DateFormat(
                  'dd-MM-yyyy',
                ).format(DateTime.parse(absence.attDate!))
              : '-';

          final dayName = absence.day_namear ?? '-';

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.red.shade100),
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
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.red.shade400,
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
                if (absence.isAvailableToUploadFile == true)
                  OutlinedButton(
                    onPressed: () {
                      locator<ToastTemplate>().show(
                        "Upload excuse coming soon",
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppStyle.appColor,
                      side: BorderSide(color: AppStyle.appColor),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      isAr ? 'رفع عذر' : 'Upload Excuse',
                      style: TextStyle(fontSize: 11.sp, fontFamily: 'Cairo'),
                    ),
                  )
                else if (absence.absenceApproved == true)
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 22.sp,
                  )
                else if (absence.dayAbsenceFile != null)
                  Icon(
                    Icons.access_time_filled_rounded,
                    color: Colors.orange,
                    size: 22.sp,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
