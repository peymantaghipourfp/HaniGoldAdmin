import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import '../network/error/network.error.dart';

class OrderRepository{
  Dio orderDio=Dio();

  OrderRepository(){
    orderDio.options.baseUrl=BaseUrl.baseUrl;
    orderDio.options.connectTimeout=Duration(seconds: 10);

  }
  Future<List<OrderModel>> getOrderList() async{
    try{
      Map<String, dynamic> options = {
        "options": {
          "order": {
            "orderBy": "Orders.Id",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 1000
          }
        }
      };
      final response=await orderDio.post('Order/get',data: options);
      print(response);
      if(response.statusCode==200) {
        List<dynamic> data=response.data;
        return data.map((order) => OrderModel.fromJson(order)).toList();

      }else{
        throw ErrorException('خطا');
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }
  Future<Map<String, dynamic>> insertOrder({
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required int itemId,
    required String itemName,
    required double price,
    required double amount,
    required String? description,
})async{
    try{
      Map<String, dynamic> orderData = {
        "date": date,
        "limitDate": "2024-11-13T13:21:23",
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
        "mode": 0,
        "item": {
          "itemGroup": {
            "infos": []
          },
          "itemUnit": {
            "name": "گرم",
            "id": 1,
            "infos": []
          },
          "name": itemName,
          "id": itemId,
          "infos": []
        },
        "amount": amount,
        "price": price,
        "differentPrice": 92340.3666,
        "totalPrice": amount * price,
        "checked": true,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": "25a39f5d-81c6-4362-b59b-3dc6123a9364",
        "infos": [],
        "description": description,
      };

      var response=await orderDio.post('Order/insert',data: orderData);
      /*if(response.statusCode==200){
        print('ثبت با موفقیت انجام شد');
      }else{
        throw ErrorException('خطا');
      }*/
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<Map<String, dynamic>> updateOrder({
    required int orderId,
    required String date,
    required int accountId,
    required String accountName,
    required int type,
    required int itemId,
    required String itemName,
    required double price,
    required double amount,
    required String? description,
})async{
    try{
      Map<String, dynamic> orderData = {
        "id": orderId,
        "date": date,
        "limitDate": null,
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
        "mode": 0,
        "item": {
          "itemGroup": {
            "infos": []
          },
          "itemUnit": {
            "name": "گرم",
            "id": 1,
            "infos": []
          },
          "name": itemName,
          "id": itemId,
          "infos": []
        },
        "amount": amount,
        "price": price,
        "differentPrice": 92340.3666,
        "totalPrice": amount * price,
        "checked": true,
        "rowNum": 1,
        "attribute": "cus",
        "recId": "25a39f5d-81c6-4362-b59b-3dc6123a9364",
        "infos": [],
        "description": description,
      };
      var response=await orderDio.put('Order/update',data: orderData );
      print(response.data);
      // if(response.statusCode==200){
      //   print('ویرایش با موفقیت انجام شد');
      //   print(response.data);
      //   return response.data;
      // }else{
      //   throw ErrorException('خطا در ویرایش اطلاعات');
      // }
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در ویرایش اطلاعات:$e');
    }
  }
}