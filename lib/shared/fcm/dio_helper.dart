import 'package:dio/dio.dart';

class DioHelper {
  late Dio dio;

//                 DioHelper dioHelper = DioHelper();
//                 print(await dioHelper.postData(
//                     sendData: {"Test": "hehe"},
//                     title: "Test From Flutter",
//                     body: "Click here",
//                     receiverUId: "mmDJrD7W0EfN5iVEsGDt2uu8jik2"));

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
      'Authorization':
          'key=AAAAFDmawUc:APA91bEe5C8DtnJNVOJyrVsGNuNLNusZfRAi6Vw1C6JaECac6BrErx_vp__xVrk51qDlR7DFxaWHkfib4BgxdaYYi16_yZTmJqKIEJ-lJ7F1hrOdFsslV9UMDtV2pR4FlSqX1f3o0CEM',
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
      print(exceptionsHandle(error: err));
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
