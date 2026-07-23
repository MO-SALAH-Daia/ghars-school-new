import 'package:flutter/material.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/auth/login/login_page.dart';
import 'package:ghars_school/features/landing_tabs/landing_tabs_widget.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_widget.dart';
import 'package:ghars_school/shared/side_menu/container_page_with_drawer.dart';
import 'package:ghars_school/features/onboarding/onboarding_page.dart';
import 'package:ghars_school/features/onboarding/onboarding_drawer.dart';

class Routes {
  Routes._();

  static final Map<String, Widget Function(BuildContext)> routes =
      <String, Widget Function(BuildContext context)>{
        AppRoutesNames.loginPage: (_) => const LoginPage(),
        AppRoutesNames.containerPageWithDrawer: (_) => const ContainerPageWithDrawer(
              mainScreen: LandingTabsWidget(),
              menuScreen: DrawerWidget(),
            ),
        AppRoutesNames.onboardingPage: (_) => const ContainerPageWithDrawer(
              mainScreen: OnboardingPage(),
              menuScreen: OnboardingDrawerWidget(),
            ),
      };
}
