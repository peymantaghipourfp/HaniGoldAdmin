

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:hanigold_admin/src/domain/product/model/list_product_inventory_detail.model.dart';

import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';

class ProductInventoryRepository{
  Dio productInventoryDio=Dio();

  ProductInventoryRepository(){
    productInventoryDio.options.baseUrl=BaseUrl.baseUrl;
    productInventoryDio.interceptors.add(DioInterceptor());
  }
  Future<List<ProductInventoryModel>> getProductInventoryList()async{
    try{
      final response=await productInventoryDio.get('Inventory/getInventoryTurnover');
      print("response getProductInventoryList : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((bank)=>ProductInventoryModel.fromJson(bank)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ListProductInventoryDetailModel> getProductInventoryDetailListPager({
    required int startIndex,
    required int toIndex,
    required String itemId,
    required String startDate,
    required String endDate,
  })async{
    try{
      Map<String , dynamic> options={
        "options" : { "inventorydetail" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(itemId != null)
                  {
                    "fieldName": "ItemId",
                    "filterValue": itemId,
                    "filterType": 5,
                    "RefTable": "InventoryDetail"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "inventory"
                  },
              ]
            }
          ],
          "orderBy": "inventory.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await productInventoryDio.post('Inventory/getInventoryDetailList',data: options);
      print("request getProductInventoryDetailListPager : $options" );
      print("response getProductInventoryDetailListPager : ${response.data}" );

      return ListProductInventoryDetailModel.fromJson(response.data);

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
}