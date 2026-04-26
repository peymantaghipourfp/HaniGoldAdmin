

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory.model.dart';
import 'package:hanigold_admin/src/domain/product/model/product_inventory_quantity.model.dart';
import 'package:hanigold_admin/src/domain/product/model/list_product_inventory_detail.model.dart';

import '../../domain/inventory/model/list_forPayment.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import 'dart:typed_data';

import '../network/error_handler.dart';

class ProductInventoryRepository{
  Dio productInventoryDio=Dio();

  ProductInventoryRepository(){
    productInventoryDio.options.baseUrl=BaseUrl.baseUrl;
    productInventoryDio.interceptors.add(DioInterceptor());
  }
  Future<List<ProductInventoryModel>> getProductInventoryList()async{
    try{
      final response=await productInventoryDio.get('Inventory/getInventoryTurnover');
      List<dynamic> data=response.data;
      return data.map((bank)=>ProductInventoryModel.fromJson(bank)).toList();

    }
    catch (e, s) {
      AppLogger.e('getProductInventoryList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListProductInventoryDetailModel> getProductInventoryDetailListPager({
    required int startIndex,
    required int toIndex,
    required String itemId,
    required String startDate,
    required String endDate,
    String? typeFilter,
    String? userFilter,
    String? amountFilter,
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
                if(typeFilter != null && typeFilter.isNotEmpty && typeFilter != 'انتخاب کنید')
                  {
                    "fieldName": "Type",
                    "filterValue": typeFilter == 'دریافت' ? '0' : '1',
                    "filterType": 5,
                    "RefTable": "InventoryDetail"
                  },
                if(userFilter != null && userFilter.isNotEmpty)
                  {
                    "fieldName": "Name",
                    "filterValue": userFilter,
                    "filterType": 0,
                    "RefTable": "Account"
                  },
                if(amountFilter != null && amountFilter.isNotEmpty)
                  {
                    "fieldName": "Quantity",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "InventoryDetail"
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

      return ListProductInventoryDetailModel.fromJson(response.data);

    }
    catch (e, s) {
      AppLogger.e('getProductInventoryDetailListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<ProductInventoryQuantityModel>> getProductInventoryQuantityList()async{
    try{
      final response=await productInventoryDio.get('Inventory/getInventoryQuantity');
      List<dynamic> data=response.data;
      return data.map((bank)=>ProductInventoryQuantityModel.fromJson(bank)).toList();

    }
    catch (e, s) {
      AppLogger.e('getProductInventoryQuantityList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListForPaymentModel> getRecieptRemaindedPager({
    required int startIndex,
    required int toIndex,
    required String itemId,
    required String startDate,
    required String endDate,
    String? userFilter,
    String? amountFilter,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "inventory" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(itemId != null)
                {
                  "fieldName": "Id",
                  "filterValue": itemId,
                  "filterType": 5,
                  "RefTable": "Item"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "inventory"
                  },
                if(userFilter != null && userFilter.isNotEmpty)
                  {
                    "fieldName": "Name",
                    "filterValue": userFilter,
                    "filterType": 0,
                    "RefTable": "Account"
                  },
                if(amountFilter != null && amountFilter.isNotEmpty)
                  {
                    "fieldName": "Quantity",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "InventoryDetail"
                  },
              ]
            }
          ],
          "orderBy": "FilteredDetails.Quantity",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await productInventoryDio.post('Inventory/getRecieptRemaindedWrapper',data: options);
      return ListForPaymentModel.fromJson(response.data);
    }
    catch (e, s) {
      AppLogger.e('getRecieptRemaindedPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // اکسل موجودی ها
  Future<Uint8List> getInventoryQuantityExcel() async{
    try{
      final response=await productInventoryDio.get('Inventory/inventoryQuantityExcel',options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }catch (e, s) {
      AppLogger.e('getInventoryQuantityExcel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // pdf موجودی ها
  Future<Uint8List> getInventoryQuantityPdf()async{
    try{
      final response=await productInventoryDio.get('Inventory/getQuantityPdf',
          options: Options(responseType: ResponseType.bytes)
      );
      return Uint8List.fromList(response.data);
    }
    catch (e, s) {
      AppLogger.e('getInventoryQuantityPdf failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // اکسل ریز موجودی ها
  Future<Uint8List> getRecieptRemaindedListExcel({
    String? itemId,
  }) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "inventory" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if (itemId != null)
                  {
                    "fieldName": "Id",
                    "filterValue": itemId,
                    "filterType": 5,
                    "RefTable": "Item"
                  },
              ]
            }
          ],
          "orderBy": "FilteredDetails.Quantity",
          "orderByType": "Desc",
          "StartIndex": 1,
          "ToIndex": 1000000
        }}
      };
      final response=await productInventoryDio.post(
          'Inventory/recieptRemaindedExcel',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }catch (e, s) {
      AppLogger.e('getRecieptRemaindedListExcel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // pdf ریز موجودی ها
  Future<Uint8List> getRemaindedListPdf({
    String? itemId,
  }) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "inventory" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if (itemId != null)
                  {
                    "fieldName": "Id",
                    "filterValue": itemId,
                    "filterType": 5,
                    "RefTable": "Item"
                  },
              ]
            }
          ],
          "orderBy": "FilteredDetails.Quantity",
          "orderByType": "Desc",
          "StartIndex": 1,
          "ToIndex": 1000000
        }}
      };
      final response=await productInventoryDio.post(
          'Inventory/getRemaindedPdf',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    }catch (e, s) {
      AppLogger.e('getRemaindedListPdf failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}