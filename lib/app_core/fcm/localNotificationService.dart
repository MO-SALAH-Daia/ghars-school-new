// import 'dart:developer';
//
// import 'package:ghars_school/app_core/app_core.dart';
// import 'package:ghars_school/app_core/fcm/FcmTokenManager.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// ////////////////////////////////////////////////////////////////////////////////
// // LocalNotification
// ////////////////////////////////////////////////////////////////////////////////
//
// class LocalNotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   initializeLocalNotification() async {
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/notifications_icon');
//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings();
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsDarwin,
//         );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//     );
//   }
//
//   void showNotification(title, body, id) async {
//     var android = const AndroidNotificationDetails(
//       'channelId',
//       'channelName',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//       icon: '@drawable/notifications_icon',
//     );
//     var ios = const DarwinNotificationDetails();
//     var platform = NotificationDetails(android: android, iOS: ios);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       '$title',
//       '$body',
//       platform,
//       payload: '$id',
//     );
//   }
//
//   Future onSelectNotification(String? payload) async {
//     log(
//       'locator<FcmTokenManager>().notificationType  ${locator<FcmTokenManager>().notificationType}/// $payload',
//     );
//
//     if (locator<FcmTokenManager>().notificationType == 'order') {
//       // Navigation logic here
//     } else if (locator<FcmTokenManager>().notificationType == 'section') {
//       // Navigation logic here
//     } else if (locator<FcmTokenManager>().notificationType == 'category') {
//       // Navigation logic here
//     } else if (locator<FcmTokenManager>().notificationType == 'product') {
//       // Navigation logic here
//     }
//   }
//
//   onDidReceiveNotificationResponse(NotificationResponse response) async {
//     log('Notification clicked: ${response.payload}');
//   }
// }
