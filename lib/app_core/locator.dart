import 'package:get_it/get_it.dart';
import 'package:ghars_school/app_core/fcm/FcmTokenManager.dart';
import 'package:ghars_school/app_core/services/media_service/media_Service.dart';
import 'package:ghars_school/features/landing_tabs/landing_tabs_manager.dart';
import 'package:ghars_school/features/auth/login/login_manager.dart';
import 'package:ghars_school/features/auth/forgot_password/forgot_password_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_manager.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';

import 'app_core.dart';

final GetIt locator =
    GetIt.instance; // Re-declaring to satisfy context, though it's global

Future<void> setupLocator() async {
  // Setup PrefsService.
  var instance = await PrefsService.getInstance();
  locator.registerSingleton<PrefsService>(instance!);

  /// AppLanguageManager
  locator.registerLazySingleton<AppLanguageManager>(() => AppLanguageManager());

  /// NavigationService
  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  /// ToastTemplate
  locator.registerLazySingleton<ToastTemplate>(() => ToastTemplate());

  /// ApiService
  // locator.registerLazySingleton<ApiService>(() => ApiService());

  // FcmTokenManager
  locator.registerLazySingleton<FcmTokenManager>(() => FcmTokenManager());

  /// TODO: PushNotificationService
  // locator.registerLazySingleton<PushNotificationService>(
  //   () => PushNotificationService(),
  // );
  //
  /// TODO: LocalNotificationService
  // locator.registerLazySingleton<LocalNotificationService>(
  //   () => LocalNotificationService(),
  // );

  /// MediaService
  locator.registerLazySingleton<MediaService>(() => MediaService());

  /// LandingTabsManager
  locator.registerLazySingleton<LandingTabsManager>(() => LandingTabsManager());

  /// LoginManager
  locator.registerLazySingleton<LoginManager>(() => LoginManager());

  /// ForgotPasswordManager
  locator.registerLazySingleton<ForgotPasswordManager>(
    () => ForgotPasswordManager(),
  );

  /// HomeManager
  locator.registerLazySingleton<HomeManager>(() => HomeManager());

  /// ZoomDrawerController
  locator.registerLazySingleton<ZoomDrawerController>(
    () => ZoomDrawerController(),
  );
}
