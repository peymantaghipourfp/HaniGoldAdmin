

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';

import '../../domain/inventory/model/inventory.model.dart';
import '../network/error/network.error.dart';

class InventoryRepository {
  Dio inventoryDio=Dio();
  InventoryRepository(){
    inventoryDio.options.baseUrl=BaseUrl.baseUrl;
    inventoryDio.options.connectTimeout=Duration(seconds: 10);
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
                  "filterType": 4,
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
      print(response);
      List<dynamic> data=response.data;
      return data.map((inventory)=>InventoryModel.fromJson(inventory)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<Map<String, dynamic>> insertInventoryReceive({
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required String? description,
    required List<InventoryDetailModel>? details,
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
          "laboratory":{
            "name":detail.laboratory?.name,
            "id":detail.laboratory?.id,
          },
          "stateMode": detail.stateMode,
          "quantity": detail.quantity,
          "impurity":detail.impurity,
          "weight750":detail.weight750,
          "carat":detail.carat,
          "receiptNumber":detail.receiptNumber,
          "type": type,
          "isDeleted": false,
          "rowNum": 1,
          "id": 1,
          "attribute": "cus",
          "recId": null,
          "infos": []
        }).toList(),

        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.post('Inventory/insert',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
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
            "recId": null,
            "infos": []
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
    }
  }

  Future<Map<String, dynamic>> updateDetailInventoryReceive({
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
            "id": inventoryDetailId,
            "isDeleted": false,
            "rowNum": 1,
            "attribute": "cus",
            "recId": null,
            "infos": []
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
    }
  }

  Future<InventoryModel> getOneInventory(int inventoryId)async{
    try{
      final response=await inventoryDio.get('Inventory/getOne',queryParameters: {"id":inventoryId});
      print(response);
      Map<String, dynamic> data=response.data;
      return InventoryModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
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

      print(inventoryData);

      var response=await inventoryDio.delete('Inventory/updateToIsDeleted',data: inventoryData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

  Future<Map<String, dynamic>> deleteInventoryDetail({
    required int id,
    required int inventoryDetailId,
    required int accountId,
    required int itemId,
    required int walletId,
    required double quantity,
    required int stateMode,
    required int type,

  })async{
    try{
      Map<String, dynamic> inventoryData= {
        "date": "2025-04-13T18:13:00",
        "account": {
          "code": "1",
          "name": "",
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
              "address": "844B8EC4-0C39-410C-9C5C-D693842A61F7",
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
              "name": "",
              "id": itemId,
              "infos": []
            },
            "itemUnit": {
              "name": "عدد",
              "id": 2,
              "infos": []
            },
            "quantity": quantity,
            "impurity": 0.0000,
            "weight750": 0,
            "carat": 0,
            "type": type,
            "isDeleted": true,
            "rowNum": 1,
            "id": inventoryDetailId,
            "stateMode":stateMode,
            "attribute": "cus",
            "recId": null,
            "infos": []
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "recId": "5e5a084e-0b2b-438f-9ede-724d0618e19d",
        "infos": []
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
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
                  "filterType": 4,
                  "RefTable": "Item"
                },
                if (laboratoryId != null)
                {
                  "fieldName": "Id",
                  "filterValue": laboratoryId.toString(),
                  "filterType": 4,
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
      print(response);
      List<dynamic> data=response.data;
      return data.map((receive)=>InventoryDetailModel.fromJson(receive)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<Map<String, dynamic>> insertInventoryPayment({
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required String? description,
    required List<InventoryDetailModel>? details,
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
          "laboratory":{
            "name":detail.laboratory?.name,
            "id":detail.laboratory?.id,
          },
          "stateMode": detail.stateMode,
          "quantity": detail.quantity,
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
          "recId": null,
          "infos": []
        }).toList(),

        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.post('Inventory/insert',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
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
    required int inputItemId,
    required int laboratoryId,
    required String laboratoryName,

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
            "recId": null,
            "infos": []
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
    }
  }
  Future<Map<String, dynamic>> updateDetailInventoryPayment({
    required int id,
    required int inventoryDetailId,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required int inputItemId,
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
            "id": inventoryDetailId,
            "isDeleted": false,
            "rowNum": 1,
            "attribute": "cus",
            "recId": null,
            "infos": []
          }
        ],
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "infos": [],
        "description": description,
      };
      var response=await inventoryDio.put('Inventory/update',data: inventoryData);
      print(response);
      return response.data;

    }catch(e){
      throw ErrorException('خطا در آپدیت اطلاعات:$e');
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
      print(inventoryData);

      var response=await inventoryDio.put('Inventory/updateRegistered',data: inventoryData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }
}