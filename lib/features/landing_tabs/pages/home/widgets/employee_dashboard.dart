import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/employee_dashboard_model.dart';

class EmployeeDashboard extends StatelessWidget {
  final EmployeeDashboardModel? data;
  final bool isArabic;
  final Function(String) onShowComingSoon;

  const EmployeeDashboard({
    super.key,
    required this.data,
    required this.isArabic,
    required this.onShowComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Services Grid
        Text(
          isArabic ? 'الخدمات اليومية للموظف' : 'Daily Employee Services',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.twilight,
          ),
        ),
        SizedBox(height: 8.h),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.w,
            childAspectRatio: 1.25,
          ),
          children: [
            _buildServiceCard(
              icon: Icons.co_present,
              title: isArabic ? 'تسجيل الغياب بالكتل' : 'Block Attendance',
              color: AppStyle.appColor,
              onTap: () => onShowComingSoon(
                isArabic ? 'تسجيل الغياب بالكتل' : 'Block Attendance',
              ),
            ),
            _buildServiceCard(
              icon: Icons.playlist_remove,
              title: isArabic ? 'تسجيل الغياب اليومي' : 'Daily Absence',
              color: AppStyle.secondaryColor,
              onTap: () => onShowComingSoon(
                isArabic ? 'تسجيل الغياب اليومي' : 'Daily Absence',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Admission Requests Stats
        Text(
          isArabic
              ? 'إحصائيات طلبات الالتحاق'
              : 'Admissions Requests Statistics',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.twilight,
          ),
        ),
        SizedBox(height: 8.h),
        _buildEmployeeStatsCard(data!, isArabic),
      ],
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppStyle.greyLight.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28.sp),
              SizedBox(height: 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.twilight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeStatsCard(EmployeeDashboardModel data, bool isArabic) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppStyle.greyLight.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          _buildStatsRow(
            label: isArabic ? 'إجمالي الطلبات' : 'Total Requests',
            value: '${data.allStudentRequest}',
            color: AppStyle.twilight,
          ),
          const Divider(),
          _buildStatsRow(
            label: isArabic ? 'الطلبات المرفوعة' : 'Requested',
            value: '${data.allStudentRequestRequested}',
            color: Colors.amber,
          ),
          _buildStatsRow(
            label: isArabic ? 'قيد الانتظار' : 'Pending',
            value: '${data.allStudentRequestPending}',
            color: Colors.orange,
          ),
          _buildStatsRow(
            label: isArabic ? 'تم إجراء مقابلة' : 'Interviewed',
            value: '${data.allStudentRequestInterviewed}',
            color: Colors.blue,
          ),
          _buildStatsRow(
            label: isArabic ? 'مقبول' : 'Accepted',
            value: '${data.allStudentRequestAccepted}',
            color: Colors.purple,
          ),
          _buildStatsRow(
            label: isArabic ? 'تمت الموافقة عليه' : 'Approved',
            value: '${data.allStudentRequestApproved}',
            color: Colors.green,
          ),
          _buildStatsRow(
            label: isArabic ? 'مرفوض' : 'Rejected',
            value: '${data.allStudentRequestRejected}',
            color: Colors.red,
          ),
          _buildStatsRow(
            label: isArabic ? 'مستبقى / مؤجل' : 'Waited',
            value: '${data.allStudentRequestWaited}',
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.twilight,
            ),
          ),
        ],
      ),
    );
  }
}
