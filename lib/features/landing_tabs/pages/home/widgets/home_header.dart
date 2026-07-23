import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'package:ghars_school/app_core/domain/user.dart';

class HomeHeader extends StatelessWidget {
  final User? user;
  final bool isArabic;

  const HomeHeader({
    super.key,
    required this.user,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final String welcomeText = isArabic ? 'مرحباً بك' : 'Welcome';
    final String subText = user?.token != null
        ? (isArabic ? user?.nameAr ?? user?.name ?? '' : user?.name ?? '')
        : (isArabic ? 'زائرنا العزيز' : 'Dear Guest');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                welcomeText,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppStyle.lightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subText,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppStyle.twilight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (user?.emp_img != null && user!.emp_img!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppStyle.appColor, width: 2.w),
              ),
              child: CircleAvatar(
                radius: 24.r,
                backgroundImage: CachedNetworkImageProvider(user!.emp_img!),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyle.appColor.withValues(alpha: 0.1),
              ),
              padding: EdgeInsets.all(8.r),
              child: Icon(Icons.person, color: AppStyle.appColor, size: 26.sp),
            ),
        ],
      ),
    );
  }
}
