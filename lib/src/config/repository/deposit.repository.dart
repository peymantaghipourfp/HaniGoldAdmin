import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';

import '../network/error/network.error.dart';

class DepositRepository{
  Dio depositDio=Dio();

  DepositRepository(){
    depositDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<List<DepositModel>> getDepositList()async{
    try{
      Map<String, dynamic> options = {
        "options" : { "deposit" :{
          "orderBy": "deposit.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 1000000
        }}
      };
      final response=await depositDio.post('Deposit/get',data: options);
      print(response);
      List<dynamic> data=response.data;
      return data.map((deposit)=>DepositModel.fromJson(deposit)).toList();
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Map<String , dynamic>> insertDeposit({
    required int walletId,
    required int? depositRequestId,
    required int? bankAccountId,
    required double? amount,
    required int accountId,
    required String accountName,
    required int bankId,
    required String bankName,
    required String ownerName,
    required String number,
    required String cardNumber,
    required String sheba,
    required String date,

  })async{
    try{
      Map<String , dynamic> depositRequestData={
        "depositRequest": {
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "infos": []
          },
          "id": depositRequestId,
          "infos": []
        },
        "walletWithdraw": {
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
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "infos": []
          },
          "infos": []
        },
        "wallet": {
          "account": {
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
            "infos": []
          },
          "id": walletId,
          "infos": []
        },
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
        "amount": amount,
        "date": date,
        "status": 0,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": "25f4521c-f9f2-461c-a72d-ba76a299d03c",
        "infos": []
      };
      var response=await depositDio.post('Deposit/insert',data: depositRequestData);
      return response.data;
    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<Map<String , dynamic>> updateStatusDeposit({
    required int status,
    required int depositId,
    int? reasonRejectionId,
  })async{
    try{
      Map<String,dynamic> depositData={
        "depositRequest": {
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "infos": []
          },
          "id": 1,
          "infos": []
        },
        "walletWithdraw": {
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
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "infos": []
          },
          "infos": []
        },
        "wallet": {
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
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "infos": []
            },
            "infos": []
          },
          "id": 1006,
          "infos": []
        },
        "bankAccount": {
          "bank": {
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
          "id": 12,
          "infos": []
        },
        "amount": 1000000.000,
        "date": "2025-03-10T18:46:52",
        "status": status,
        if (reasonRejectionId != null) "reasonRejection":{
          "id": reasonRejectionId,
        },
        "rowNum": 1,
        "id": depositId,
        "attribute": "cus",
        "recId": "25f4521c-f9f2-461c-a72d-ba76a299d03c",
        "infos": []
      };
      print(depositData);

      var response=await depositDio.put('Deposit/updateStatus',data: depositData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
    }
  }
}