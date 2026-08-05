import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';

class StudentSelectorDropdown extends StatelessWidget {
  final List<StudentDto> students;
  final StudentDto? selectedStudent;
  final ValueChanged<StudentDto?> onChanged;

  const StudentSelectorDropdown({
    super.key,
    required this.students,
    required this.selectedStudent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const SizedBox.shrink();
    final isAr = locator<PrefsService>().appLanguage == "ar";

    final actualSelectedStudent =
        selectedStudent != null &&
            students.any((s) => s.id == selectedStudent!.id)
        ? students.firstWhere((s) => s.id == selectedStudent!.id)
        : (students.isNotEmpty ? students.first : null);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<StudentDto>(
          value: actualSelectedStudent,
          isExpanded: true,
          hint: Text(
            context.translate(AppStrings.select) ?? 'Select Student',
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Cairo',
              color: Colors.grey.shade600,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppStyle.bayZeroColor,
            size: 22.sp,
          ),
          items: students.map((student) {
            final name = isAr
                ? (student.name1 ?? student.name2 ?? '')
                : (student.name2 ?? student.name1 ?? '');
            return DropdownMenuItem<StudentDto>(
              value: student,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.twilight,
                  fontFamily: 'Cairo',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
