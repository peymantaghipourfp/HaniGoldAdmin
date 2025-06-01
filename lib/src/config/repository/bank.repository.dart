

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';

import '../network/error/network.error.dart';

class BankRepository{
  Dio bankDio=Dio();

  BankRepository(){
    bankDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<List<BankModel>> getBankList()async{
    try{
      Map<String , dynamic> options={
        "options" : { "bank" :{
          "orderBy": "Bank.Name",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 10000
        }}
      };
      final response=await bankDio.post('Bank/get',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((bank)=>BankModel.fromJson(bank)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


}