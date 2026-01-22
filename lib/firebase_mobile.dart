import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initFirebaseMobile() async {
  // ❗ JANGAN jalankan di Windows
  if (Platform.isWindows) return;

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  await FirebaseMessaging.instance.subscribeToTopic('voting');
}
