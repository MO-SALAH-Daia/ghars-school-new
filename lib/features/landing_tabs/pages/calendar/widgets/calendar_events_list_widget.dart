import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/models/calendar_event_model.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class CalendarEventsListWidget extends StatelessWidget {
  final List<CalendarEventModel> events;
  final bool isArabic;
  final bool isDark;

  const CalendarEventsListWidget({
    super.key,
    required this.events,
    required this.isArabic,
    required this.isDark,
  });

  Color _getEventColor(CalendarEventModel event, int index) {
    // Generate a unique color based on event ID or index
    final List<Color> fallbackColors = [
      AppStyle.appColor,
      AppStyle.blueCyan,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
      Colors.pink.shade400,
    ];

    int colorIndex = (event.id ?? index) % fallbackColors.length;
    return fallbackColors[colorIndex];
  }

  String _formatDate(String? dateStr, bool isAr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat.yMMMMd(isAr ? 'ar' : 'en').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 60.sp,
                  color: Colors.grey.withOpacity(0.3),
                ),
                SizedBox(height: 15.h),
                Text(
                  isArabic
                      ? 'لا توجد أحداث في هذا اليوم'
                      : 'No events on this day',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final event = events[index];
          final color = _getEventColor(event, index);

          return FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: 100 * index),
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: color.withOpacity(0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: isArabic
                            ? BorderRadius.only(
                                topRight: Radius.circular(16.r),
                                bottomRight: Radius.circular(16.r),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                bottomLeft: Radius.circular(16.r),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic
                                  ? (event.nameAr ?? "")
                                  : (event.nameEn ?? ""),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    size: 14.sp,
                                    color: color,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    '${_formatDate(event.fromDate, isArabic)}'
                                    '${event.toDate != null && event.toDate != event.fromDate ? (isArabic ? ' - ' : ' - ') + _formatDate(event.toDate, isArabic) : ''}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }, childCount: events.length),
      ),
    );
  }
}
