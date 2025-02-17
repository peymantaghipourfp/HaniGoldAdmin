import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import '../network/error/network.error.dart';

class OrderRepository{
  Dio orderDio=Dio();

  OrderRepository(){
    orderDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<List<OrderModel>> getOrderList() async{
    try{
      Map<String, dynamic> options = {
        "options": {
          "salesOrder": {
            "orderBy": "SalesOrder.Id",
            "orderByType": "asc",
            "StartIndex": 1,
            "ToIndex": 10000
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
}