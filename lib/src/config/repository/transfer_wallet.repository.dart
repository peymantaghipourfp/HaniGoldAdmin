import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance_request.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/transferWallet/model/list_transfer_wallet.model.dart';
import 'package:hanigold_admin/src/domain/transferWallet/model/transfer_wallet.model.dart';

import '../../domain/remittance/model/image_guid_model.dart';
import 'dart:typed_data';

import '../network/dio_Interceptor.dart';

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
      print("url getTransferWalletListPager : TransferWallet/getWrapper" );
      print("request getTransferWalletListPager : $options" );
      print("response getTransferWalletListPager : ${response.data}" );
      if(response.statusCode==200){
        return ListTransferWalletModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
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

      print(transferWalletData);

      var response=await transferWalletDio.delete('TransferWallet/UpdateToIsDeleted',data: transferWalletData);
      print('Status Code deleteTransferWallet: ${response.statusCode}');
      print('Response Data deleteTransferWallet: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

  Future<TransferWalletModel> changeTransferAfterTomorrow(String date)async{
    try{
      final response = await transferWalletDio.post(
          'TransferWallet/transferAfterTomorrow', queryParameters: {'date': date});
      print('Status Code insertTransferAfterTomorrow: ${response.statusCode}');
      print('Response Data insertTransferAfterTomorrow: ${response.data}');
      Map<String, dynamic> data=response.data;
      return TransferWalletModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

}