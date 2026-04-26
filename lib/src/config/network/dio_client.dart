import 'package:dio/dio.dart';
import 'dio_interceptor.dart';
import '../../config/repository/url/base_url.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BaseUrl.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(DioInterceptor());

  static Dio get instance => _dio;
}
