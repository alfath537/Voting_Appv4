import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint('FCM disabled on this platform');
      return;
    }

    // Permission (Android 13+ & iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get token
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // Token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
    });

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM Foreground: ${message.notification?.title}');
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Opened via notification');
    });
  }
}
