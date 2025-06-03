


import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';

import '../../domain/remittance/model/list_withdraw.model.dart';
import '../network/error/network.error.dart';

class WithdrawRepository{
  Dio withdrawDio=Dio();

  WithdrawRepository(){
    withdrawDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<List<WithdrawModel>> getWithdrawList({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate})async{
    try{
      Map<String , dynamic> options={
        "options" : { "withdrawrequest" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if (accountId != null)
                {
                  "fieldName": "Id",
                  "filterValue": accountId.toString(),
                  "filterType": 4,
                  "RefTable": "Account"
                },
                {
                  "fieldName": "IsDeleted",
                  "filterValue": "0",
                  "filterType": 4,
                  "RefTable": "WithdrawRequest"
                },
                if(startDate!="")
                  {
                    "fieldName": "RequestDate",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "WithdrawRequest"
                  }
              ]
            }
          ],
          "orderBy": "withdrawrequest.requestDate",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await withdrawDio.post('WithdrawRequest/get',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
        List<dynamic> data=response.data;
        return data.map((withdraw)=>WithdrawModel.fromJson(withdraw)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
Future<ListWithdrawModel> getWithdrawListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
  required String name,
})async{
    try{
      Map<String , dynamic> options=
          accountId != null?
      {
          "options" : { "withdrawrequest" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
                "filters": [
                {
                  "fieldName": "Id",
                  "filterValue": accountId.toString(),
                  "filterType": 4,
                  "RefTable": "Account"
                },
              ],
            }
          ],
          "orderBy": "withdrawrequest.requestDate",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      }:startDate!=""? {
            "options" : { "withdrawrequest" : {
              "Predicate": [
                {
                  "innerCondition": 0,
                  "outerCondition": 0,
                  "filters": [
                    {
                      "fieldName": "RequestDate",
                      "filterValue": "$startDate|$endDate",
                      "filterType": 25,
                      "RefTable": "WithdrawRequest"
                    }
                  ]
                }
              ],
              "orderBy": "withdrawrequest.requestDate",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          }: name!="" ?
          {
            "options" : { "withdrawrequest" : {
              "Predicate": [
                {
                  "innerCondition": 0,
                  "outerCondition": 0,
                  "filters": [
                    {
                      "fieldName": "Name",
                      "filterValue": name,
                      "filterType": 0,
                      "RefTable": "Account"
                    },
                  ],
                }
              ],
              "orderBy": "withdrawrequest.requestDate",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          } :
          {
            "options" : { "withdrawrequest" : {
              "orderBy": "withdrawrequest.requestDate",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          };
      final response=await withdrawDio.post('WithdrawRequest/getWrapper',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
        return ListWithdrawModel.fromJson(response.data);

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
    //required int bankAccountId,
    required int bankId,
    required String bankName,
    required String ownerName,
    required double amount,
    required String number,
    required String cardNumber,
    required String sheba,
    required String? description,
    required String date,
    required int status,
})async{
    try{
      Map<String,dynamic> withdrawData={
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
        "bank": {
          "name": bankName,
          "id": bankId,
          "infos": []
        },
        "ownerName": ownerName,
        "number": number,
        "cardNumber": cardNumber,
        "sheba": sheba,
        "amount": amount,
        "undividedAmount": 100.000,
        "requestDate": date,
        "rowNum": 1,
        "id": 1,
        "status":status,
        "attribute": "cus",
        "infos": [],
        "description": description
      };
      print(withdrawData);
      
      var response=await withdrawDio.post('WithdrawRequest/insert',data: withdrawData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<Map<String , dynamic>> updateWithdraw({
    required int withdrawId,
    required int walletId,
    required int itemId,
    required String itemName,
    required int accountId,
    required String accountName,
    //required int bankAccountId,
    required int bankId,
    required String bankName,
    required String ownerName,
    required double amount,
    required String number,
    required String cardNumber,
    required String sheba,
    required String? description,
    required String date,
    required int status,
  })async{
    try{
      Map<String,dynamic> withdrawData={
        "bank": {
          "name": bankName,
          "id": bankId,
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
        "ownerName": ownerName,
        "number": number,
        "cardNumber": cardNumber,
        "sheba": sheba,
        "amount": amount,
        "undividedAmount": 100.000,
        "requestDate": date,
        "confirmDate": date,
        "rowNum": 1,
        "id": withdrawId,
        "status":status,
        "attribute": "cus",
        "infos": [],
        "description": description
      };
      print(withdrawData);

      var response=await withdrawDio.put('WithdrawRequest/update',data: withdrawData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
    }
  }


  Future<Map<String , dynamic>> updateStatusWithdraw({
    required int status,
    required int withdrawId,
    int? reasonRejectionId,
  })async{
    try{
      Map<String,dynamic> withdrawData={
        "bank": {
          "name": "",
          "icon": "",
          "id": 0,
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
        if (reasonRejectionId != null) "reasonRejection":{
      "id": reasonRejectionId,
      },
        "rowNum": 1,
        "id": withdrawId,
        "attribute": "cus",
        "infos": []
      };

      print(withdrawData);

      var response=await withdrawDio.put('WithdrawRequest/updateStatus',data: withdrawData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
    }
  }

  Future<List< dynamic>> deleteWithdraw({
    required bool isDeleted,
    required int withdrawId,
  })async{
    try{
      Map<String,dynamic> withdrawData={
        "id": withdrawId,
        "isDeleted" : isDeleted,
      };

      print(withdrawData);

      var response=await withdrawDio.delete('WithdrawRequest/updateToIsDeleted',data: withdrawData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

  Future<Map<String,dynamic>> updateRequestDateWithdraw({
    required int withdrawId,
  })async{
    try{
      Map<String,dynamic> withdrawData={
        "id": withdrawId,
      };

      print(withdrawData);

      var response=await withdrawDio.put('WithdrawRequest/updateDate',data: withdrawData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در آپدیت تاریخ:$e');
    }
  }
}