import 'package:dio/dio.dart';

class ErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'اتصال به سرور زمان‌بر شد';
        case DioExceptionType.sendTimeout:
          return 'ارسال درخواست زمان‌بر شد';
        case DioExceptionType.receiveTimeout:
          return 'دریافت پاسخ زمان‌بر شد';
        case DioExceptionType.badResponse:
          return 'خطا در دریافت اطلاعات از سرور';
        case DioExceptionType.cancel:
          return 'درخواست لغو شد';
        case DioExceptionType.connectionError:
          return 'عدم اتصال به اینترنت';
        default:
          return 'خطای ناشناخته شبکه';
      }
    }
    return 'خطای غیرمنتظره رخ داد';
  }
}
