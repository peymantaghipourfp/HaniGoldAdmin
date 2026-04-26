

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';

import '../../domain/remittance/model/image_guid_model.dart';
import 'dart:typed_data';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class RemittanceRepository{

  Dio remittanceDio=Dio();
  RemittanceRepository(){
    remittanceDio.options.baseUrl=BaseUrl.baseUrl;
    remittanceDio.interceptors.add(DioInterceptor());
  }
  Future<List<RemittanceModel>> getRemittanceList({required String startDate,
    required String endDate,})async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "remittance" :{
            "Predicate": startDate!=""?  [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Remittance"
                  }
                ]
              }
            ]:[],
          "orderBy": "Remittance.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 10000
        }
        }
      };
      final response=await remittanceDio.post('Remittance/get',data: options);
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((account)=>RemittanceModel.fromJson(account)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getRemittanceList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

 Future<ImageGuidModel> getImage({required String fileName,
    required String type,})async{
    try{
      Map<String , dynamic> options={
       "fileName":fileName,
       "type":type
      };
      final response=await remittanceDio.get('Attachment/downloadAttachmentGuidList',queryParameters: options);
        return ImageGuidModel.fromJson(response.data);
    }
    catch (e, s) {
      AppLogger.e('getImage failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListRemittanceModel> getRemittanceListPager({
    required int startIndex,
    required int toIndex,
    required String startDate,
    required String endDate,
    int? accountId,
    required String namePayer,
    required String nameReciept,
    String? quantity,
    String? descriptionFilter,
    int? item,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "remittance" : {
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
                  "RefTable": "Users"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Remittance"
                  },
                if(namePayer!="")
                  {
                    "fieldName": "Name",
                    "filterValue": namePayer,
                    "filterType": 0,
                    "RefTable": "AccountPayer"
                  },
                if(nameReciept!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameReciept,
                    "filterType": 0,
                    "RefTable": "AccountReciept"
                  },
                if (quantity != null && quantity.isNotEmpty)
                  {
                    "fieldName": "Quantity",
                    "filterValue": quantity,
                    "filterType": 0,
                    "RefTable": "Remittance"
                  },
                if (item != null)
                  {
                    "fieldName": "Id",
                    "filterValue": "$item",
                    "filterType": 5,
                    "RefTable": "Item"
                  }
              ],
            },
            // Description filter
            if(descriptionFilter != null && descriptionFilter.isNotEmpty)
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Name",
                    "filterValue": descriptionFilter,
                    "filterType": 0,
                    "RefTable": "AccountPayer"
                  },
                  {
                    "fieldName": "Name",
                    "filterValue": descriptionFilter,
                    "filterType": 0,
                    "RefTable": "AccountReciept"
                  },
                  {
                    "fieldName": "Quantity",
                    "filterValue": descriptionFilter,
                    "filterType": 0,
                    "RefTable": "Remittance"
                  },
                  {
                    "fieldName": "Description",
                    "filterValue": descriptionFilter,
                    "filterType": 0,
                    "RefTable": "Remittance"
                  },
                  {
                    "fieldName": "Name",
                    "filterValue": descriptionFilter,
                    "filterType": 0,
                    "RefTable": "Item"
                  },

                ]
              },
          ],
          "orderBy": "Remittance.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await remittanceDio.post('Remittance/getWrapper',data: options);
      if(response.statusCode==200){
        return ListRemittanceModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getRemittanceListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListRemittanceModel> getRemittanceListPendingPager({
    required int startIndex,
    required int toIndex,
    required String startDate,
    required String endDate,
    int? accountId,
    required String namePayer,
    required String nameReciept,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "remittance" : {
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
                    "RefTable": "Users"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Remittance"
                  },
                if(namePayer!="")
                  {
                    "fieldName": "Name",
                    "filterValue": namePayer,
                    "filterType": 0,
                    "RefTable": "AccountPayer"
                  },
                if(nameReciept!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameReciept,
                    "filterType": 0,
                    "RefTable": "AccountReciept"
                  },
                {
                  "fieldName": "Status",
                  "filterValue": "0",
                  "filterType": 5,
                  "RefTable": "Remittance"
                }
              ],
            }
          ],
          "orderBy": "Remittance.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await remittanceDio.post('Remittance/getWrapper',data: options);
      if(response.statusCode==200){
        return ListRemittanceModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getRemittanceListPendingPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Uint8List> getRemittanceExcel({
    required String startDate,
    required String endDate
  }) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "remittance" : {
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
                    "RefTable": "Remittance"
                  },
              ]
            }
          ],
          "orderBy": "Remittance.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 100000
        }
        }
      };
      final response=await remittanceDio.post(
          'Remittance/getExcel',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }catch (e, s) {
      AppLogger.e('getRemittanceExcel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<RemittanceModel> insertRemittance({
    required String date,
    required int accountIdPayer,
    required String accountNamePayer,
    required int accountIdReciept,
    required String accountNameReciept,
    required String recId,
    required int itemId,
    required int itemUnitId,
    required double quantity,
    required String? description,
  })async{
    try{
      Map<String, dynamic> orderData =
        {
          "date": date,
          "walletPayer": {
            "address": null,
            "account": {
              "name": accountNamePayer,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdPayer,
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
            "id": null,
            "infos": []
          },
          "walletReciept": {
            "address": null,
            "account": {
              "name": accountNameReciept,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdReciept,
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
            "id": null,
            "infos": []
          },
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "name": null,
              "id": itemUnitId,
              "infos": []
            },
            "name": "طلای آبشده",
            "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
            "id": itemId,
            "infos": []
          },
          "quantity": quantity,
          "status": 1,
          "isDeleted": false,
          "rowNum": 1,
          "id": 1,
          "recId": recId,
          "attribute": "cus",
          "description": description,
          "infos": []

      };

      var response=await remittanceDio.post('Remittance/insert',data: orderData);
      return RemittanceModel.fromJson(response.data);
    }
    catch (e, s) {
      AppLogger.e('insertRemittance failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<RemittanceModel> updateRemittance({
    required String date,
    required int accountIdPayer,
    required String accountNamePayer,
    required int accountIdReciept,
    required String accountNameReciept,
    required String recId,
    required int itemId,
    required int id,
    required double quantity,
    required String? description,
    required int walletPayerId,
    required int walletRecieptId,
  })async{
    try{
      Map<String, dynamic> remittanceData =
        {
          "date": date,
          "walletPayer": {
            "address": null,
            "account": {
              "name": accountNamePayer,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdPayer,
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
            "id": walletPayerId,
            "infos": []
          },
          "walletReciept": {
            "address": null,
            "account": {
              "name": accountNameReciept,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdReciept,
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
            "id": walletRecieptId,
            "infos": []
          },
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "name": null,
              "id": null,
              "infos": []
            },
            "name": "طلای آبشده",
            "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
            "id": itemId,
            "infos": []
          },
          "quantity": quantity,
          "status": 1,
          "isDeleted": false,
          "rowNum": 1,
          "id": id,
          "recId": recId,
          "attribute": "cus",
          "description": description,
          "infos": []

      };

      var response=await remittanceDio.put('Remittance/update',data: remittanceData);
      return RemittanceModel.fromJson(response.data);
    }
    catch (e, s) {
      AppLogger.e('updateRemittance failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future< RemittanceModel> updateRegistered({
    required bool registered,
    required int remittanceId,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "registered": registered,
        "id": remittanceId,
      };

      var response=await remittanceDio.put('Remittance/updateRegistered',data: remittanceData);
      return RemittanceModel.fromJson(response.data) ;
    }
    catch (e, s) {
      AppLogger.e('updateRegistered failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future< bool> deleteImage({
    required String fileName,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "fileName":fileName,
      };

      var response=await remittanceDio.delete('Attachment/Delete',queryParameters: remittanceData);
      return response.data ;
    }
    catch (e, s) {
      AppLogger.e('deleteImage failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future< RemittanceModel> getOneRemittance({
    required int id,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "id": id,
      };

      var response=await remittanceDio.get('Remittance/getOne',queryParameters: remittanceData);
      return RemittanceModel.fromJson(response.data) ;
    }
    catch (e, s) {
      AppLogger.e('getOneRemittance failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> deleteRemittance({
    required bool isDeleted,
    required int remittanceId,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "id": remittanceId,
        "isDeleted" : isDeleted,
      };


      var response=await remittanceDio.delete('Remittance/updateToIsDeleted',data: remittanceData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('deleteRemittance failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String , dynamic>> updateStatusRemittance({
    required int status,
    required int remittanceId,
    int? reasonRejectionId,
  })async{
    try{
      Map<String,dynamic> remittanceData={

        "status": status,
        if (reasonRejectionId != null) "reasonRejection":{
          "id": reasonRejectionId,
        },
        "id": remittanceId,

      };

      var response=await remittanceDio.put('Remittance/updateStatus',data: remittanceData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateStatusRemittance failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}

