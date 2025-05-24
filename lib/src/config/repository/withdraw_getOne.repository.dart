

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';

import '../network/error/network.error.dart';

class WithdrawGetOneRepository{
  Dio withdrawGetOneDio=Dio();

  WithdrawGetOneRepository(){
    withdrawGetOneDio.options.baseUrl=BaseUrl.baseUrl;
  }

Future<WithdrawModel> getOneWithdraw(int withdrawId)async{
    try {
      final response = await withdrawGetOneDio.get(
          'WithdrawRequest/getOne', queryParameters: {'id': withdrawId});
      print(response);
      Map<String, dynamic> data=response.data;
      return WithdrawModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
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
      print(depositData);

      var response=await withdrawGetOneDio.put('Deposit/updateRegistered',data: depositData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }
}