

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class BankRepository{
  Dio bankDio=Dio();

  BankRepository(){
    bankDio.options.baseUrl=BaseUrl.baseUrl;
    bankDio.interceptors.add(DioInterceptor());
  }
  Future<List<BankModel>> getBankList()async{
    try{
      Map<String , dynamic> options={
        "options" : { "bank" :{
          "orderBy": "Bank.Name",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 10000
        }}
      };
      final response=await bankDio.post('Bank/get',data: options);
      List<dynamic> data=response.data;
      return data.map((bank)=>BankModel.fromJson(bank)).toList();

    }
    catch(e,s){
      AppLogger.e('getBankList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<BankModel>> searchBankList(String name,)async{
    try{
      Map<String , dynamic> options={
        "options" : { "bank" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "Name",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "Bank"
                },
              ]
            }
          ],
          "orderBy": "Bank.Name",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 10000
        }}
      };
      final response=await bankDio.post('Bank/get',data: options);
      List<dynamic> data=response.data;
      return data.map((bank)=>BankModel.fromJson(bank)).toList();

    }
    catch(e,s){
      AppLogger.e('searchBankList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


}