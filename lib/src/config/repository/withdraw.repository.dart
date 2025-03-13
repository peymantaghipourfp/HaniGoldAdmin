

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
      print(response);
        List<dynamic> data=response.data;
        return data.map((withdraw)=>WithdrawModel.fromJson(withdraw)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Map<String , dynamic>> insertWithdraw({
    required int walletId,
    required int itemId,
    required String itemName,
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
    required String date,
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
            "name": itemName,
            "id": itemId,
            "infos": []
          },
          "id": walletId,
          "infos": []
        },
        "amount": amount,
        "undividedAmount": 100.000,
        "requestDate": date,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "infos": [],
        "description": description
      };
      print(withdrawData);
      
      var response=await withdrawDio.post('WithdrawRequest/insert',data: withdrawData);
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<Map<String , dynamic>> updateStatusWithdraw({
    required int status,
    required int withdrawId,
  })async{
    try{
      Map<String,dynamic> withdrawData={
        "bankAccount": {
          "bank": {
            "name": "بانک رسالت",
            "icon": "b30a774a-a9ae-4919-975a-c359fa47ac64",
            "id": 1,
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
          "number": "1111111",
          "ownerName": "رضا",
          "cardNumber": "100",
          "sheba": "999999999",
          "id": 4,
          "infos": []
        },
        "wallet": {
          "address": "6f95c785-db25-456d-9fa0-d5807d35dfa0",
          "account": {
            "code": "1",
            "name": "پدیده ارتباطات",
            "accountGroup": {
              "infos": []
            },
            "accountItemGroup": {
              "infos": []
            },
            "accountPriceGroup": {
              "infos": []
            },
            "id": 1,
            "infos": []
          },
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "name": "وجه نقد",
            "id": 6,
            "infos": []
          },
          "id": 1005,
          "infos": []
        },
        "amount": 2000000.000,
        "dividedAmount": 0.000,
        "notConfirmedAmount": 0.000,
        "undividedAmount": 2000000.000,
        "requestDate": "2025-03-10T12:48:23",
        "status": status,
        "rowNum": 1,
        "id": withdrawId,
        "attribute": "cus",
        "infos": []
      };
      print(withdrawData);

      var response=await withdrawDio.put('WithdrawRequest/updateStatus',data: withdrawData);
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
    }
  }


}