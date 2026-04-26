import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';

import '../../domain/deposit/model/list_deposit.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import 'dart:typed_data';

import '../network/error_handler.dart';

class DepositRepository{
  Dio depositDio=Dio();

  DepositRepository(){
    depositDio.options.baseUrl=BaseUrl.baseUrl;
    depositDio.interceptors.add(DioInterceptor());
  }

  Future<List<DepositModel>> getDepositList({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String nameDeposit,
    required String nameRequest,
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
                  },
                if(nameDeposit!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameDeposit,
                    "filterType": 0,
                    "RefTable": "AccountDeposit"
                  },
                if(nameRequest!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameRequest,
                    "filterType": 0,
                    "RefTable": "AccountRequest"
                  },
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
      List<dynamic> data=response.data;
      return data.map((deposit)=>DepositModel.fromJson(deposit)).toList();
    }
    catch(e,s){
      AppLogger.e('getDepositList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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
    required String amount,
    required String trackingNumber,
    required bool extraAmount,
  })async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                  {
                    "fieldName": "Id",
                    "filterValue": accountId.toString(),
                    "filterType": 5,
                    "RefTable": "AccountDeposit"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Deposit"
                  },
                if(nameDeposit!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameDeposit,
                    "filterType": 0,
                    "RefTable": "AccountDeposit"
                  },
                if(nameRequest!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameRequest,
                    "filterType": 0,
                    "RefTable": "AccountRequest"
                  },
                if(amount!="")
                  {
                    "fieldName": "Amount",
                    "filterValue": amount,
                    "filterType": 0,
                    "RefTable": "Deposit"
                  },
                if(trackingNumber!="")
                  {
                    "fieldName": "TrackingNumber",
                    "filterValue": trackingNumber,
                    "filterType": 0,
                    "RefTable": "Deposit"
                  },
                if(extraAmount)
                  {
                    "fieldName": "ExtraAmount",
                    "filterValue": "0",
                    "filterType": 8,
                    "RefTable": "Deposit"
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
      };
      final response=await depositDio.post('Deposit/getWrapper',data: options);
      return ListDepositModel.fromJson(response.data);
    }
    catch(e,s){
      AppLogger.e('getDepositListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListDepositModel> getDepositListPendingPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
    required String nameDeposit,
    required String nameRequest,
    required String amount,
    required String trackingNumber,
  })async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                  {
                    "fieldName": "Id",
                    "filterValue": accountId.toString(),
                    "filterType": 5,
                    "RefTable": "AccountDeposit"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Deposit"
                  },
                if(nameDeposit!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameDeposit,
                    "filterType": 0,
                    "RefTable": "AccountDeposit"
                  },
                if(nameRequest!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameRequest,
                    "filterType": 0,
                    "RefTable": "AccountRequest"
                  },
                if(amount!="")
                  {
                    "fieldName": "Amount",
                    "filterValue": amount,
                    "filterType": 0,
                    "RefTable": "Deposit"
                  },
                if(trackingNumber!="")
                  {
                    "fieldName": "TrackingNumber",
                    "filterValue": trackingNumber,
                    "filterType": 0,
                    "RefTable": "Deposit"
                  },
                {
                  "fieldName": "Status",
                  "filterValue": "0",
                  "filterType": 5,
                  "RefTable": "Deposit"
                }
              ],
            }
          ],
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await depositDio.post('Deposit/getWrapper',data: options);
      return ListDepositModel.fromJson(response.data);
    }
    catch(e,s){
      AppLogger.e('getDepositListPendingPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<Uint8List> getDepositExcel({
    required String startDate,
    required String endDate
  }) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "deposit" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Deposit"
                  },
              ]
            }
          ],
          "orderBy": "deposit.Date",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 100000
        }
        }
      };
      final response=await depositDio.post(
          'Deposit/getExcel',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }catch(e,s){
      AppLogger.e('getDepositExcel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<DepositModel> insertDeposit({
    required int walletId,
    required int? depositRequestId,
    //required int? bankAccountId,
    required double? amount,
    required double? extraAmount,
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
    String? description,
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
        "extraAmount": extraAmount,
        "trackingNumber":trackingNumber,
        "date": date,
        "status": status,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": recId,
        "description": description,
        "infos": []
      };
      var response=await depositDio.post('Deposit/insert',data: depositData);
      return DepositModel.fromJson(response.data) ;
    }catch(e,s){
      AppLogger.e('insertDeposit failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<DepositModel> updateDeposit({
    required int depositId,
    required int walletId,
    required int? depositRequestId,
    //required int? bankAccountId,
    required double? amount,
    required double? extraAmount,
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
    String? description,

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
        "extraAmount": extraAmount,
        "trackingNumber":trackingNumber,
        "date": date,
        "status": status,
        "rowNum": 1,
        "id": depositId,
        "attribute": "cus",
        "recId": recId,
        "description": description,
        "infos": []
      };
      var response=await depositDio.put('Deposit/update',data: depositData);
      return DepositModel.fromJson(response.data) ;

    }catch(e,s){
      AppLogger.e('updateDeposit failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<DepositModel> getOneDeposit(int depositId)async{
    try {
      final response = await depositDio.get('Deposit/getOne', queryParameters: {'id': depositId});
      Map<String, dynamic> data=response.data;
      return DepositModel.fromJson(data);
    }catch(e,s){
      AppLogger.e('getOneDeposit failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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


      var response=await depositDio.delete('Deposit/updateToIsDeleted',data: depositData);
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch(e,s){
      AppLogger.e('deleteDeposit failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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

      var response=await depositDio.put('Deposit/updateStatus',data: depositData);
      return response.data;
    }
    catch(e,s){
      AppLogger.e('updateStatusDeposit failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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

      var response=await depositDio.put('Deposit/updateRegistered',data: depositData);
      return response.data;
    }
    catch(e,s){
      AppLogger.e('updateRegistered failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> sendTelegramDeposit({
    required int depositId,
      })async{
    try {
      final response = await depositDio.post('Deposit/sendTelegram', queryParameters: {'depositId': depositId});
      return response.data;
    }catch(e,s){
      AppLogger.e('sendTelegramDeposit failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}