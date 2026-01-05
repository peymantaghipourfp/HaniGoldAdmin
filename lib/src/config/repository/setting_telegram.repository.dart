import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../network/dio_Interceptor.dart';

class SettingTelegramRepository {
  Dio settingTelegramDio = Dio();

  SettingTelegramRepository() {
    settingTelegramDio.options.baseUrl = BaseUrl.baseUrl;
    settingTelegramDio.interceptors.add(DioInterceptor());
  }

  Future<bool> getStatusTelegram() async {
    try {
      final response = await settingTelegramDio.get('Telegram/status');
      print('Status Code getStatusTelegram: ${response.statusCode}');
      print('Response Data getStatusTelegram: ${response.data}');

      final data = response.data;

      // Parse response to extract boolean status
      if (data is bool) {
        return data;
      } else if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is bool) {
          return first;
        } else if (first is Map) {
          // Check common keys for status
          if (first.containsKey('isConnected')) {
            return first['isConnected'] == true;
          } else if (first.containsKey('status')) {
            return first['status'] == true;
          } else if (first.containsKey('connected')) {
            return first['connected'] == true;
          }
        }
      } else if (data is Map) {
        if (data.containsKey('isConnected')) {
          return data['isConnected'] == true;
        } else if (data.containsKey('status')) {
          return data['status'] == true;
        } else if (data.containsKey('connected')) {
          return data['connected'] == true;
        }
      }

      // Default to false if unable to parse
      return false;
    } catch (e) {
      print('Error in getStatusTelegram: $e');
      return false;
    }
  }

  Future<String> getSubmitTelegram(int code) async {
    // Validate input parameter
    if (code <= 0) {
      return 'کد نامعتبر است';
    }

    try {
      final response = await settingTelegramDio.get(
        'telegram/login/submit',
        queryParameters: {'code': code},
      );
      print('Status Code getSubmitTelegram: ${response.statusCode}');
      print('Response Data getSubmitTelegram: ${response.data}');

      final data = response.data;

      // Extract message from response
      return _extractMessage(data, 'تأیید با موفقیت انجام شد');
    } catch (e) {
      print('Error in getSubmitTelegram: $e');
      return 'خطا در تأیید کد';
    }
  }

  Future<String> startSendCodeTelegram() async {
    try {
      final response = await settingTelegramDio.post('telegram/login/start');
      print('Status Code startSendCodeTelegram: ${response.statusCode}');
      print('Response Data startSendCodeTelegram: ${response.data}');

      final data = response.data;

      // Extract message from response
      return _extractMessage(data, 'کد ارسال شد');
    } catch (e) {
      print('Error in startSendCodeTelegram: $e');
      return 'خطا در ارسال کد';
    }
  }

  /// Helper method to extract message string from API response.
  /// Returns [defaultMessage] if no message found in response.
  String _extractMessage(dynamic data, String defaultMessage) {
    if (data is String) {
      return data;
    } else if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is String) {
        return first;
      } else if (first is Map) {
        // Check common keys for message
        if (first.containsKey('message')) {
          return first['message'].toString();
        } else if (first.containsKey('msg')) {
          return first['msg'].toString();
        } else if (first.containsKey('description')) {
          return first['description'].toString();
        } else if (first.containsKey('text')) {
          return first['text'].toString();
        }
      }
    } else if (data is Map) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      } else if (data.containsKey('msg')) {
        return data['msg'].toString();
      } else if (data.containsKey('description')) {
        return data['description'].toString();
      } else if (data.containsKey('text')) {
        return data['text'].toString();
      }
    }

    return defaultMessage;
  }
}
