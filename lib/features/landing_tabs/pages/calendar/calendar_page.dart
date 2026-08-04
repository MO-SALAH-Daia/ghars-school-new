import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/calendar_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/models/calendar_event_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/widgets/calendar_events_list_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarManager _manager = locator<CalendarManager>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _manager.initCalendar();
  }

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

  @override
  Widget build(BuildContext context) {
    final prefs = context.use<PrefsService>();
    final isArabic = prefs.appLanguage == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xfff8faf6),
      body: Stack(
        children: [
          // Background organic gradient with soft glows (same as home)
          if (!isDark)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffedf4e8), Color(0xfff5f8f3), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          if (!isDark)
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.blueCyan.withValues(alpha: 0.05),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          if (!isDark)
            Positioned(
              top: 300.h,
              left: -150.w,
              child: Container(
                width: 350.w,
                height: 350.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.appColor.withValues(alpha: 0.04),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

          SafeArea(
            child: Observer<Map<DateTime, List<CalendarEventModel>>>(
              stream: _manager.events$,
              onRetryClicked: () => _manager.initCalendar(),
              onSuccess: (context, eventsByDate) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: FadeInDown(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 15.h),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: isDark
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                            ),
                            child: TableCalendar<CalendarEventModel>(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: _focusedDay,
                              locale: isArabic ? 'ar' : 'en',
                              daysOfWeekVisible: true,
                              daysOfWeekHeight: 45.h,
                              rowHeight: 52.h,
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              },
                              eventLoader: _manager.getEventsForDay,
                              calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                                todayDecoration: BoxDecoration(
                                  color: AppStyle.appColor.withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppStyle.appColor,
                                    width: 1.5,
                                  ),
                                ),
                                todayTextStyle: TextStyle(
                                  color: AppStyle.appColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                selectedDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppStyle.appColor,
                                      AppStyle.appColor.withValues(alpha: 0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppStyle.appColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey[600],
                                ),
                                weekendStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: AppStyle.appColor,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: AppStyle.appColor,
                                ),
                                titleTextStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  final events = _manager.getEventsForDay(day);
                                  if (events.isNotEmpty) {
                                    final eventColor = _getEventColor(
                                      events.first,
                                      0,
                                    );
                                    return Center(
                                      child: Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: eventColor.withValues(
                                            alpha: 0.12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: eventColor.withValues(
                                              alpha: 0.4,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                                markerBuilder: (context, day, events) {
                                  // Using the defaultBuilder to show colored box instead of dots.
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_selectedDay != null) ...[
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              isArabic ? 'أحداث اليوم' : 'Daily Events',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CalendarEventsListWidget(
                        events: _manager.getEventsForDay(_selectedDay!),
                        isArabic: isArabic,
                        isDark: isDark,
                      ),
                    ],
                    SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
