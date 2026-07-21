import 'package:flutter/material.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/auth/login/login_page.dart';

class Routes {
  Routes._();

  static final Map<String, Widget Function(BuildContext)> routes =
      <String, Widget Function(BuildContext context)>{
        AppRoutesNames.loginPage: (_) => const LoginPage(),
        AppRoutesNames.loginPage: (_) => const LoginPage(),
      };
}
