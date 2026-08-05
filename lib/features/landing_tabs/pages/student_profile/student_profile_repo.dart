import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';

class StudentProfileRepo extends BaseRepository {
  Future<ListResult<StudentProfilesModel>?> getStudentDetails({
    required int studentId,
    CachePolicy? cachePolicy,
  }) async {
    return await getRequest<StudentProfilesModel>(
      path: 'School/GetStudentDetails',
      queryParameters: {'student_id': studentId},
      options: cachePolicy != null
          ? Options(
              extra: globalCacheOptions.copyWith(policy: cachePolicy).toExtra(),
            )
          : null,
      mapper: (dynamic json) {
        // BaseResponse.fromJson already unwraps the outer JSON and passes the 'result' map here
        return StudentProfilesModel(
          result: Result.fromJson(json as Map<String, dynamic>),
        );
      },
    );
  }
}
