import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';

class StudentHeader extends StatelessWidget {
  final StudentDto? studentDetails;

  const StudentHeader({super.key, this.studentDetails});

  @override
  Widget build(BuildContext context) {
    if (studentDetails == null) return const SizedBox.shrink();

    final isAr = locator<PrefsService>().appLanguage == "ar";
    final name = isAr
        ? (studentDetails!.name1 ?? studentDetails!.name2 ?? '')
        : (studentDetails!.name2 ?? studentDetails!.name1 ?? '');
    final grade = isAr
        ? (studentDetails!.studntGradeName1 ?? '')
        : (studentDetails!.studntGradeName2 ?? '');
    final className = isAr
        ? (studentDetails!.studntClassName1 ?? '')
        : (studentDetails!.studntClassName2 ?? '');
    final photo = studentDetails!.photo1Fullpath;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar Side
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppStyle.bayZeroColor, width: 2.w),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppStyle.bayZeroColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: photo != null && photo.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: photo,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.person_rounded,
                          size: 38.r,
                          color: Colors.grey.shade400,
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        size: 38.r,
                        color: Colors.grey.shade400,
                      ),
              ),
            ),
            SizedBox(width: 14.w),
            // Student Info Side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.twilight,
                      fontFamily: 'Cairo',
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: [
                      if (grade.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyle.bayZeroColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            grade,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppStyle.bayZeroColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      if (className.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyle.blueCyan.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.meeting_room_outlined,
                                size: 12.sp,
                                color: AppStyle.blueCyan,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                className,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppStyle.blueCyan,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
