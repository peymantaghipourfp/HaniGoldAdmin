import 'package:dio/dio.dart';

class ErrorException implements Exception{
  final String message;
  final int? statusCode;

  ErrorException(this.message, {this.statusCode});

  @override
  String toString() {
    return "ErrorException :$message (statusCode: $statusCode)";
  }

  static String handleError(dynamic error){
    if(error is DioException){
      switch(error.type){
        case DioExceptionType.connectionTimeout:
          return "پایان زمان اتصال";
        case DioExceptionType.sendTimeout:
          return "پایان زمان ارسال";
        case DioExceptionType.receiveTimeout:
          return "پایان زمان دریافت";
        case DioExceptionType.badResponse:
          return"Server Error : ${error.response?.statusCode ?? "خطای ناشناخته"}";
        case DioExceptionType.cancel:
          return "درخواست لغو شد";
        case DioExceptionType.unknown:
          return "خطای غیر منتظره";
        default:
          return "مشکلی پیش آمده است";
      }
    }else{
      return "خطای غیر منتظره";
    }
  }
}