import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class FireNotificationHelper {
  static Future<String?> token() => FirebaseMessaging.instance.getToken();
  // String? token = await FireNotificationHelper.token() ;

  FireNotificationHelper() {
    FirebaseMessaging.onMessage
        .listen(_firebaseMessagingForegroundHandler)
        .onError((err) {
      print(err);
    });

    // app on back ground
    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler)
        .onError((err) {
      print(err);
    });

    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundCloseHandler);
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    Vibrate.vibrate();
    print("here when front ${message.data}");
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("here when back ${message.data}");
  }
}

Future<void> _firebaseMessagingBackgroundCloseHandler(
    RemoteMessage message) async {
  print("here when closing ${message.data}");
}
