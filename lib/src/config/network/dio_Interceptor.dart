
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../logger/app_logger.dart';

class DioInterceptor extends Interceptor {
  final GetStorage _box = GetStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final token = _box.read('Authorization');

      if (token != null && token.toString().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      AppLogger.d(
          '➡️ REQUEST[${options.method}] => ${options.baseUrl}${options.path}');
      AppLogger.d('Headers: ${options.headers}');
      AppLogger.d('Query: ${options.queryParameters}');
      AppLogger.d('Body: ${options.data}');
    } catch (e, s) {
      AppLogger.e('onRequest error', e, s);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i(
        '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
    AppLogger.d('Response Data: ${response.data}');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}',
      err.message,
      err.stackTrace,
    );

    /// 🔐 در آینده برای refresh token:
    if (err.response?.statusCode == 401) {
      AppLogger.w('Unauthorized - token may be expired');
      // اینجا می‌توانی refresh token بزنی
    }

    handler.next(err);
  }
}
