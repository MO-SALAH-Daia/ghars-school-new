import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../app_core.dart';

class AppLanguageManager extends Manager {
  final BehaviorSubject<Locale> _localSubject = BehaviorSubject.seeded(
    const Locale('en'),
  );
  Stream<Locale> get locale$ => _localSubject.stream;
  Sink<Locale> get inLocale => _localSubject.sink;
  Locale get currentLocale => _localSubject.value;

  fetchLocale() async {
    var prefs = locator<PrefsService>();
    if (prefs.appLanguage.isEmpty) {
      inLocale.add(const Locale('ar'));
      return;
    }
    inLocale.add(Locale(prefs.appLanguage));
    return;
  }

  final ValueNotifier<String> _langNotifier = ValueNotifier<String>(
    locator<PrefsService>().appLanguage,
  );

  ValueNotifier<String> get langNotifier => _langNotifier;

  String get selectedLang => _langNotifier.value;

  set selectedLang(String newVal) => _langNotifier.value = newVal;

  void changeLanguage(Locale locale) async {
    var prefs = locator<PrefsService>();
    if (currentLocale == locale) {
      return;
    }
    if (locale == const Locale('ar')) {
      prefs.appLanguage = 'ar';
      inLocale.add(const Locale('ar'));
      selectedLang = 'ar';
    } else {
      prefs.appLanguage = 'en';
      inLocale.add(const Locale('en'));
      selectedLang = 'en';
    }
  }

  @override
  void dispose() {
    _localSubject.close();
  }
}
