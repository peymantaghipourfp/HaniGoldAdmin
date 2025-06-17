import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';

import '../../domain/deposit/model/list_deposit.model.dart';
import '../network/error/network.error.dart';

class DepositRepository{
  Dio depositDio=Dio();

  DepositRepository(){
    depositDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<List<DepositModel>> getDepositList({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate})async{
    try{
      Map<String, dynamic> options = {
        "options" : { "deposit" :{

          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if (accountId != null)
                {
                  "fieldName": "Id",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "AccountDeposit"
                },
                {
                  "fieldName": "IsDeleted",
                  "filterValue": "0",
                  "filterType": 4,
                  "RefTable": "Deposit"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Deposit"
                  }
              ]
            }
          ],
          "orderBy": "deposit.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await depositDio.post('Deposit/get',data: options);
      print("request getDepositList : $options" );
      print("response getDepositList : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((deposit)=>DepositModel.fromJson(deposit)).toList();
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

 Future<ListDepositModel> getDepositListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
   required String nameDeposit,
   required String nameRequest,
 })async{
    try{
      Map<String, dynamic> options =
      accountId != null?
      {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "Id",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "AccountDeposit"
                },
              ],
            }
          ],
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      }:startDate!=""? {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "Date",
                  "filterValue": "$startDate|$endDate",
                  "filterType": 25,
                  "RefTable": "Deposit"
                }
              ]
            }
          ],
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      }:nameDeposit!="" ?
      {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "Name",
                  "filterValue": nameDeposit,
                  "filterType": 0,
                  "RefTable": "AccountDeposit"
                },
              ],
            }
          ],
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      }:nameRequest!="" ?
      {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "Name",
                  "filterValue": nameRequest,
                  "filterType": 0,
                  "RefTable": "AccountRequest"
                },
              ],
            }
          ],
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      } :
      {
        "options" : { "deposit" : {
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await depositDio.post('Deposit/getWrapper',data: options);
      print("request getDepositListPager : $options" );
      print("response getDepositListPager : ${response.data}" );
      return ListDepositModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<DepositModel> insertDeposit({
    required int walletId,
    required int? depositRequestId,
    //required int? bankAccountId,
    required double? amount,
    required int accountId,
    //required String accountName,
    // required int bankId,
    // required String bankName,
    // required String ownerName,
    // required String number,
    // required String cardNumber,
    //required String sheba,
    required String date,
    required int status,
    required int walletWithdrawId,
    required String trackingNumber,
    required String recId,
  })async{
    try{
      Map<String , dynamic> depositData={
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
          "id":walletWithdrawId,
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
            "name": '',
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
            "name": '',
            "id": '',
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
          "number": '',
          "ownerName": '',
          "cardNumber": '',
          "sheba": '',
          "id": '',
          "infos": []
        },
        "amount": amount,
        "trackingNumber":trackingNumber,
        "date": date,
        "status": status,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": recId,
        "infos": []
      };
      var response=await depositDio.post('Deposit/insert',data: depositData);
      return DepositModel.fromJson(response.data) ;
    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<DepositModel> updateDeposit({
    required int depositId,
    required int walletId,
    required int? depositRequestId,
    //required int? bankAccountId,
    required double? amount,
    required int accountId,
    required String accountName,
    // required int bankId,
    // required String bankName,
    // required String ownerName,
    // required String number,
    // required String cardNumber,
    // required String sheba,
    required String date,
    required int status,
    required int walletWithdrawId,
    required String trackingNumber,
    required String recId,

  })async{
    try{
      Map<String , dynamic> depositData={
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
          "id":walletWithdrawId,
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
            "name": '',
            "id": '',
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
          "number": '',
          "ownerName": '',
          "cardNumber": '',
          "sheba": '',
          "id": '',
          "infos": []
        },
        "amount": amount,
        "trackingNumber":trackingNumber,
        "date": date,
        "status": status,
        "rowNum": 1,
        "id": depositId,
        "attribute": "cus",
        "recId": recId,
        "infos": []
      };
      var response=await depositDio.put('Deposit/update',data: depositData);
      return DepositModel.fromJson(response.data) ;

    }catch(e){
      throw ErrorException('خطا در ویرایش اطلاعات:$e');
    }
  }

  Future<DepositModel> getOneDeposit(int depositId)async{
    try {
      final response = await depositDio.get(
          'Deposit/getOne', queryParameters: {'id': depositId});
      print('Status Code getOneDeposit: ${response.statusCode}');
      print('Response Data getOneDeposit: ${response.data}');
      Map<String, dynamic> data=response.data;
      return DepositModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List< dynamic>> deleteDeposit({
    required bool isDeleted,
    required int depositId,
  })async{
    try{
      Map<String,dynamic> depositData={
        "id": depositId,
        "isDeleted" : isDeleted,
      };

      print(depositData);

      var response=await depositDio.delete('Deposit/updateToIsDeleted',data: depositData);
      print('Status Code deleteDeposit: ${response.statusCode}');
      print('Response Data deleteDeposit: ${response.data}');
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
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
        "recId": null,
        "infos": []
      };
      print(depositData);

      var response=await depositDio.put('Deposit/updateStatus',data: depositData);
      print('Status Code updateStatusDeposit: ${response.statusCode}');
      print('Response Data updateStatusDeposit: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
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

      var response=await depositDio.put('Deposit/updateRegistered',data: depositData);
      print('Status Code updateRegistered: ${response.statusCode}');
      print('Response Data updateRegistered: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }
}