

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class ItemRepository{

  Dio itemDio=Dio();

  ItemRepository(){
    itemDio.options.baseUrl=BaseUrl.baseUrl;
    itemDio.interceptors.add(DioInterceptor());
  }

  Future<List<ItemModel>> getItemList({
    String? accountId,
    String? showChart,
})async{
    try{
      Map<String , dynamic> options= {
        "options" : {
          "item" :{
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 1,
                "filters": [
                  if (accountId != null && accountId.isNotEmpty)
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountId,
                    "filterType": 5,
                    "RefTable": "Account"
                  },
                  if (showChart != null && showChart.isNotEmpty)
                  {
                    "fieldName": "ShowChart",
                    "filterValue": "1",
                    "filterType": 5,
                    "RefTable": "Item"
                  }
                ]
              }
            ],
          "orderBy": "Item.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 1000
        }
        }
      };
      final response=await itemDio.post('Item/get',data: options);
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((items)=>ItemModel.fromJson(items)).toList();
      }
      else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getItemList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
  Future<ItemModel> getOneItem(int itemId)async{
    try {
      final response = await itemDio.get(
          'Item/getOne', queryParameters: {'id': itemId});
      Map<String, dynamic> data=response.data;
      return ItemModel.fromJson(data);
    }catch (e, s) {
      AppLogger.e('getOneItem failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String , dynamic>> insertPriceItem({
    required int itemId,
    required double price,
    required double differentPrice,
    required int itemUnitId,
  })async{
    try{
      Map<String, dynamic> itemData = {
        "itemId": itemId,
        "price": price,
        "differentPrice": differentPrice,
        "rowNum": 1,
        "attribute": "sys",
        "infos": [],
        "itemUnitId":itemUnitId
      };

      var response=await itemDio.post('ItemPrice/insert',data: itemData);
      return response.data;

    }catch (e, s) {
      AppLogger.e('insertPriceItem failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String , dynamic>> insertDifferentPriceItem({
    required int itemId,
    required double differentPrice,
    required double price,
    required int itemUnitId,
  })async{
    try{
      Map<String, dynamic> itemData = {
        "itemId": itemId,
        "differentPrice": differentPrice,
        "price": price,
        "rowNum": 1,
        "attribute": "sys",
        "infos": [],
        "itemUnitId":itemUnitId
      };

      var response=await itemDio.post('ItemPrice/insert',data: itemData);
      return response.data;

    }catch (e, s) {
      AppLogger.e('insertDifferentPriceItem failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ItemModel> updateStatusItem({
    required int id,
    required bool status,
    required bool? sellStatus,
    required bool? buyStatus,
  }) async {
    try {
      Map<String, dynamic> options = {
        "status": status,
        "id": id,
        "sellStatus": sellStatus,
        "buyStatus": buyStatus,
      };
      final response = await itemDio.put('Item/updateStatus', data: options);
      return ItemModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('updateStatusItem failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String , dynamic>> updateItemRange({
    required int itemId,
    required int maxSell,
    required int maxBuy,
    required double salesRange,
    required double buyRange,
  })async{
    try{
      Map<String, dynamic> itemData = {
        "maxSell": maxSell,
        "maxBuy": maxBuy,
        "salesRange": salesRange,
        "buyRange": buyRange,
        "id": itemId
      };

      var response=await itemDio.put('Item/updateRange',data: itemData);
      return response.data;

    }catch (e, s) {
      AppLogger.e('updateItemRange failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateItem({
    required int itemId,
    required String itemName,
    //required int itemGroupId,
    required String itemGroupName,
    //required int itemUnitId,
    required String itemUnitName,
    required bool? isDecimal,
    required bool? status,
    required bool? showMarket,
    required bool? sellStatus,
    required bool? buyStatus,
    required bool? hasWage,
    required double wage,
    required bool? hasCard,
    required double cardPrice,
    required double initBalance,
    required double w750,
    //int? refrenceId,

  })async{
    try{
      Map<String, dynamic> itemData =
      {
        /*"refrence": {
          "itemGroup": {
            "infos": []
          },
          "itemUnit": {
            "infos": []
          },
          "name": "",
          "id": refrenceId,
          "infos": []
        },*/
        "itemGroup": {
          "name": itemGroupName,
          //"id": itemGroupId,
          "infos": []
        },
        "itemUnit": {
          "name": itemUnitName,
          //"id": itemUnitId,
          "infos": []
        },
        "name": itemName,
        "isDefault": true,
        "isDecimal": isDecimal,
        "status": status,
        "showMarket": showMarket,
        "sellStatus": sellStatus,
        "buyStatus": buyStatus,
        "isMainCurrency": false,
        "isCurrency": false,
        "hasWage": hasWage,
        "wage": wage,
        "hasCard": hasCard,
        "cardPrice": cardPrice,
        "w750": w750,
        "initBalance": initBalance,
        "symbol": "",
        "foreColor": "",
        "backColor": "",
        "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
        "id": itemId,
        "attribute": "sys",
        "description": "",
        "recId": "0f6dbcdd-95fb-4608-a7d6-8a95bd9b7e60",
        "infos": [],
      };
      var response=await itemDio.put('Item/update',data: itemData );

      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateItem failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}