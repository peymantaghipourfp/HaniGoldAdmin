

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class WithdrawGetOneRepository{
  Dio withdrawGetOneDio=Dio();

  WithdrawGetOneRepository(){
    withdrawGetOneDio.options.baseUrl=BaseUrl.baseUrl;
    withdrawGetOneDio.interceptors.add(DioInterceptor());
  }

Future<WithdrawModel> getOneWithdraw(int withdrawId)async{
    try {
      final response = await withdrawGetOneDio.get(
          'WithdrawRequest/getOne', queryParameters: {'id': withdrawId});
      Map<String, dynamic> data=response.data;
      return WithdrawModel.fromJson(data);
    }catch (e, s) {
      AppLogger.e('getOneWithdraw failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
}
  Future<List< dynamic>> updateRegistered({
    required bool registered,
    required int depositId,
  })async{
    try{
      Map<String,dynamic> depositData={
        "registered": registered,
        "id": depositId,
      };

      var response=await withdrawGetOneDio.put('Deposit/updateRegistered',data: depositData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateRegistered failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> insertFromDeposit({
    required int depositId,
  })async{
    try{

      var response=await withdrawGetOneDio.get('Remittance/insertFromDeposit',queryParameters: {"id": depositId});
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('خطا در برگشت واریزی:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> changeExteraAmount({
    required int depositId,
  })async{
    try{

      var response=await withdrawGetOneDio.put('Deposit/changeExteraAmount',queryParameters: {"id": depositId});
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('خطا در اضافه واریزی:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}