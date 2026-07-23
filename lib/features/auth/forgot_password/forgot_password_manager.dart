import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/auth/forgot_password/forgot_password_repo.dart';
import 'package:ghars_school/features/auth/forgot_password/forgot_password_request.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordManager extends Manager {
  final ForgotPasswordRepo _repo = ForgotPasswordRepo();
  final PrefsService _prefs = locator<PrefsService>();
  String? errorDescription;

  final BehaviorSubject<ManagerState> _stateSubject =
      BehaviorSubject<ManagerState>.seeded(ManagerState.idle);

  Stream<ManagerState> get state$ => _stateSubject.stream;

  Sink<ManagerState> get inState => _stateSubject.sink;

  Future<bool> forgotPassword({required ForgotPasswordRequest request}) async {
    inState.add(ManagerState.loading);
    try {
      final response = await _repo.forgotPassword(request: request);
      inState.add(ManagerState.success);
      return response?.data ?? true;
    } on DioException catch (e) {
      if (e.error is SocketException) {
        errorDescription = _prefs.appLanguage == 'en'
            ? 'No Internet Connection'
            : 'لا يوجد إتصال بالشبكة';
        inState.add(ManagerState.socketError);
        return false;
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
        return false;
      }
    } catch (e) {
      errorDescription = e.toString();
      inState.add(ManagerState.error);
      return false;
    }
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}
