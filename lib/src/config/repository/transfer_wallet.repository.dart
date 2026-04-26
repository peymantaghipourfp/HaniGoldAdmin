

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/transferWallet/model/list_transfer_wallet.model.dart';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class TransferWalletRepository{

  Dio transferWalletDio=Dio();
  TransferWalletRepository(){
    transferWalletDio.options.baseUrl=BaseUrl.baseUrl;
    transferWalletDio.interceptors.add(DioInterceptor());
  }




  Future<ListTransferWalletModel> getTransferWalletListPager({
    required int startIndex,
    required int toIndex,
    required String startDate,
    required String endDate,
    int? accountId,
    required String name,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "transferwallet" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                  {
                    "fieldName": "Id",
                    "filterValue": accountId.toString(),
                    "filterType": 5,
                    "RefTable": "Account"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "TransferWallet"
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
          "orderBy": "TransferWallet.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await transferWalletDio.post('TransferWallet/getWrapper',data: options);
      if(response.statusCode==200){
        return ListTransferWalletModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getTransferWalletListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<List< dynamic>> deleteTransferWallet({
    required bool isDeleted,
    required int transferWalletId,
  })async{
    try{
      Map<String,dynamic> transferWalletData={
        "id": transferWalletId,
        "isDeleted" : isDeleted,
      };


      var response=await transferWalletDio.delete('TransferWallet/UpdateToIsDeleted',data: transferWalletData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('deleteTransferWallet failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> changeTransferAfterTomorrow(String date)async{
    try{
      final response = await transferWalletDio.post(
          'TransferWallet/transferAfterTomorrow', queryParameters: {'date': date});
      return response.data;
    }catch (e, s) {
      AppLogger.e('changeTransferAfterTomorrow failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<List<OrderModel>> getAfterNotChange() async{
    try{
      final response=await transferWalletDio.post('Order/getAfterNotChange');
      if(response.statusCode==200){
        final dynamic body = response.data;
        if (body == null) {
          return <OrderModel>[];
        }
        if (body is List) {
          return body.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        if (body is Map<String, dynamic>) {
          return <OrderModel>[OrderModel.fromJson(body)];
        }
        return <OrderModel>[];
      }else{
        throw ErrorException('خطا');
      }
      /*List<dynamic> data=response.data;
      return data.map((order) => OrderModel.fromJson(order)).toList();*/

    }catch (e, s) {
      AppLogger.e('getAfterNotChange failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}