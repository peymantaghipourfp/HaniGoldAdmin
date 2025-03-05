

import 'dart:ffi';

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
          "orderByType": "desc",
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

  Future<Map<String , dynamic>> insertWithdraw({
    required int accountId,
    required String accountName,
    required int bankAccountId,
    required int bankId,
    required String bankName,
    required String ownerName,
    required double amount,
    required String number,
    required String cardNumber,
    required String sheba,
    required String? description,
})async{
    try{
      Map<String,dynamic> withdrawData={
        "bankAccount": {
          "bank": {
            "name": bankName,
            "id": bankId,
            "infos": []
          },
          "account": {
            "accountGroup": {
              "infos": []
            },
            "accountItemGroup": {
              "infos": []
            },
            "accountPriceGroup": {
              "infos": []
            },
            "infos": []
          },
          "number": number,
          "ownerName": ownerName,
          "cardNumber": cardNumber,
          "sheba": sheba,
          "id": bankAccountId,
          "infos": []
        },
        "wallet": {
          "address": "00000000-0000-0000-0000-000000000000",
          "account": {
            "code": "1",
            "name": accountName,
            "accountGroup": {
              "infos": []
            },
            "accountItemGroup": {
              "infos": []
            },
            "accountPriceGroup": {
              "infos": []
            },
            "id": accountId,
            "infos": []
          },
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "name": "طلای آبشده",
            "id": 1,
            "infos": []
          },
          "id": 1,
          "infos": []
        },
        "amount": amount,
        "undividedAmount": 100.000,
        "requestDate": "2025-02-22T15:41:55",
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "infos": [],
        "description": description
      };
      
      var response=await withdrawDio.post('WithdrawRequest/insert',data: withdrawData);
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }


}