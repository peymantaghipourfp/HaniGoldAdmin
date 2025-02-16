import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hanigold_admin/src/config/repository/url/baseUrl.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import '../network/error/network.error.dart';

class OrderRepository{
  Dio orderDio=Dio();

  OrderRepository(){
    orderDio.options.baseUrl="http://192.168.100.87:10000/api/";

  }
  Future<List<OrderModel>> getOrderList() async{
    try{
      final response=await orderDio.post('Order');
      List<dynamic> data=response.data;
      if(response.statusCode==200) {
        return data.map((order) => OrderModel.fromJson(order)).toList();
      }else{
        throw Text('خطا');
      }
    }catch(e){
      rethrow;
    }
  }
}