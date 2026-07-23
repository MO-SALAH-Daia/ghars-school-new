import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCard extends StatelessWidget {
  final bool isArabic;

  const LocationCard({
    super.key,
    required this.isArabic,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    const schoolAddress = "Ghars Bilingual School - مدرسة غرس";
    const locationUrl =
        "https://maps.google.com/maps?q=29.34455161063364,48.085777164685474";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppStyle.greyLight.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'موقع المدرسة' : 'School Location',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.twilight,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  schoolAddress,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton.icon(
                onPressed: () => _launchURL(locationUrl),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.blueCyan,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
                icon: Icon(Icons.map_outlined, size: 16.sp),
                label: Text(
                  isArabic ? 'خرائط جوجل' : 'Google Maps',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
