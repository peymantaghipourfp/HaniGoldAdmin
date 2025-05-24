

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';

import '../network/error/network.error.dart';

class DepositRequestGetOneRepository{
  Dio depositRequestGetOneDio=Dio();

  DepositRequestGetOneRepository(){
    depositRequestGetOneDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<DepositRequestModel> getOneDepositRequest(int depositRequestId)async{
    try{
      final response=await depositRequestGetOneDio.get(
        'DepositRequest/getOne',queryParameters: {'id':depositRequestId}
      );
      print(response);
      Map<String, dynamic> data=response.data;
      return DepositRequestModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

}