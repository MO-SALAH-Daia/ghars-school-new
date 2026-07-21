// import 'dart:developer';
// import 'dart:io';
//
// import 'package:ghars_school/app_core/app_core.dart';
// import 'package:ghars_school/app_core/fcm/FcmTokenManager.dart';
// import 'package:ghars_school/app_core/fcm/localNotificationService.dart';
// import 'package:ghars_school/features/notifications/notifications_manager.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final prefs = locator<PrefsService>();
//
//   Future initialize() async {
//     // Request permission for iOS/Android 13+
//     NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     log('User granted permission: ${settings.authorizationStatus}');
//
//     // ✅ Try to get token immediately (may be null on first launch)
//     try {
//       final token = await _fcm.getToken();
//       if (token != null && token.isNotEmpty) {
//         log('FirebaseToken/// $token');
//         locator<FcmTokenManager>().inFcm.add(token);
//       } else {
//         log('FirebaseToken/// is null or empty on first launch');
//       }
//     } catch (e) {
//       log('FirebaseToken ERROR/// $e');
//     }
//
//     // ✅ Listen for token — fires when token is ready (fixes first-launch issue)
//     FirebaseMessaging.instance.onTokenRefresh.listen((token) {
//       log('FirebaseToken Ready/Refreshed/// $token');
//       locator<FcmTokenManager>().inFcm.add(token);
//     });
//
//     // ✅ Also try again after a short delay (fallback for first launch)
//     Future.delayed(const Duration(seconds: 3), () async {
//       try {
//         final token = await _fcm.getToken();
//         if (token != null && token.isNotEmpty) {
//           log('FirebaseToken/// (delayed) $token');
//           locator<FcmTokenManager>().inFcm.add(token);
//         }
//       } catch (e) {
//         log('FirebaseToken ERROR (delayed)/// $e');
//       }
//     });
//
//     // _fcm.subscribeToTopic('LivePrice');
//
//     // IosAr
//     // IosEn
//     // AndroidAr
//     // AndroidEn
//
//     // IosAr
//     // IosEn
//     // AndroidAr
//     // AndroidEn
//
//     if (Platform.isIOS) {
//       if (prefs.appLanguage == 'en') {
//         _fcm.unsubscribeFromTopic('IosAr');
//         _fcm.subscribeToTopic('IosEn');
//       } else {
//         _fcm.unsubscribeFromTopic('IosEn');
//         _fcm.subscribeToTopic('IosAr');
//       }
//     } else {
//       if (prefs.appLanguage == 'en') {
//         _fcm.unsubscribeFromTopic('AndroidAr');
//         _fcm.subscribeToTopic('AndroidEn');
//       } else {
//         _fcm.unsubscribeFromTopic('AndroidEn');
//         _fcm.subscribeToTopic('AndroidAr');
//       }
//     }
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
//       var notificationData = remoteMessage.data;
//       var notificationHead = remoteMessage.notification;
//
//       var title = notificationHead?.title;
//       var body = notificationHead?.body;
//       var id = notificationData['id'];
//
//       var type = notificationData['action'];
//
//       // We manually show a local notification here
//       // This is crucial if we disabled the auto-presentation in AppDelegate
//       locator<LocalNotificationService>().showNotification(
//         '$title',
//         '$body',
//         '$id',
//       );
//
//       // تحديث العداد فور استلام الإشعار في الواجهة
//       if (locator<PrefsService>().userObj != null) {
//         locator<NotificationsManager>().fetchNotificationCount();
//       }
//
//       log('notificationData##=======================##$notificationData');
//       if (type != null) {
//         locator<FcmTokenManager>().notificationType = type;
//         log(
//           '${locator<FcmTokenManager>().notificationType}=======================$type',
//         );
//       }
//
//       if (id != null) {
//         locator<FcmTokenManager>().id = id;
//       }
//     });
//
//     // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
//       if (remoteMessage.data['action'] == 'product') {
//         serializeAndNavigate(remoteMessage);
//       } else if (remoteMessage.data['action'] == 'section') {
//         serializeAndNavigate(remoteMessage);
//       } else if (remoteMessage.data['action'] == 'category') {
//         serializeAndNavigate(remoteMessage);
//       } else if (remoteMessage.data['action'] == 'order') {
//         serializeAndNavigate(remoteMessage);
//       }
//     });
//   }
// }
//
// Future<void> setupInteractedMessage() async {
//   await Future.delayed(const Duration(seconds: 3));
//   log('application launched !!!');
//
//   // Get any messages which caused the application to open from
//   // a terminated state.
//   // RemoteMessage? initialMessage =
//   await FirebaseMessaging.instance.getInitialMessage().then((
//     RemoteMessage? remoteMessage,
//   ) {
//     if (remoteMessage != null) {
//       if (remoteMessage.data['action'] == 'product') {
//         serializeAndNavigate(remoteMessage);
//       } else if (remoteMessage.data['action'] == 'section') {
//         serializeAndNavigate(remoteMessage);
//       } else if (remoteMessage.data['action'] == 'category') {
//         serializeAndNavigate(remoteMessage);
//       } else if (remoteMessage.data['action'] == 'order') {
//         serializeAndNavigate(remoteMessage);
//       }
//     }
//   });
//
//   // If the message also contains a data property with a "type" of "chat",
//   // navigate to a chat screen
// }
//
// void serializeAndNavigate(RemoteMessage message) {
//   Future.delayed(const Duration(seconds: 3));
//   if (message.data['action'] == 'product') {
//     log('${message.data['id']}');
//     // locator<NavigationService>().pushNamedTo(AppRoutesNames.productDetailsPage,
//     //     arguments: ProductDetailsArgs(
//     //       id: '${message.data['id']}}',
//     //       isFromAds: true,
//     //     ));
//   } else if (message.data['action'] == 'section') {
//     // locator<NavigationService>().pushNamedTo(
//     //   AppRoutesNames.subCategoryPage,
//     //   arguments: SubCategoryArgs(
//     //     id: '${message.data['id']}',
//     //     isFromAds: true,
//     //   ),
//     // );
//   } else if (message.data['action'] == 'category') {
//     // locator<NavigationService>().pushNamedTo(
//     //   AppRoutesNames.categoryPage,
//     //   arguments: CategoryArgs(
//     //     id: '${message.data['id']}',
//     //     isFromAds: true,
//     //   ),
//     // );
//   } else if (message.data['action'] == 'order') {
//     // locator<NavigationService>().pushNamedTo(
//     //   AppRoutesNames.orderDetailsPage,
//     //   arguments: OrderDetailsArgs(
//     //     id: '${message.data['id']}',
//     //     isFromAds: true,
//     //   ),
//     // );
//   }
// }
