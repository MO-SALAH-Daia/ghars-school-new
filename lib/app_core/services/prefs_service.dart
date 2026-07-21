// import 'dart:convert';

import 'dart:convert';

import 'package:ghars_school/app_core/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static PrefsService? _instance;
  static SharedPreferences? _preferences;

  /// Keys
  static const String appLanguageKey = 'language_code';
  static const String user = 'user';
  static const String isLanguageSelectedKey = 'isLanguageSelectedKey';
  static const String onboardingSeen = 'onboardingSeen';
  static const String notificationStatus = 'notificationStatus';
  static const String authorization = 'authorization';
  static const String cartCount = 'cartCount';
  static const String fcm = 'fcm';

  // static const String token = 'Token';

  static Future<PrefsService?> getInstance() async {
    _instance ??= PrefsService();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  dynamic _getFromPrefs(String key) {
    var value = _preferences!.get(key);
    // print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  // updated _saveToDisk function that handles all types
  void _saveToPrefs<T>(String key, T content) {
    // print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences!.setString(key, content);
    } else if (content is bool) {
      _preferences!.setBool(key, content);
    } else if (content is int) {
      _preferences!.setInt(key, content);
    } else if (content is double) {
      _preferences!.setDouble(key, content);
    } else if (content is List<String>) {
      _preferences!.setStringList(key, content);
    }
  }

  // remove from Prefs
  void _removeFromPrefs(String key) {
    _preferences!.remove(key);
  }

  // clear all Prefs
  void clearAllPrefs() {
    _preferences!.clear();
  }

  // getter for App language.
  String get appLanguage => _getFromPrefs(appLanguageKey) ?? '';

  // setter for App language.
  set appLanguage(String value) => _saveToPrefs(appLanguageKey, value);

  // getter for oldFCM.
  String get oldFCM => _getFromPrefs(fcm) ?? '';

  // setter for oldFCM.
  set oldFCM(String value) => _saveToPrefs(fcm, value);

  bool get isOnboardingSeen => _getFromPrefs(onboardingSeen) ?? false;
  set isOnboardingSeen(bool value) => _saveToPrefs(onboardingSeen, value);

  // bool get isLangSeen => _getFromPrefs(langSeen) ?? false;
  // set isLangSeen(bool value) => _saveToPrefs(langSeen, value);

  int get bagCount => _getFromPrefs(cartCount) ?? 0;
  set bagCount(int value) => _saveToPrefs(cartCount, value);

  bool get isNotificationOn => _getFromPrefs(notificationStatus) ?? true;
  set isNotificationOn(bool value) => _saveToPrefs(notificationStatus, value);

  String get auth => _getFromPrefs(authorization) ?? '';
  set auth(String value) => _saveToPrefs(authorization, value);

  /////////////////////////////////////////////////////////////////////////////////
  bool get isLanguageSelected => _getFromPrefs(isLanguageSelectedKey) ?? false;
  set isLanguageSelected(bool value) =>
      _saveToPrefs(isLanguageSelectedKey, value);

  /////////////////////////////////////////////////////////////////////////////////

  // getter for USER_OBJECT.
  User? get userObj {
    var userJson = _getFromPrefs(user);
    if (userJson == null || userJson is! String) {
      return null;
    }

    final decoded = json.decode(userJson);
    if (decoded == null || decoded is! Map<String, dynamic>) {
      return null;
    }

    return User.fromJson(decoded);
  }

  // setter for USER_OBJECT.
  set userObj(User? userToSave) {
    if (userToSave == null) {
      _removeFromPrefs(user);
    } else {
      _saveToPrefs(user, json.encode(userToSave.toJson()));
    }
  }

  // // Remove UserObj
  removeUserObj() => _removeFromPrefs(user);
  /////////////////////////////////////////////////////////////////////////////////

  // getter for token
  //   String get authToken => _getFromPrefs(token) ?? '';
  // setter for token
  // set authToken(String value) => _saveToPrefs(token, value);
}
