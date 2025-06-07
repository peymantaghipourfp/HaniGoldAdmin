

import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';

class ItemRepository{

  Dio itemDio=Dio();

  ItemRepository(){
    itemDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<List<ItemModel>> getItemList()async{
    try{
      Map<String , dynamic> options= {
        "options" : {
          "item" :{
          "orderBy": "Item.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 100
        }
        }
      };
      final response=await itemDio.post('Item/get',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
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
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
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
  })async{
    try{
      Map<String, dynamic> itemData = {
        "itemId": itemId,
        "price": price,
        "differentPrice": differentPrice,
        "rowNum": 1,
        "attribute": "sys",
        "infos": []
      };

      var response=await itemDio.post('ItemPrice/insert',data: itemData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }
  Future<Map<String , dynamic>> insertDifferentPriceItem({
    required int itemId,
    required double differentPrice,
    required double price,
  })async{
    try{
      Map<String, dynamic> itemData = {
        "itemId": itemId,
        "differentPrice": differentPrice,
        "price": price,
        "rowNum": 1,
        "attribute": "sys",
        "infos": []
      };

      var response=await itemDio.post('ItemPrice/insert',data: itemData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<ItemModel> updateStatusItem({
    required int id,
    required bool status,
  }) async {
    try {
      Map<String, dynamic> options = {
        "status": status,
        "id": id,
      };
      final response = await itemDio.put('Item/updateStatus', data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      return ItemModel.fromJson(response.data);
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  Future<Map<String , dynamic>> updateItemRange({
    required int itemId,
    required int maxSell,
    required int maxBuy,
    required double saleRange,
    required double buyRange,
  })async{
    try{
      Map<String, dynamic> itemData = {
        "maxSell": maxSell,
        "maxBuy": maxBuy,
        "saleRange": saleRange,
        "buyRange": buyRange,
        "id": itemId
      };

      var response=await itemDio.put('Item/updateRange',data: itemData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }
}