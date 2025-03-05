

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit_request.model.dart';

import '../network/error/network.error.dart';

class DepositRequestRepository{

  Dio depositRequestDio=Dio();

  DepositRequestRepository(){
    depositRequestDio.options.baseUrl=BaseUrl.baseUrl;
  }
  Future<List<DepositRequestModel>> getDepositRequest(int withdrawId)async{
    try{
      final response=await depositRequestDio.get('DepositRequest/getByWithdraw',queryParameters: {'id':withdrawId});
      //print(response);
      List<dynamic> data=response.data;
      return data.map((depositRequest)=>DepositRequestModel.fromJson(depositRequest)).toList();
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
}