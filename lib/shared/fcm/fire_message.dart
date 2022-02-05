import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sqflite/sqflite.dart';

class FireNotificationHelper {
  static Future<String?> token() => FirebaseMessaging.instance.getToken();

  Function(Map<String, dynamic>) cubitHandler;
  // String? token = await FireNotificationHelper.token() ;

  FireNotificationHelper(this.cubitHandler) {
    FirebaseMessaging.instance.subscribeToTopic("all");
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
    cubitHandler(message.data);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    cubitHandler(message.data);
  }
}

Future<void> _firebaseMessagingBackgroundCloseHandler(
    RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  String databasePath = await getDatabasesPath();
  String path = "$databasePath/${data["user"]}-drugs.db";
  bool exists = await databaseExists(path);
  if (exists) {
    Database _dataBase = await openDatabase(path);
    String type = data['type'];

    switch (type) {
      case "orderConfirmation":
        _dataBase.update("orders", {"price": data['newPrice']},
            where: "id == ${data['orderId']}");
        break;
      case "newMessage":
        _dataBase.insert("messages", data["messageData"]);
        break;
    }
  }
}
