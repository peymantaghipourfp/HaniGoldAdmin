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
            "orderByType": "asc",
            "StartIndex": 1,
            "ToIndex": 1000
          }
        }
      };
      final response=await orderDio.post('Order/get',data: options);

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
  Future<void> insertOrder({
    required String date,
    required int customerId,
    required String customerName,
    required int itemId,
    required String itemName,
    required double price,
    required double amount,
})async{
    try{
      Map<String, dynamic> orderData = {
        "date": date,
        "customer": {
          "name": customerName,
          "id": customerId,
          "infos": []
        },
        "type": 0,
        "registered": 0,
        "checked": 1,
        "isDeleted": false,
        "salesOrderDetails": [
          {
            "stateMode": 1,
            "item": {
              "name": itemName,
              "id": itemId,
              "infos": []
            },
            "itemPrice": {
              "price": price,
              "differentPrice": 0,
              "id": 20,
              "infos": []
            },
            "amount": amount,
            "price": price,
            "totalPrice": price * amount,
            "type": 1,
            "registered": 0,
            "checked": 1,
            "isDeleted": false,
            "rowNum": 1,
            "id": 1,
            "attribute": "cus",
            "recId": "e6b8aab0-4651-4917-b724-3d4cdfe6238e",
            "infos": []
          }
        ],
        "rowNum": 1,
        "attribute": "cus",
        "infos": []
      };
      final response=await orderDio.post('Order/insert',data: orderData);
      if(response.statusCode==200){
        print('ثبت با موفقیت انجام شد');
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
}