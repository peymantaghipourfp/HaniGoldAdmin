

import 'package:dio/dio.dart';
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
          "ToIndex": 10
        }
        }
      };
      final response=await itemDio.post('Item/get',data: options);
      //print(response);
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
}