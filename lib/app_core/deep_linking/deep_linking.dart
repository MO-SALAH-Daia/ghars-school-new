// import 'dart:async';
//
// // Note: You must add the app_links package to your pubspec.yaml
// import 'package:app_links/app_links.dart';
// import 'package:awj/app_core/app_core.dart';
// import 'package:awj/features/auth/reset_password/reset_password_page.dart';
// import 'package:flutter/foundation.dart';
//
// class DeepLinkService {
//   final _appLinks = AppLinks();
//
//   // Stream to deliver deep link Uri updates to any listener in the app
//   // All link types (terminated, background, foreground) flow through here.
//   final _uriController = StreamController<Uri>();
//   Stream<Uri> get uriStream => _uriController.stream;
//
//   void clear() {
//     _uriController.sink.add(Uri.parse(''));
//   }
//
//   // Singleton setup
//   DeepLinkService._();
//   static final DeepLinkService _instance = DeepLinkService._();
//   static DeepLinkService get instance => _instance;
//
//   Future<void> init() async {
//     // 1. Handle links received while the app is running (foreground/background/app in use)
//     // This stream constantly listens for new links while the app is alive.
//     _appLinks.uriLinkStream.listen(
//       (Uri? uri) async {
//         if (uri != null) {
//           debugPrint('Deep Link received (Foreground/Background): $uri');
//           // Pushes the link to the single stream for consistent handling
//           _uriController.add(uri);
//
//           await Future.delayed(const Duration(milliseconds: 500), () {
//             clear();
//           });
//         }
//       },
//       onError: (err) {
//         debugPrint('Deep Link Stream Error: $err');
//       },
//     );
//
//     // 2. Handle initial link used to launch the app (app terminated)
//     // This must be awaited before the UI loads to catch the first link.
//     final initialUri = await _appLinks.getInitialLink();
//     if (initialUri != null) {
//       debugPrint('Initial Deep Link received (Terminated): $initialUri');
//       // Pushes the initial link to the single stream
//       _uriController.add(initialUri);
//
//       await Future.delayed(const Duration(milliseconds: 500), () {
//         clear();
//       });
//     }
//   }
//
//   // Parses the URI to extract data for routing
//   Map<String, dynamic>? parseLink(Uri uri) {
//     if (uri.pathSegments.isNotEmpty) {
//       if (uri.pathSegments.last == 'reset-password') {
//         return {
//           'page': 'resetPasswordPage',
//           'email': uri.queryParameters['email'],
//           'token': uri.queryParameters['token'],
//         };
//       }
//     }
//
//     return null;
//   }
//
//   void handleDeepLink({required bool mounted}) {
//     if (!mounted) {
//       return;
//     }
//     uriStream.listen((uri) async {
//       // The link is processed here, regardless of its source (Terminated, Bg, Fg)
//       final data = parseLink(uri);
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       // Example: Navigate to the reset password page if 'page' is 'reset-password'
//       if (data?['page'] == 'resetPasswordPage') {
//         final email = data?['email'];
//         final token = data?['token'];
//         debugPrint(
//           'Navigating to Reset Password for: $email with token: $token',
//         );
//         locator<NavigationService>().pushNamedTo(
//           AppRoutesNames.resetPasswordPage,
//           arguments: ResetPasswordArgs(email: email!, token: token!),
//         );
//       }
//       await Future.delayed(const Duration(milliseconds: 500), () {
//         clear();
//       });
//     });
//   }
//
//   void dispose() {
//     _uriController.close();
//   }
// }
