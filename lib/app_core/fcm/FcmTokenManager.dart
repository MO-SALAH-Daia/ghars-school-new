import 'dart:developer';

import 'package:rxdart/rxdart.dart';

import '../app_core.dart';

class FcmTokenManager extends Manager {
  @override
  void dispose() {
    _fcmTokenSubject.close();
    _fcmTitleSubject.close();
    _fcmBodySubject.close();
  }

  String notificationType = 'general';
  String id = '0';

  // ✅ FCM Token
  final BehaviorSubject<String> _fcmTokenSubject =
      BehaviorSubject<String>.seeded('');
  Sink<String> get inFcm => _fcmTokenSubject.sink;
  String get currentFcmToken => _fcmTokenSubject.value;

  /// ✅ Stream that emits when token changes (or when first set)
  Stream<String> get fcmTokenStream => _fcmTokenSubject.stream;

  // ✅ Notification Title
  final BehaviorSubject<String> _fcmTitleSubject =
      BehaviorSubject<String>.seeded('');
  Sink<String> get inFcmTitle => _fcmTitleSubject.sink;
  String get currentFcmTitle => _fcmTitleSubject.value;

  // ✅ Notification Body
  final BehaviorSubject<String> _fcmBodySubject =
      BehaviorSubject<String>.seeded('');
  Sink<String> get inFcmBody => _fcmBodySubject.sink;
  String get currentFcmBody => _fcmBodySubject.value;

  // ✅ Wait for FCM token to be ready (max 5 seconds)
  Future<String> waitForFcmToken() async {
    // If token already available, return immediately
    if (currentFcmToken.isNotEmpty) {
      return currentFcmToken;
    }

    // Wait for token to arrive via onTokenRefresh
    try {
      return await fcmTokenStream
          .firstWhere((token) => token.isNotEmpty)
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      // Timeout or error — return whatever we have (may be empty)
      log('FCM Token wait timeout: $e');
      return currentFcmToken;
    }
  }
}
