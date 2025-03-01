

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';

import '../network/error/network.error.dart';

class WithdrawRepository{
  Dio withdrawDio=Dio();

  WithdrawRepository(){
    withdrawDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<List<WithdrawModel>> getWithdrawList()async{
    try{
      Map<String , dynamic> options={
        "options" : { "withdrawrequest" :{
          "orderBy": "withdrawrequest.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 10
        }
        }
      };
      final response=await withdrawDio.post('WithdrawRequest/get',data: options);
      //print(response);
        List<dynamic> data=response.data;
        return data.map((withdraw)=>WithdrawModel.fromJson(withdraw)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
}