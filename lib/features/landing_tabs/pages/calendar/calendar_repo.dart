import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:ghars_school/app_core/locator.dart';
import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/models/calendar_event_model.dart';

class CalendarRepo extends BaseRepository {
  Future<ListResult<List<CalendarEventModel>>?> getCalendarEvents({CachePolicy? cachePolicy}) async {
    return await getRequest<List<CalendarEventModel>>(
      path: 'School/GetAllCalendar',
      options: cachePolicy != null 
          ? Options(extra: globalCacheOptions.copyWith(policy: cachePolicy).toExtra()) 
          : null,
      mapper: (dynamic json) {
        if (json is Map<String, dynamic> && json.containsKey('calendar')) {
          return (json['calendar'] as List)
              .map((x) => CalendarEventModel.fromJson(x as Map<String, dynamic>))
              .toList();
        } else if (json is List) {
          return json
              .map((x) => CalendarEventModel.fromJson(x as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }
}
