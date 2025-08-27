import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = GetStorage();
    final token = box.read('Authorization');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print("readToken:::Bearer $token ");
    }

    return super.onRequest(options, handler);
  }
}