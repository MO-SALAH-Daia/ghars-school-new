import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/app_core/fcm/FcmTokenManager.dart';
import 'package:ghars_school/features/landing_tabs/landing_tabs_manager.dart';

class CustomInterceptor implements Interceptor {
  bool _isTokenExpired(String? token) {
    if (token == null || token.isEmpty) return false; // Handle anonymous correctly
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);

      if (payloadMap is! Map<String, dynamic>) return true;

      final exp = payloadMap['exp'];
      if (exp == null) return true;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      log('Error decoding JWT token: $e');
      return true; // Treat as expired if we can't parse it
    }
  }

  void _handleSessionExpiration(RequestOptions? options) {
    locator<LandingTabsManager>().resetTabIndex();
    locator<PrefsService>().removeUserObj();
    locator<NavigationService>().pushNamedAndRemoveUntil(
      AppRoutesNames.onboardingPage,
    );
  }

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final userToken = locator<PrefsService>().userObj?.token;
    
    // Proactive JWT Expiration Check
    if (userToken != null && _isTokenExpired(userToken)) {
      log('Token is proactively detected as expired!');
      _handleSessionExpiration(options);
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Session Expired',
          type: DioExceptionType.cancel,
        ),
      );
    }

    // ✅ Wait for FCM token before sending request
    final fcmToken = await locator<FcmTokenManager>().waitForFcmToken();
    locator<PrefsService>().oldFCM = fcmToken;
    log('Authorization/// $userToken');
    log('FirebaseToken/// $fcmToken');
    
    options.headers = {
      'app': 'flutter',
      'Platform': Platform.isAndroid ? 'android' : 'ios',
      'Accept-Language': locator<PrefsService>().appLanguage,
      'LanguageCode': locator<PrefsService>().appLanguage,
      'Authorization': locator<PrefsService>().userObj != null
          ? 'Bearer $userToken'
          : 'BearerAnonymous 8UQx3014Vud4764hqdFaOg==',
      'UserID': locator<PrefsService>().userObj?.userID,
      'Accept': 'application/json',
    };

    if (fcmToken.isNotEmpty && fcmToken != "dummy_token") {
      options.headers['FirebaseToken'] = fcmToken;
    }

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
      case 304:
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
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      _handleSessionExpiration(e.requestOptions);
    }

    // Always pass the error along (this prevents requests from hanging)
    return handler.next(e);
  }
}
