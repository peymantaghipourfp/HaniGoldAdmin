

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/inventory/model/inventory.model.dart';
import '../network/error/network.error.dart';

class InventoryRepository {
  Dio inventoryDio=Dio();
  InventoryRepository(){
    inventoryDio.options.baseUrl=BaseUrl.baseUrl;
    inventoryDio.options.connectTimeout=Duration(seconds: 10);
  }

  Future<List<InventoryModel>> getInventoryList({required int startIndex, required int toIndex,int? accountId,})async{
    try{
      Map<String , dynamic> options={
        "options" : { "inventory" :{
          if (accountId != null)
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId.toString(),
                  "filterType": 4,
                  "RefTable": "Inventory"
                }
              ]
            }
          ],
          "orderBy": "Inventory.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await inventoryDio.post('Inventory/get',data: options);
      print(response);
      List<dynamic> data=response.data;
      return data.map((inventory)=>InventoryModel.fromJson(inventory)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Map<String, dynamic>> insertInventory({
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required int stateMode,
    required String? description,
    required List<InventoryDetail>? details,
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
          "stateMode": detail.stateMode,
          "amount": detail.amount,
          "impurity":detail.impurity,
          "weight750":detail.weight750,
          "carat":detail.carat,
          "receiptNumber":detail.receiptNumber,
          "price": 10000.0000,
          "totalPrice": 1000000.0000,
          "type": 1,
          "isDeleted": false,
          "rowNum": 1,
          "id": 1,
          "attribute": "cus",
          "recId": "0c45d651-51cd-47b9-8b9c-c559a04d4987",
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
}