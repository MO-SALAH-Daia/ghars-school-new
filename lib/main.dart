import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghars_school/app_core/app_core.dart';

import 'app.dart';

// const String fixedImageUrl =
//     'https://s3-alpha-sig.figma.com/img/60a0/bc43/53100fc660aa4fc943f06ed905cd7803?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=L1b6GQ1DOLyglcIV6huMrqDbJ~tRF~LB1x7hbC9n6402Z7dIMHe1sduuwWZBORycjLu1gMCYfhl8HVyKy53pIeAet4RSQBp9mtpk3RDNgVQSEd-4XhbahmGIuw1dMFfd8E8b7S6Nc0dx7n3X-yarescqvdUys4~Y18ftnDYwWXDoaQMjlDT-S8dXagtJ6lOGyHyFhARLPFzqbIhEsbYZaVo0OFQj7qTH5AiCQDNbZq8UNC9XxtgY8ppNo5TcEcYjotGVsoghsF9GXltoXBxa8uRfJV8mqCZ5RbungQaxEk6hRySkBZwrkE-0AHitJa5Cu-pLnW412KJeIoaGHDX-cg__';

/// TODO: Uncomment when used Firebase

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// TODO: Uncomment when used Firebase

      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      //
      // FirebaseMessaging.onBackgroundMessage(
      //   _firebaseMessagingBackgroundHandler,
      // );

      try {
        await setupLocator().then(
          (_) async {
            final AppLanguageManager appLanguage =
                locator<AppLanguageManager>();
            await appLanguage.fetchLocale();

            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                // status bar color
                // statusBarColor: AppStyle.mawedColor,
                statusBarColor: Colors.transparent,
                //status bar brightness
                statusBarBrightness: Brightness.light,
                //status barIcon Brightness
                statusBarIconBrightness: Brightness.light,
                // navigation bar color
                systemNavigationBarColor: Colors.white,
                //navigation bar icon
                systemNavigationBarIconBrightness: Brightness.light,
                // systemNavigationBarDividerColor: ,
              ),
            );
            // await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
            await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

            runApp(Root(locator: locator, child: const GharsSchool()));
          },
          //! [3] Crashlytics.
          /// TODO: Uncomment when used Firebase
          // onError: (error, stackTrace) =>
          //     FirebaseCrashlytics.instance.recordError(error, stackTrace),
        );
      } catch (error) {
        log("error $error");
      }
    },
    (error, stackTrace) {
      log('runZonedGuarded: Caught error in my root zone. \n$error');
      log('runZonedGuarded: Caught error in my root zone. \n$stackTrace');

      /// TODO: Uncomment when used Firebase
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

/// 287111502210
/// 123
