

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
      print(response);
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
      print(response);
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
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }
}