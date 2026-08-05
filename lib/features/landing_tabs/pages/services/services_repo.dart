import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:ghars_school/app_core/locator.dart';
import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/models/inv_group_stage_model.dart';

class ServicesRepo extends BaseRepository {
  Future<ListResult<List<INVGroupStageModel>>?> getInvGroupStages({
    CachePolicy? cachePolicy,
  }) async {
    return await getRequest<List<INVGroupStageModel>>(
      path: 'Inventory/ListINVGroupWeb',
      options: cachePolicy != null
          ? Options(
              extra: globalCacheOptions.copyWith(policy: cachePolicy).toExtra(),
            )
          : null,
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('groupDtos')) {
          return (json['groupDtos'] as List)
              .map(
                (x) => INVGroupStageModel.fromJson(x as Map<String, dynamic>),
              )
              .toList();
        } else if (json is List) {
          return json
              .map(
                (x) => INVGroupStageModel.fromJson(x as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      },
    );
  }
}
