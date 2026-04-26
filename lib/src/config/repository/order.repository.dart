import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/order/model/list_order_byAccount_report.model.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/order/model/total_balance_new.model.dart';
import '../../domain/order/model/list_order.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import 'dart:typed_data';

import '../network/error_handler.dart';

class OrderRepository{
  Dio orderDio=Dio();

  OrderRepository(){
    orderDio.options.baseUrl=BaseUrl.baseUrl;
    orderDio.options.connectTimeout=Duration(seconds: 30);
    orderDio.interceptors.add(DioInterceptor());
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
        List<dynamic> data=response.data;
        return data.map((order) => OrderModel.fromJson(order)).toList();

    }catch (e, s) {
      AppLogger.e('getOrderList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<ListOrderModel> getOrderListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
    required String name,
    required int? byAdmin,
    required int? type,
    String? amountFilter,
    int? item,
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
                if (byAdmin != null)
                  {
                    "fieldName": "byAdmin",
                    "filterValue": "$byAdmin",
                    "filterType": 4,
                    "RefTable": "Orders"
                  },
                if (type != null)
                  {
                    "fieldName": "type",
                    "filterValue": "$type",
                    "filterType": 4,
                    "RefTable": "Orders"
                  },
                if (item != null)
                  {
                    "fieldName": "Id",
                    "filterValue": "$item",
                    "filterType": 5,
                    "RefTable": "Item"
                  },
              ],
            },
            // Amount filter
            if(amountFilter != null && amountFilter.isNotEmpty)
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Quantity",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  },
                  {
                    "fieldName": "MesghalPrice",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  },
                  {
                    "fieldName": "Price",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  },
                  {
                    "fieldName": "TotalPrice",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  }
                ]
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
        return ListOrderModel.fromJson(response.data);

    }catch (e, s) {
      AppLogger.e('getOrderListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Uint8List> getOrderExcel({
    required String startDate,
    required String endDate,
    required int? type,
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
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Orders"
                  },
                if (type != null)
                  {
                    "fieldName": "type",
                    "filterValue": "$type",
                    "filterType": 4,
                    "RefTable": "Orders"
                  }
              ]
            }
          ],
          "orderBy": "Orders.date",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 100000
        }
        }
      };
      final response=await orderDio.post(
          'Order/getExcel',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }catch (e, s) {
      AppLogger.e('getOrderExcel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<OrderModel> getOneOrder(int orderId)async{
    try {
      final response = await orderDio.get(
          'Order/getOne', queryParameters: {'id': orderId});
      Map<String, dynamic> data=response.data;
      return OrderModel.fromJson(data);
    }catch (e, s) {
      AppLogger.e('getOneOrder failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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
    required bool? isCard,
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
        "isCard":isCard,
      };

      var response=await orderDio.post('Order/insert',data: orderData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('insertOrder failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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
    required bool? isCard,
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
        "isCard":isCard,
      };
      var response=await orderDio.put('Order/update',data: orderData );
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateOrder failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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

      var response=await orderDio.put('Order/updateStatus',data: orderData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateStatusOrder failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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

      var response=await orderDio.delete('Order/updateToIsDeleted',data: orderData);
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch (e, s) {
      AppLogger.e('deleteOrder failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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

      var response=await orderDio.put('Order/updateRegistered',data: orderData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateRegistered failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<TotalBalanceNewModel>> getTotalBalanceList()async{
  //Future<List<TotalBalanceModel>> getTotalBalanceList()async{
    try{
      final response=await orderDio.get('Order/marketDailyResult');
      //final response=await orderDio.get('Order/OrderBalanceDay');
      if (response.data == null) {
        return [];
      }
      List<dynamic> data = response.data;
      return data.isNotEmpty ? data.map((totalBalance)=>TotalBalanceNewModel.fromJson(totalBalance)).toList() : [];
      //return data.isNotEmpty ? data.map((totalBalance)=>TotalBalanceModel.fromJson(totalBalance)).toList() : [];
    }
    catch (e, s) {
      AppLogger.e('getTotalBalanceList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListOrderByAccountReportModel> getOrderByAccountReportPager({
    required int startIndex,
    required int toIndex,
    required String startDate,
    required String endDate,
    int? accountId,
    required String name,
    String? orderBy,
    String? orderByType,
  })async{
    try{
      Map<String , dynamic> options=
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
          "orderBy": orderBy ?? "InnerQuery.reportDate",
          "orderByType": orderByType ?? "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await orderDio.post('Order/balanceDayByAccountReport',data: options);
      if(response.statusCode==200){
        return ListOrderByAccountReportModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getOrderByAccountReportPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Uint8List> getOrderByAccountReportPdf({
    int? accountId,
    required String name,
    required String startDate,
    required String endDate
  })async{
    try{
      Map<String , dynamic> options=
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
          "orderBy": "InnerQuery.reportDate",
          "orderByType": "DESC",
          "StartIndex": 1,
          "ToIndex": 10000000
        }
        }
      };
      final response=await orderDio.post('Order/balanceDayByAccountPdf',data: options,options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }
    catch (e, s) {
      AppLogger.e('getOrderByAccountReportPdf failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListOrderModel> getOrderEditedReportPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    required String startDate,
    required String endDate,
    required String startCreatedOnDate,
    required String endCreatedOnDate,
    required String startModifiedOnDate,
    required String endModifiedOnDate,
    required String name,
    required int? byAdmin,
    required int? type,
    String? amountFilter,
    int? item,
    String? orderBy,
    String? orderByType,
  })async{
    try{
      Map<String , dynamic> options=
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
                if(startCreatedOnDate!="")
                  {
                    "fieldName": "CreatedOn",
                    "filterValue": "$startCreatedOnDate|$endCreatedOnDate",
                    "filterType": 25,
                    "RefTable": "Orders"
                  },
                if(startModifiedOnDate!="")
                  {
                    "fieldName": "ModifiedOn",
                    "filterValue": "$startModifiedOnDate|$endModifiedOnDate",
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
                if (byAdmin != null)
                  {
                    "fieldName": "byAdmin",
                    "filterValue": "$byAdmin",
                    "filterType": 4,
                    "RefTable": "Orders"
                  },
                if (type != null)
                  {
                    "fieldName": "type",
                    "filterValue": "$type",
                    "filterType": 4,
                    "RefTable": "Orders"
                  },
                if (item != null)
                  {
                    "fieldName": "Id",
                    "filterValue": "$item",
                    "filterType": 5,
                    "RefTable": "Item"
                  },
              ],
            },
            // Amount filter
            if(amountFilter != null && amountFilter.isNotEmpty)
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Quantity",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  },
                  {
                    "fieldName": "MesghalPrice",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  },
                  {
                    "fieldName": "Price",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  },
                  {
                    "fieldName": "TotalPrice",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "Orders"
                  }
                ]
              }
          ],
          "orderBy": orderBy ?? "orders.date",
          "orderByType": orderByType ?? "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await orderDio.post('Order/getEditedWrapper',data: options);
      if(response.statusCode==200){
        return ListOrderModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getOrderEditedReportPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> sendTelegramOrder({
    required int orderId,
  })async{
    try {
      final response = await orderDio.post('Order/sendTelegram', queryParameters: {'orderId': orderId});
      return response.data;
    }catch (e, s) {
      AppLogger.e('sendTelegramOrder failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}