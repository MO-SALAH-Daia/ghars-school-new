import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/features/landing_tabs/landing_tabs_widget.dart';
import 'package:ghars_school/features/onboarding/onboarding_drawer.dart';
import 'package:ghars_school/features/onboarding/onboarding_page.dart';
import 'package:ghars_school/shared/side_menu/container_page_with_drawer.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_core/app_core.dart';

const String debugImage1 =
    'https://www.redseaholidays.co.uk/Images/Header_715x240_SAH.png';
const String debugImage2 =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlSLbujhbrUlF5V0MPldybT_4S2_sGqFXs4g&s';
const String debugImage3 =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGY2ZwGLoW9O7ZMOAI7ceaZMOl5Z36pO3Scg&s';

class GharsSchool extends StatefulWidget {
  const GharsSchool({super.key});

  @override
  State<GharsSchool> createState() => _GharsSchoolState();
}

class _GharsSchoolState extends State<GharsSchool> {
  @override
  void initState() {
    super.initState();
    ////////////////////////////////////////////////////////////////////////////
    /// ! PushNotification
    /// TODO: Uncomment when used Firebase
    // locator<PushNotificationService>().initialize();
    ////////////////////////////////////////////////////////////////////////////
    /// ! LocalNotification
    /// TODO: Uncomment when used Firebase
    // locator<LocalNotificationService>().initializeLocalNotification();
    // //
    // setupInteractedMessage();
    // locator<AppLinkService>().handleDeepLinks();
    ////////////////////////////////////////////////////////////////////////////

    // استدعاء جلب عدد الإشعارات عند فتح التطبيق إذا كان المستخدم مسجلاً للدخول
    if (locator<PrefsService>().userObj != null) {
      // locator<NotificationsManager>().fetchNotificationCount();
    }

    // locator<PrefsService>().appLanguage = 'ar';
    // locator<AppLanguageManager>().changeLanguage(const Locale('ar'));

    // locator<PrefsService>().appLanguage = 'en';
    // locator<AppLanguageManager>().changeLanguage(const Locale('en'));
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguageManager langManager = Provider.of(
      context,
    )<AppLanguageManager>();
    final NavigationService navigationService = context
        .use<NavigationService>();
    final PrefsService prefs = context.use<PrefsService>();

    return StreamBuilder<Locale>(
      initialData: const Locale('en'),
      stream: langManager.locale$,
      builder: (BuildContext context, AsyncSnapshot<Locale> localeSnapshot) {
        return ScreenUtilInit(
          // designSize: const Size(375, 812),
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            color: AppStyle.bayZeroColor,
            title: 'BayZero',
            builder: (BuildContext context, Widget? widget) {
              //add this line
              // ScreenUtil.setContext(context);
              return MediaQuery(
                //Setting font does not change with system font size
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: LifeCycleAwareWidget(child: widget!),
              );
            },

            //! [6] FirebaseAnalytics.
            navigatorObservers: const <NavigatorObserver>[
              /// TODO: Uncomment when used Firebase
              // analyticsService.getAnalyticsObserver()
            ],
            navigatorKey: navigationService.navigatorKey,
            // theme: ThemeData.dark(),
            theme: ThemeData(
              useMaterial3: false,
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
              scaffoldBackgroundColor:
                  // isDarkModeOn ? Colors.black :
                  Colors.white,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.grey,
                selectionColor: Colors.grey,
                selectionHandleColor: Colors.grey,
              ),
              primarySwatch: AppStyle.appColor,
              // primarySwatch: AppStyle.appColor,
              // fontFamily: 'Bahij',
              // textTheme: GoogleFonts.playpenSansArabicTextTheme(
              textTheme: GoogleFonts.rubikTextTheme(
                // textTheme: GoogleFonts.marheyTextTheme(
                Theme.of(context).textTheme.apply(
                  bodyColor: Colors.black,
                  decorationColor: Colors.black,
                  displayColor: Colors.black,
                ),
              ),
              primaryColor: AppStyle.appColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: localeSnapshot.data,

            // List all of the app's supported locales here
            supportedLocales: const <Locale>[
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: const <LocalizationsDelegate>[
              // THIS CLASS WILL BE ADDED LATER
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            // Returns a locale which will be used by the app
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supportedLocales) {
                  if (prefs.appLanguage.isEmpty) {
                    // prefs.appLanguage = 'ar';
                    // return const Locale('ar');
                    // Check if the current_package device locale is supported
                    for (Locale supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale!.languageCode) {
                        langManager.changeLanguage(supportedLocale);
                        prefs.appLanguage = supportedLocale.languageCode;
                        return supportedLocale;
                      }
                    }
                    // If the locale of the device is not supported, use the first one
                    // from the list (English, in this case).
                    langManager.changeLanguage(supportedLocales.first);
                    prefs.appLanguage = supportedLocales.first.languageCode;

                    return supportedLocales.first;
                  } else {
                    return Locale(prefs.appLanguage);
                  }
                },

            home: locator<PrefsService>().userObj != null
                ? const ContainerPageWithDrawer(
                    mainScreen: LandingTabsWidget(),
                    menuScreen: DrawerWidget(),
                  )
                : ContainerPageWithDrawer(
                    key: ValueKey(prefs.appLanguage),
                    mainScreen: const OnboardingPage(),
                    menuScreen: const OnboardingDrawerWidget(),
                  ),

            routes: Routes.routes,
          ),
        );
      },
    );
  }
}
