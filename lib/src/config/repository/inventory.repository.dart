


import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/list_forPayment.model.dart';

import '../../domain/inventory/model/inventory.model.dart';
import '../../domain/inventory/model/list_inventory.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class InventoryRepository {
  Dio inventoryDio=Dio();
  InventoryRepository(){
    inventoryDio.options.baseUrl=BaseUrl.baseUrl;
    inventoryDio.options.connectTimeout=Duration(seconds: 20);
    inventoryDio.interceptors.add(DioInterceptor());
  }

  Future<List<InventoryModel>> getInventoryList({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate})async{
    try{
      Map<String , dynamic> options={
        "options" : { "inventory" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if (accountId != null)
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "JoinedData"
                },
                {
                  "fieldName": "IsDeleted",
                  "filterValue": "0",
                  "filterType": 4,
                  "RefTable": "JoinedData"
                },
                if(startDate!="")
                {
                  "fieldName": "Date",
                  "filterValue": "$startDate|$endDate",
                  "filterType": 25,
                  "RefTable": "JoinedData"
                }
              ]
            }
          ],
          "orderBy": "JoinedData.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await inventoryDio.post('Inventory/getWithFirstRow',data: options);
      List<dynamic> data=response.data;
      return data.map((inventory)=>InventoryModel.fromJson(inventory)).toList();

    }
    catch(e,s){
      AppLogger.e('getInventoryList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
 Future<ListInventoryModel> getInventoryListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
   required String name,
   required String receiptNumber,
   String? quantity,
   int? item,
   String? typeFilter,
 })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "inventory" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "Inventory"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Inventory"
                  },
                if(name!="")
                {
                  "fieldName": "Account_Name",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "Inventory"
                },
                if(receiptNumber!="")
                  {
                    "fieldName": "ReceiptNumber",
                    "filterValue": receiptNumber,
                    "filterType": 0,
                    "RefTable": "InventoryDetail"
                  },
                if (quantity != null && quantity.isNotEmpty)
                  {
                    "fieldName": "Quantity",
                    "filterValue": quantity,
                    "filterType": 0,
                    "RefTable": "Inventory"
                  },
                if (item != null)
                  {
                    "fieldName": "Id",
                    "filterValue": "$item",
                    "filterType": 5,
                    "RefTable": "LastItem"
                  },
                if(typeFilter != null && typeFilter.isNotEmpty && typeFilter != 'انتخاب کنید')
                  {
                    "fieldName": "Type",
                    "filterValue": typeFilter == 'دریافت' ? '0' : '1',
                    "filterType": 5,
                    "RefTable": "InventoryDetail"
                  },
              ],
            }
          ],
          "orderBy": "inventory.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await inventoryDio.post('Inventory/getWrapper',data: options);
      return ListInventoryModel.fromJson(response.data);
    }
    catch(e,s){
      AppLogger.e('getInventoryListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<Map<String, dynamic>> insertInventoryReceive({
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required List<InventoryDetailModel>? details,
    required String? recId,
      })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": date,
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
        "type": type,
        "isDeleted": false,
        "inventoryDetails":details?.map((detail)=>{
          "inventoryId": 1,
          "wallet": {
            "id":detail.wallet?.id,
          },
          "item": {
            "name": detail.item?.name,
            "id": detail.item?.id,
            "infos": []
          },
          "itemUnit": {
            "id": detail.itemUnit?.id,
            "infos": []
          },
          "laboratory":{
            "name":detail.laboratory?.name,
            "id":detail.laboratory?.id,
          },
          "stateMode": detail.stateMode,
          "quantity": detail.weight750,
          "weight":detail.quantity,
          "impurity":detail.impurity,
          "weight750":detail.weight750,
          "carat":detail.carat,
          "receiptNumber":detail.receiptNumber,
          "type": type,
          "isDeleted": false,
          "rowNum": 1,
          "id": 1,
          "attribute": "cus",
          "recId": detail.recId,
          "infos": [],
          "description": detail.description,
        }).toList(),

        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "infos": [],
      };
      var response=await inventoryDio.post('Inventory/insert',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('insertInventoryReceive failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> insertDetailInventoryReceive({
    required int id,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required String? description,
    required int walletId,
    required int itemId,
    required String itemName,
    required double quantity,
    required double impurity,
    required double weight750,
    required int carat,
    required String receiptNumber,
    required int stateMode,
    required int laboratoryId,
    required String laboratoryName,
    required String recId,
  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": date,
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
        "type": type,
        "isDeleted": false,
        "inventoryDetails": [
          {
            "inventoryId": id,
            "wallet": {
              "address": "43314b3c-2980-4563-90ae-61edc6866126",
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
              "id": walletId,
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
            "itemUnit": {
              "name": "گرم",
              "id": 1,
              "infos": []
            },
            "laboratory":{
              "name":laboratoryName,
              "id":laboratoryId,
            },
            "quantity": quantity,
            "impurity": impurity,
            "weight750": weight750,
            "carat": carat,
            "receiptNumber": receiptNumber,
            "type": type,
            "stateMode":stateMode,
            "isDeleted": false,
            "rowNum": 1,
            "attribute": "cus",
            "recId": recId,
            "infos": [],
            "description": description,
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "infos": [],
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('insertDetailInventoryReceive failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateDetailInventoryReceive({
    required int inventoryId,
    required int inventoryDetailId,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required String? description,
    required int walletId,
    required int itemId,
    required int itemUnitId,
    required String itemName,
    required double quantity,
    required double impurity,
    required double weight750,
    required double weight,
    required int carat,
    required String receiptNumber,
    required int stateMode,
    required int? laboratoryId,
    required String laboratoryName,
    required String recId,
    required String recIdParent,

  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": date,
        "inventoryId": inventoryId,
        "inputItemId": null,
        "wallet": {
          "address": "43314b3c-2980-4563-90ae-61edc6866126",
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
            "infos": []
          },
          "id": walletId,
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
        "itemUnit": {
          "id": itemUnitId,
          "infos": []
        },
        "laboratory":{
          "name":laboratoryName,
          "id":laboratoryId!=0?laboratoryId:null,
        },
        "quantity": weight750,
        "impurity": impurity,
        "weight750": weight750,
        "weight": quantity,
        "carat": carat,
        "receiptNumber": receiptNumber.isNotEmpty?receiptNumber:null,
        "type": type,
        "stateMode":stateMode,
        "id": inventoryDetailId,
        "isDeleted": false,
        "rowNum": 1,
        "attribute": "cus",
        "recId": recId,
        "recIdParent": recIdParent,
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.put('Inventory/updateDetail',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('updateDetailInventoryReceive failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
  /*Future<Map<String, dynamic>> updateDetailInventoryReceive({
    required int id,
    required int inventoryDetailId,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required String? description,
    required int walletId,
    required int itemId,
    required String itemName,
    required double quantity,
    required double impurity,
    required double weight750,
    required int carat,
    required String receiptNumber,
    required int stateMode,
    required int laboratoryId,
    required String laboratoryName,
    required String recId,
    required double weight,
    required double quantityRemainded,
    required int inputItemId,
  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "inventoryId": id,
        "inputItemId": inputItemId,
        "wallet": {
          "account": {
            "accountGroup": {
              "infos": []
            },
            "accountSubGroup": {
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
        "laboratory": {
          "name": laboratoryName,
          "id": laboratoryId != 0 ? laboratoryId : null,
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
        "itemUnit": {
          "infos": []
        },
        "quantity": quantity,
        "carat": carat,
        "weight750": weight750,
        "weight": weight,
        "quantityRemainded": quantityRemainded,
        "impurity": impurity,
        "receiptNumber": receiptNumber != '' ? receiptNumber : null,
        "type": type,
        "isDeleted": false,
        "attachments": [],
        "rowNum": 1,
        "id": inventoryDetailId,
        "attribute": "cus",
        "recId": recId,
        "infos": []
      };
      var response=await inventoryDio.put('Inventory/updateDetail',data: inventoryData);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
    }
  }

  Future<List<InventoryDetailModel>> getInventoryDetail(int inventoryId)async{
    try{
      final response=await inventoryDio.get('Inventory/getInventoryDetail',queryParameters: {"id":inventoryId});
      List<dynamic> data=response.data;
      return data.map((inventoryDetail)=>InventoryDetailModel.fromJson(inventoryDetail)).toList();
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }*/

  Future<List<InventoryDetailModel>> getInventoryDetail(int inventoryId)async{
    try{
      final response=await inventoryDio.get('Inventory/getInventoryDetail',queryParameters: {"id":inventoryId});
      List<dynamic> data=response.data;
      return data.map((inventoryDetail)=>InventoryDetailModel.fromJson(inventoryDetail)).toList();
    }catch(e,s){
      AppLogger.e('getInventoryDetail failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<List< dynamic>> deleteInventory({
    required bool isDeleted,
    required int inventoryId,
  })async{
    try{
      Map<String,dynamic> inventoryData={
        "id": inventoryId,
        "isDeleted" : isDeleted,
      };


      var response=await inventoryDio.delete('Inventory/updateToIsDeleted',data: inventoryData);
      return response.data;
    }
    catch(e,s){
      AppLogger.e('deleteInventory failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> deleteInventoryDetail({
    required int id,

  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "id": id,
      };
      var response=await inventoryDio.delete('Inventory/updateToIsDeletedDetail',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('deleteInventoryDetail failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<List<InventoryDetailModel>> getForPaymentlist({required int itemId,int? laboratoryId})async{
    try{
      Map<String , dynamic> options={
        "options" : { "inventory" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "Id",
                  "filterValue": itemId.toString(),
                  "filterType": 5,
                  "RefTable": "Item"
                },
                if (laboratoryId != null)
                {
                  "fieldName": "Id",
                  "filterValue": laboratoryId.toString(),
                  "filterType": 5,
                  "RefTable": "Laboratory"
                },
                /*{
                  "fieldName": "Carat",
                  "filterValue": "750",
                  "filterType": 4,
                  "RefTable": "InventoryDetail"
                }*/
              ]
            }
          ],
          "orderBy": "FilteredDetails.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 1000
        }}
      };
      final response=await inventoryDio.post('Inventory/getForPeyment',data: options);
      List<dynamic> data=response.data;
      return data.map((receive)=>InventoryDetailModel.fromJson(receive)).toList();

    }
    catch(e,s){
      AppLogger.e('getForPaymentlist failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListForPaymentModel> getForPaymentlistPager({
    required int startIndex,
    required int toIndex,
    required int itemId,
    //int? laboratoryId,
  })async{
    try{
      Map<String , dynamic> options=
          //laboratoryId != null ?
          {
            "options" : { "inventory" :{
              "Predicate": [
                {
                  "innerCondition": 0,
                  "outerCondition": 0,
                  "filters": [
                    //if (itemId != null)
                    {
                      "fieldName": "Id",
                      "filterValue": itemId.toString(),
                      "filterType": 5,
                      "RefTable": "Item"
                    },
                     /* {
                        "fieldName": "Id",
                        "filterValue": laboratoryId.toString(),
                        "filterType": 5,
                        "RefTable": "Laboratory"
                      },*/
                  ]
                }
              ],
              "orderBy": "FilteredDetails.quantityRemainded",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          };
          //:
          /*{
            "options" : { "inventory" :{
              "orderBy": "FilteredDetails.Quantity",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          };*/
      final response=await inventoryDio.post('Inventory/getForPeymentWrapper',data: options);
      return ListForPaymentModel.fromJson(response.data);
    }
    catch(e,s){
      AppLogger.e('getForPaymentlistPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<Map<String, dynamic>> insertInventoryPayment({
    required String date,
    required int accountId,
    required String accountName,
    required String recipient,
    required int type,
    required List<InventoryDetailModel>? details,
    required String? recId,
    required bool? confirmByAdmin,
  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": date,
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
        "type": type,
        "confirmByAdmin":confirmByAdmin,
        "isDeleted": false,
        "inventoryDetails":details?.map((detail)=>{
          "inventoryId": 1,
          "wallet": {
            "id":detail.wallet?.id,
          },
          "item": {
            "name": detail.item?.name,
            "id": detail.item?.id,
            "infos": []
          },
          "itemUnit": {
            "id": detail.itemUnit?.id,
            "infos": []
          },
          "laboratory":{
            "name":detail.laboratory?.name,
            "id":detail.laboratory?.id,
          },
          "stateMode": detail.stateMode,
          "weight": detail.quantity,
          "quantity" :detail.weight,
          "impurity":detail.impurity,
          "weight750":detail.weight750,
          "carat":detail.carat,
          "receiptNumber":detail.receiptNumber,
          "type": type,
          "inputItemId":detail.inputItemId,
          "isDeleted": false,
          "rowNum": 1,
          "id": 1,
          "attribute": "cus",
          "recId": detail.recId,
          "infos": [],
          "description": detail.description,
        }).toList(),
        "recipient":recipient,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "infos": [],
      };
      var response=await inventoryDio.post('Inventory/insert',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('insertInventoryPayment failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> insertDetailInventoryPayment({
    required int id,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required String? description,
    required int walletId,
    required int itemId,
    required String itemName,
    required double quantity,
    required double impurity,
    required double weight750,
    required int carat,
    required String receiptNumber,
    required int stateMode,
    required int? inputItemId,
    required int laboratoryId,
    required String laboratoryName,
    required String recId,

  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": date,
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
        "type": type,
        "isDeleted": false,
        "inventoryDetails": [
          {
            "inventoryId": id,
            "wallet": {
              "address": "43314b3c-2980-4563-90ae-61edc6866126",
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
              "id": walletId,
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
            "itemUnit": {
              "name": "گرم",
              "id": 1,
              "infos": []
            },
            "laboratory":{
              "name":laboratoryName,
              "id":laboratoryId,
            },
            "quantity": quantity,
            "impurity": impurity,
            "weight750": weight750,
            "carat": carat,
            "receiptNumber": receiptNumber,
            "type": type,
            "inputItemId":inputItemId,
            "stateMode":stateMode,
            "isDeleted": false,
            "rowNum": 1,
            "attribute": "cus",
            "recId": recId,
            "infos": [],
            "description": description,
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "infos": [],
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('insertDetailInventoryPayment failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateDetailInventoryPayment({
    required int inventoryId,
    required int inventoryDetailId,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required int? inputItemId,
    required String? description,
    required int walletId,
    required int itemId,
    required int itemUnitId,
    required String itemName,
    required double quantity,
    required double impurity,
    required double weight750,
    required double weight,
    required int carat,
    required String receiptNumber,
    required int stateMode,
    required int laboratoryId,
    required String laboratoryName,
    required String recId,
    required String recIdParent,

  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": date,
        "inventoryId": inventoryId,
        "inputItemId": inputItemId ?? null,
        "wallet": {
          "address": "43314b3c-2980-4563-90ae-61edc6866126",
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
            "infos": []
          },
          "id": walletId,
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
        "itemUnit": {
          "id": itemUnitId,
          "infos": []
        },
        "laboratory":{
          "name":laboratoryName,
          "id":laboratoryId!=0?laboratoryId:null,
          "infos": []
        },
        "quantity": weight750,
        "impurity": impurity,
        "weight750": weight750,
        "weight": quantity,
        "carat": carat,
        "receiptNumber": receiptNumber.isNotEmpty ? receiptNumber:null,
        "type": type,
        "stateMode":stateMode,
        "id": inventoryDetailId,
        "isDeleted": false,
        "rowNum": 1,
        "attribute": "cus",
        "recId": recId,
        "recIdParent": recIdParent,
        "infos": [],
        "description": description ?? null,
      };
      var response=await inventoryDio.put('Inventory/updateDetail',data: inventoryData);
      return response.data;

    }catch(e,s){
      AppLogger.e('updateDetailInventoryPayment failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> updateRegistered({
    required bool registered,
    required int inventoryId,
  })async{
    try{
      Map<String,dynamic> inventoryData={
        "registered": registered,
        "id": inventoryId,
      };

      var response=await inventoryDio.put('Inventory/updateRegistered',data: inventoryData);
      return response.data;
    }
    catch(e,s){
      AppLogger.e('updateRegistered failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<bool> sendVerificationCode(int accountId)async{
    try {
      final response = await inventoryDio.get(
          'Inventory/getCode', queryParameters: {'accountId': accountId});
      //Map<String, dynamic> data=response.data;
      return response.data;
    }catch(e,s){
      AppLogger.e('sendVerificationCode failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<bool> checkVerificationCode(int accountId,int code)async{
    try {
      final response = await inventoryDio.get(
          'Inventory/checkCode', queryParameters: {'accountId': accountId,'code':code});
      //Map<String, dynamic> data=response.data;
      return response.data;
    }catch(e,s){
      AppLogger.e('checkVerificationCode failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}