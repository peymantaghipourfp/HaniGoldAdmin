import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/order/model/total_balance.model.dart';
import '../../domain/order/model/list_order.model.dart';
import '../network/error/network.error.dart';

class OrderRepository{
  Dio orderDio=Dio();

  OrderRepository(){
    orderDio.options.baseUrl=BaseUrl.baseUrl;
    orderDio.options.connectTimeout=Duration(seconds: 30);

  }
  Future<List<OrderModel>> getOrderList({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate}) async{
    try{
      Map<String, dynamic> options = {
        "options": {
          "order": {
              "Predicate": [
                {
                  "innerCondition": 0,
                  "outerCondition": 0,
                  "filters": [
                    if (accountId != null)
                    {
                      "fieldName": "AccountId",
                      "filterValue": accountId.toString(),
                      "filterType": 5,
                      "RefTable": "Orders"
                    },
                    {
                      "fieldName": "IsDeleted",
                      "filterValue": "0",
                      "filterType": 4,
                      "RefTable": "Orders"
                    },
                    if(startDate!="")
                      {
                        "fieldName": "Date",
                        "filterValue": "$startDate|$endDate",
                        "filterType": 25,
                        "RefTable": "Orders"
                      }
                  ]
                }
              ],
            "orderBy": "Orders.Id",
            "orderByType": "desc",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      };
      final response=await orderDio.post('Order/get',data: options);
      print("request getOrderList : $options" );
      print("response getOrderList : ${response.data}" );
        List<dynamic> data=response.data;
        return data.map((order) => OrderModel.fromJson(order)).toList();

    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<ListOrderModel> getOrderListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
    required String name,
  }) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "order" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "Orders"
                },
                if(startDate!="")
                {
                  "fieldName": "Date",
                  "filterValue": "$startDate|$endDate",
                  "filterType": 25,
                  "RefTable": "Orders"
                },
                if(name!="")
                {
                  "fieldName": "Name",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "Account"
                },
              ],
            }
          ],
          "orderBy": "Orders.date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
          }
        }
      };
      final response=await orderDio.post('Order/getWrapper',data: options);
      print("request getOrderListPager : $options" );
      print("response getOrderListPager : ${response.data}" );
        return ListOrderModel.fromJson(response.data);

    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<OrderModel> getOneOrder(int orderId)async{
    try {
      final response = await orderDio.get(
          'Order/getOne', queryParameters: {'id': orderId});
      print('Status Code getOneOrder: ${response.statusCode}');
      print('Response Data getOneOrder: ${response.data}');
      Map<String, dynamic> data=response.data;
      return OrderModel.fromJson(data);
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
    required double quantity,
    required String? description,
    required bool? notLimit,
    required bool? manualPrice,
})async{
    try{
      Map<String, dynamic> orderData = {
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
        "quantity": quantity,
        "price": price,
        "differentPrice": 92340.3666,
        "totalPrice": quantity * price,
        "checked": true,
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": null,
        "infos": [],
        "description": description,
        "manualPrice":manualPrice,
        "notLimit":notLimit,
      };

      var response=await orderDio.post('Order/insert',data: orderData);
      print('Status Code insertOrder: ${response.statusCode}');
      print('Response Data insertOrder: ${response.data}');
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
    required double quantity,
    required String? description,
    required bool? notLimit,
    required bool? manualPrice,
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
        "quantity": quantity,
        "price": price,
        "differentPrice": 92340.3666,
        "totalPrice": quantity * price,
        "checked": true,
        "rowNum": 1,
        "attribute": "cus",
        "recId": null,
        "infos": [],
        "description": description,
        "manualPrice":manualPrice,
        "notLimit":notLimit,
      };
      var response=await orderDio.put('Order/update',data: orderData );
      print('Status Code updateOrder: ${response.statusCode}');
      print('Response Data updateOrder: ${response.data}');
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

  Future<List<dynamic>> updateStatusOrder({
    required int status,
    required int orderId,
  })async{
    try{
      Map<String,dynamic> orderData={
        "date": null,
        "limitDate": null,
        "account": {
          "code": null,
          "name": null,
          "accountGroup": {
            "infos": []
          },
          "accountItemGroup": {
            "infos": []
          },
          "accountPriceGroup": {
            "infos": []
          },
          "id": null,
          "infos": []
        },
        "type": null,
        "mode": null,
        "item": {
          "itemGroup": {
            "infos": []
          },
          "itemUnit": {
            "name": null,
            "id": null,
            "infos": []
          },
          "name": null,
          "id": null,
          "infos": []
        },
        "quantity": null,
        "price": null,
        "differentPrice": null,
        "totalPrice": null,
        "status": status,
        "rowNum": null,
        "id": orderId,
        "attribute": "cus",
        "recId": null,
        "infos": []
      };

      print(orderData);

      var response=await orderDio.put('Order/updateStatus',data: orderData);
      print('Status Code updateStatusOrder: ${response.statusCode}');
      print('Response Data updateStatusOrder: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
    }
  }

  Future<List< dynamic>> deleteOrder({
    required bool isDeleted,
    required int orderId,
  })async{
    try{
      Map<String,dynamic> orderData={
        "id": orderId,
        "isDeleted" : isDeleted,
      };

      print(orderData);

      var response=await orderDio.delete('Order/updateToIsDeleted',data: orderData);
      print('Status Code deleteOrder: ${response.statusCode}');
      print('Response Data deleteOrder: ${response.data}');
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

  Future<List< dynamic>> updateRegistered({
    required bool registered,
    required int orderId,
  })async{
    try{
      Map<String,dynamic> orderData={
        "registered": registered,
        "id": orderId,
      };
      print(orderData);

      var response=await orderDio.put('Order/updateRegistered',data: orderData);
      print('Status Code updateRegistered: ${response.statusCode}');
      print('Response Data updateRegistered: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }

  Future<List<TotalBalanceModel>> getTotalBalanceList()async{
    try{
      final response=await orderDio.get('Order/OrderBalanceDay');
      print('Status Code getBalanceList: ${response.statusCode}');
      print("response getBalanceList : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((totalBalance)=>TotalBalanceModel.fromJson(totalBalance)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
}