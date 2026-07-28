import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:ghars_school/app_core/locator.dart';
import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/gallery_image_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/employee_dashboard_model.dart';

class HomeRepo extends BaseRepository {
  Future<ListResult<List<ImagesGallery>>?> getDashboardImages({CachePolicy? cachePolicy}) async {
    return await getRequest<List<ImagesGallery>>(
      path: 'School/GetAllImagesGallery',
      options: cachePolicy != null ? Options(extra: globalCacheOptions.copyWith(policy: cachePolicy).toExtra()) : null,
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

  Future<ListResult<ParentDashboardModel>?> getParentDashboard({CachePolicy? cachePolicy}) async {
    return await getRequest<ParentDashboardModel>(
      path: 'School/ListParentDashboard',
      options: cachePolicy != null ? Options(extra: globalCacheOptions.copyWith(policy: cachePolicy).toExtra()) : null,
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('parentDashboardModel')) {
          return ParentDashboardModel.fromJson(json['parentDashboardModel'] as Map<String, dynamic>);
        }
        return ParentDashboardModel.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  Future<ListResult<EmployeeDashboardModel>?> getEmployeeDashboard({CachePolicy? cachePolicy}) async {
    return await getRequest<EmployeeDashboardModel>(
      path: 'School/ListAdminDashboard',
      options: cachePolicy != null ? Options(extra: globalCacheOptions.copyWith(policy: cachePolicy).toExtra()) : null,
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('dashbord')) {
          return EmployeeDashboardModel.fromJson(json['dashbord'] as Map<String, dynamic>);
        }
        return EmployeeDashboardModel.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
