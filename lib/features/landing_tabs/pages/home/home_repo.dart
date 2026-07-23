import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/gallery_image_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/employee_dashboard_model.dart';

class HomeRepo extends BaseRepository {
  Future<ListResult<List<ImagesGallery>>?> getDashboardImages() async {
    return await getRequest<List<ImagesGallery>>(
      path: 'School/GetAllImagesGallery',
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('imagesGallery')) {
          return (json['imagesGallery'] as List)
              .map((x) => ImagesGallery.fromJson(x as Map<String, dynamic>))
              .toList();
        } else if (json is List) {
          return json.map((x) => ImagesGallery.fromJson(x as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  Future<ListResult<ParentDashboardModel>?> getParentDashboard() async {
    return await getRequest<ParentDashboardModel>(
      path: 'School/ListParentDashboard',
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('parentDashboardModel')) {
          return ParentDashboardModel.fromJson(json['parentDashboardModel'] as Map<String, dynamic>);
        }
        return ParentDashboardModel.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  Future<ListResult<EmployeeDashboardModel>?> getEmployeeDashboard() async {
    return await getRequest<EmployeeDashboardModel>(
      path: 'School/ListAdminDashboard',
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('dashbord')) {
          return EmployeeDashboardModel.fromJson(json['dashbord'] as Map<String, dynamic>);
        }
        return EmployeeDashboardModel.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
