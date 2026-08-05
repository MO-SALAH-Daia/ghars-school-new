import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final photo = studentDetails!.photo1Fullpath;

    return Column(
      children: [
        Container(
          width: 72.r,
          height: 72.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppStyle.bayZeroColor, width: 2.5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: photo != null && photo.isNotEmpty
                ? CachedNetworkImage(imageUrl: photo, fit: BoxFit.cover)
                : Icon(
                    Icons.person_rounded,
                    size: 42.r,
                    color: Colors.grey.shade400,
                  ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.twilight,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        if (grade.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.5.h),
            decoration: BoxDecoration(
              color: AppStyle.bayZeroColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              grade,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: AppStyle.bayZeroColor,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ],
    );
  }
}
