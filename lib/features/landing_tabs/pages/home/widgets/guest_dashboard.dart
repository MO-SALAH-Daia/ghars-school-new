import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'location_card.dart';

class GuestDashboard extends StatelessWidget {
  final bool isArabic;

  const GuestDashboard({
    super.key,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppStyle.appColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppStyle.appColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.school, color: AppStyle.appColor, size: 40.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? 'مرحباً بكم في مدرسة غرس'
                          : 'Welcome to Ghars School',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.twilight,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isArabic
                          ? 'معاً نغرس قيم المستقبل'
                          : 'Together planting future values',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Intro bento cards
        Text(
          isArabic ? 'اكتشف غرس' : 'Discover Ghars',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.twilight,
          ),
        ),
        SizedBox(height: 12.h),

        _buildBentoBlock(
          title: isArabic ? 'من نحن؟' : 'Who We Are',
          description: isArabic
              ? 'مدرسة غرس ثنائية اللغة تأسست لتقديم تعليم متميز يجمع بين العقيدة الراسخة والإبداع والمسؤولية.'
              : 'Ghars Bilingual School was established to offer outstanding education blending firm faith with creativity and responsibility.',
          color: AppStyle.blueCyan,
          icon: Icons.info_outline,
        ),
        SizedBox(height: 12.h),

        _buildBentoBlock(
          title: isArabic ? 'أهدافنا' : 'Our Goals',
          description: isArabic
              ? 'نهدف إلى تطوير شخصية طلابنا علمياً، خلقياً، ونفسياً ليصبحوا قادة فاعلين في مجتمعاتهم.'
              : 'We aim to develop our students character academically, morally, and psychologically to become active leaders.',
          color: AppStyle.mauve,
          icon: Icons.track_changes,
        ),
        SizedBox(height: 24.h),

        // Location Card
        LocationCard(isArabic: isArabic),
      ],
    );
  }

  Widget _buildBentoBlock({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppStyle.greyLight.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.twilight,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: AppStyle.lightGrey,
                    height: 1.4,
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
