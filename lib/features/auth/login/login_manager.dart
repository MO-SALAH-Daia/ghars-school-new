import 'dart:io';

import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/app_core/domain/user.dart';
import 'package:ghars_school/app_core/fcm/FcmTokenManager.dart';
import 'package:ghars_school/features/auth/login/login_repo.dart';
import 'package:ghars_school/features/auth/login/login_request.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginResult {
  final ManagerState state;
  final bool isEmployeeSelectionRequired;
  final User? user;

  LoginResult({
    required this.state,
    this.isEmployeeSelectionRequired = false,
    this.user,
  });
}

class LoginManager extends Manager {
  final LoginRepo _repo = LoginRepo();
  final PrefsService _prefs = locator<PrefsService>();
  String? errorDescription;

  final BehaviorSubject<ManagerState> _stateSubject =
      BehaviorSubject<ManagerState>.seeded(ManagerState.idle);

  Stream<ManagerState> get state$ => _stateSubject.stream;

  Sink<ManagerState> get inState => _stateSubject.sink;

  Future<LoginResult> login({required LoginRequest request}) async {
    inState.add(ManagerState.loading);
    try {
      // Get the firebase token if available
      final fcmToken = await locator<FcmTokenManager>().waitForFcmToken();
      request.FireBaseToken = fcmToken;

      final response = await _repo.login(request: request);
      final user = response?.data;
      if (user != null) {
        user.token = response?.token;
      }

      // If user is a dual Parent/Employee and did not choose role yet, prompt UI selection
      if (user?.isEmployee == true && request.loginAsEmp == false) {
        inState.add(ManagerState.idle);
        return LoginResult(
          state: ManagerState.success,
          isEmployeeSelectionRequired: true,
          user: user,
        );
      }

      // If normal parent or already chose role, save session
      if (user != null) {
        saveUserSession(user, request.username ?? '', request.password ?? '');
      }

      inState.add(ManagerState.success);
      return LoginResult(state: ManagerState.success, user: user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        errorDescription = _prefs.appLanguage == 'en'
            ? 'Username or password is not correct'
            : 'اسم المستخدم أو كلمة المرور غير صحيحة';
        inState.add(ManagerState.error);
        return LoginResult(state: ManagerState.error);
      }

      if (e.error is SocketException) {
        errorDescription = _prefs.appLanguage == 'en'
            ? 'No Internet Connection'
            : 'لا يوجد إتصال بالشبكة';
        inState.add(ManagerState.socketError);
        return LoginResult(state: ManagerState.socketError);
      } else {
        if (e.error is String) {
          errorDescription = e.error as String;
        } else {
          final dynamic responseData = e.response?.data;
          if (responseData != null &&
              responseData is Map &&
              responseData['message'] != null) {
            errorDescription = responseData['message'];
          } else {
            errorDescription = _prefs.appLanguage == 'en'
                ? 'Unexpected error occurred'
                : 'حدث خطأ غير متوقع';
          }
        }
        inState.add(ManagerState.error);
        return LoginResult(state: ManagerState.error);
      }
    } catch (e) {
      errorDescription = e.toString();
      inState.add(ManagerState.error);
      return LoginResult(state: ManagerState.error);
    }
  }

  void saveUserSession(User user, String username, String password) {
    _prefs.userObj = user;
    if (user.token != null) {
      _prefs.auth = user.token!;
    }
    // Save credentials for didChangeDependencies auto-fill or storage
    // using the keys from the old project for compatibility
    _preferencesInstance().then((prefs) {
      prefs.setString('use_account', username);
      prefs.setString('use_password', password);
    });
  }

  Future<SharedPreferences> _preferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}
