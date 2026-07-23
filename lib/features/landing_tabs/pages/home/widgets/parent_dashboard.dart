import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';

import 'location_card.dart';

class ParentDashboard extends StatelessWidget {
  final ParentDashboardModel? data;
  final bool isArabic;
  final Function(String) onShowComingSoon;

  const ParentDashboard({
    super.key,
    required this.data,
    required this.isArabic,
    required this.onShowComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();

    final activeStudents =
        data!.studentDtos?.where((e) => e.stuStatus == '1').toList() ?? [];

    final hasFinancialDues =
        data!.parentInvoiceDetailDtos != null &&
        data!.parentInvoiceDetailDtos!.isNotEmpty;
    final hasStudentRequests =
        data!.studentRequestDtos != null &&
        data!.studentRequestDtos!.isNotEmpty;

    return Column(
      children: [
        // Quick Stats Grid
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: _buildQuickStats(data!, activeStudents.length, isArabic),
        ),

        // Financial Summary Block
        if (hasFinancialDues) ...[
          SizedBox(height: 14.h),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: _buildFinancialDues(data!, isArabic),
          ),
        ],

        // Student Requests Block
        if (hasStudentRequests) ...[
          SizedBox(height: 14.h),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: _buildStudentRequests(data!.studentRequestDtos!, isArabic),
          ),
        ],

        SizedBox(height: 14.h),
        // School Location Card
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: LocationCard(isArabic: isArabic),
        ),
      ],
    );
  }

  Widget _buildQuickStats(
    ParentDashboardModel data,
    int activeStudentsCount,
    bool isArabic,
  ) {
    final String studentsLabel = isArabic
        ? 'الطلاب المسجلين'
        : 'Registered Students';
    final String registerLabel = isArabic ? 'طلبات الالتحاق' : 'Admissions';
    final String installmentsLabel = isArabic
        ? 'الفواتير المستحقة'
        : 'Due Installments';

    final int admissionsCount = data.studentRequestDtos?.length ?? 0;
    final int invoiceCount =
        data.parentInvoiceDetailDtos
            ?.where((e) => e.saleInvoiceTypeId != 2)
            .length ??
        0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.w,
      childAspectRatio: 0.8, // Taller cards to prevent vertical overflow
      children: [
        _buildStatCard(
          icon: Icons.people_alt_outlined,
          count: activeStudentsCount.toString(),
          title: studentsLabel,
          color: AppStyle.appColor,
          onTap: () => onShowComingSoon(studentsLabel),
        ),
        _buildStatCard(
          icon: Icons.app_registration,
          count: admissionsCount.toString(),
          title: registerLabel,
          color: AppStyle.secondaryColor,
          onTap: () => onShowComingSoon(registerLabel),
        ),
        _buildStatCard(
          icon: Icons.receipt_long_outlined,
          count: invoiceCount.toString(),
          title: installmentsLabel,
          color: AppStyle.blueCyan,
          onTap: () => onShowComingSoon(installmentsLabel),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
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
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppStyle.greyLight.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.04),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(height: 4.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.twilight,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: AppStyle.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialDues(ParentDashboardModel data, bool isArabic) {
    final paidCount = data.parentDashboardDto?.allInvoiceDetailPaid ?? 0;
    final totalCount = data.parentDashboardDto?.allInvoiceDetail ?? 0;
    final unpaidCount = totalCount - paidCount;

    double progress = totalCount > 0 ? (paidCount / totalCount) : 0.0;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppStyle.greyLight.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic
                    ? 'تفاصيل المستحقات المالية'
                    : 'Details of Financial Dues',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.twilight,
                ),
              ),
              Icon(Icons.wallet, color: AppStyle.appColor, size: 22.sp),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'الأقساط المسددة' : 'Paid Installments',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppStyle.lightGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$paidCount / $totalCount',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.appColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isArabic ? 'الأقساط المتبقية' : 'Remaining Installments',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppStyle.lightGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$unpaidCount',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Sleek progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: AppStyle.greyLight.withValues(alpha: 0.4),
              valueColor: AlwaysStoppedAnimation<Color>(AppStyle.appColor),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}% ${isArabic ? 'مسدد' : 'paid'}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppStyle.lightGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onShowComingSoon(
                    isArabic
                        ? 'سجل الفواتير والدفع'
                        : 'Invoices & Payment History',
                  );
                },
                child: Text(
                  isArabic
                      ? 'عرض الفواتير التفصيلية ←'
                      : 'View invoices details →',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppStyle.blueCyan,
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

  Widget _buildStudentRequests(
    List<StudentRequestDto> requests,
    bool isArabic,
  ) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'طلبات التسجيل القائمة' : 'Active Admissions',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.twilight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppStyle.appColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${requests.length}',
                  style: TextStyle(
                    color: AppStyle.appColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            separatorBuilder: (context, index) =>
                Divider(height: 20.h, color: Colors.grey[100]),
            itemBuilder: (context, index) {
              final req = requests[index];
              final statusColor = _getStatusColor(req.status);
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.assignment_ind,
                      color: statusColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? req.name_1_1 ?? '' : req.name_2_1 ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppStyle.twilight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          isArabic
                              ? (req.regGreadName1 ?? '')
                              : (req.regGreadName2 ?? ''),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppStyle.lightGrey,
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
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      isArabic ? req.statusAr ?? '' : req.statusEn ?? '',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "1":
        return Colors.amber;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.blue;
      case "4":
        return Colors.purple;
      case "5":
        return Colors.green;
      case "6":
        return Colors.red;
      default:
        return Colors.deepOrange;
    }
  }
}
