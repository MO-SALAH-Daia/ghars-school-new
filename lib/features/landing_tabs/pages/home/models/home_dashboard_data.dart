import 'package:ghars_school/features/landing_tabs/pages/home/models/gallery_image_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/employee_dashboard_model.dart';

class HomeDashboardData {
  final List<ImagesGallery> images;
  final ParentDashboardModel? parentData;
  final EmployeeDashboardModel? employeeData;

  HomeDashboardData({
    required this.images,
    this.parentData,
    this.employeeData,
  });
}
