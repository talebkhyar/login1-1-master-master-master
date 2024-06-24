import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:login1/pages/notif.dart';
import 'package:login1/main.dart';

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;
 // var navigatorKey;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');
    handleBacknotif();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    var navigatorKey;
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message
    );
  }

  Future handleBacknotif() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
