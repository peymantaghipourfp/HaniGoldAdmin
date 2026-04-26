

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/tools/model/setting.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class SettingRepository{
  Dio settingDio=Dio();

  SettingRepository(){
    settingDio.options.baseUrl=BaseUrl.baseUrl;
    settingDio.interceptors.add(DioInterceptor());
  }

  Future<SettingModel> getOneSetting(int settingId)async{
    try {
      final response = await settingDio.get(
          'Setting/getOne', queryParameters: {'id': settingId});
      Map<String, dynamic> data=response.data;
      return SettingModel.fromJson(data);
    }catch (e, s) {
      AppLogger.e('getOneSetting failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateSetting({
    required int settingId,
    required bool? status,
    required bool? orderStatus,
    required String startTime,
    required String endTime,

  })async{
    try{
      Map<String, dynamic> settingData =
      {
        "status": status,
        "orderStatus": orderStatus,
        "adminStatus": true,
        "startTime": startTime,
        "endTime": endTime,
        "isOrderAvailable": true,
        "rowNum": 1,
        "id": settingId,
        "infos": []
      };
      var response=await settingDio.put('Setting/update',data: settingData );

      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateSetting failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}