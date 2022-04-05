import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        //newsapp
        // baseUrl: 'https://newsapi.org/',
        baseUrl: 'https://fcm.googleapis.com/fcm/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postData({
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAArfBRtdM:APA91bHLHROZX6z9PrNECFlEBxJF3_ZKxuZg38Du0sB_1tNddQi5v0L0fU1dJHrEzWmSg9MfPI1awPMMTA9GyTJE-neIfQGzCen_n8j-Ze2Jtbzsl0BUMcLf9iMY31BcWuyLz7LB8whv',
    };
    return dio!.post(
      'send',
      data: data,
    );
  }
}
