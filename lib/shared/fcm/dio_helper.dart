import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const String messagingToken =
    "AAAAyMrFWo8:APA91bH8m3qp5wlwMPpWW8yoMM4S7rM_RWRIpIXuVxH1IBfLbrKeW_df5o7ElMY2NBL-890z6FsFfkHm-FFwVNt5dQEHq-VO_t9R7-kVwO0QgOYFios21boreCVWGrefV6mL9dXCJrNf";

class DioHelper {
  late Dio dio;

  DioHelper() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/',
      receiveDataWhenStatusError: true,
      connectTimeout: 50000,
      sendTimeout: 50000,
      validateStatus: (status) {
        return status! < 500;
      },
    ));
  }

  Future<Response> postData({
    String path = 'send',
    required Map<String, String> sendData,
    required String title,
    required String body,
    required String receiverUId,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$messagingToken',
    };

    Map<String, dynamic> data = {
      "data": sendData,
      "to": "/topics/$receiverUId",
      "notification": {"title": title, "body": body, "sound": "default"},
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      }
    };

    return await dio.post(path, data: data).catchError((err) {
      EasyLoading.showError(exceptionsHandle(error: err));
    });
  }

  String exceptionsHandle({required DioError error}) {
    final String message;
    switch (error.type) {
      case DioErrorType.connectTimeout:
        message = 'server not reachable';
        break;

      case DioErrorType.sendTimeout:
        message = 'send Time out';
        break;
      case DioErrorType.receiveTimeout:
        message = 'server not reachable';
        break;
      case DioErrorType.response:
        message = 'the server response, but with a incorrect status';
        break;
      case DioErrorType.cancel:
        message = 'request is cancelled';
        break;
      case DioErrorType.other:
        error.message.contains('SocketException')
            ? message = 'check your internet connection'
            : message = error.message;
        break;
    }
    return message;
  }
}
