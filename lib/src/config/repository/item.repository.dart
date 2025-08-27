

import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';

import '../network/dio_Interceptor.dart';

class ItemRepository{

  Dio itemDio=Dio();

  ItemRepository(){
    itemDio.options.baseUrl=BaseUrl.baseUrl;
    itemDio.interceptors.add(DioInterceptor());
  }
  Future<List<ItemModel>> getItemList()async{
    try{
      Map<String , dynamic> options= {
        "options" : {
          "item" :{
          "orderBy": "Item.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 1000
        }
        }
      };
      final response=await itemDio.post('Item/get',data: options);
      print("request getItemList : $options" );
      print("response getItemList : ${response.data}" );
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((items)=>ItemModel.fromJson(items)).toList();
      }
      else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
  Future<ItemModel> getOneItem(int itemId)async{
    try {
      final response = await itemDio.get(
          'Item/getOne', queryParameters: {'id': itemId});
      print('Status Code getOneItem: ${response.statusCode}');
      print('Response Data getOneItem: ${response.data}');
      Map<String, dynamic> data=response.data;
      return ItemModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
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
      print('Status Code insertPriceItem: ${response.statusCode}');
      print('Response Data insertPriceItem: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
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
      print('Status Code insertDifferentPriceItem: ${response.statusCode}');
      print('Response Data insertDifferentPriceItem: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
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
      print("request updateStatusItem : $options" );
      print("response updateStatusItem : ${response.data}" );
      return ItemModel.fromJson(response.data);
    } catch (e) {
      throw ErrorException('خطا:$e');
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
      print('Status Code updateItemRange: ${response.statusCode}');
      print('Response Data updateItemRange: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
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
      print('Status Code updateItem: ${response.statusCode}');
      print('Response Data updateItem: ${response.data}');

      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در ویرایش اطلاعات:$e');
    }
  }

}