import 'dart:developer';
import 'dart:io';

// import 'package:ghars_school/features/main_tabs/main_tabs_manager.dart';
import 'package:dio/dio.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/app_core/fcm/FcmTokenManager.dart';

class CustomInterceptor implements Interceptor {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ✅ Wait for FCM token before sending request
    final fcmToken = await locator<FcmTokenManager>().waitForFcmToken();
    locator<PrefsService>().oldFCM = fcmToken;
    log('Authorization/// ${locator<PrefsService>().userObj?.token}');
    log('FirebaseToken/// $fcmToken');
    options.headers = {
      'app': 'flutter',
      'FirebaseToken': fcmToken,
      'Platform': Platform.isAndroid ? 'android' : 'ios',
      'Accept-Language': locator<PrefsService>().appLanguage,
      'LanguageCode': locator<PrefsService>().appLanguage,
      'Authorization': locator<PrefsService>().userObj != null
          ? 'Bearer ${locator<PrefsService>().userObj?.token}'
          : 'BearerAnonymous 8UQx3014Vud4764hqdFaOg==',
      'UserID': locator<PrefsService>().userObj?.userID,
      'Accept': 'application/json',
    };

    if (options.data is FormData) {
      options.headers.remove('Content-Type');
    } else {
      options.headers['Content-Type'] = 'application/json';
    }
    log('Headers/// ${options.headers}');
    return handler.next(options);
  }

  @override
  Future onResponse(Response response, handler) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        // print(response);
        return handler.next(response);
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
          '''Error occurred while Communication with Server with StatusCode :
             ${response.statusCode}''',
        );
    }
  }

  @override
  Future onError(DioException e, handler) async {
    // Check if the error is due to a 401 Unauthorized response
    if (e.response?.statusCode == 401) {
      // locator<MainTabsManager>().resetTabIndex();
      // locator<PrefsService>().removeUserObj();
      // locator<NavigationService>().pushNamedAndRemoveUntil(
      //   AppRoutesNames.onboardingPage,
      // );
    }

    // Always pass the error along (this prevents requests from hanging)
    return handler.next(e);
  }
}
