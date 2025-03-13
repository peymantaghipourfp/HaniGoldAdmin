

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit_request.model.dart';

import '../network/error/network.error.dart';

class DepositRequestRepository{

  Dio depositRequestDio=Dio();

  DepositRequestRepository(){
    depositRequestDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<List<DepositRequestModel>> getDepositRequest(int withdrawId)async{
    try{
      final response=await depositRequestDio.get('DepositRequest/getByWithdraw',queryParameters: {'id':withdrawId});
      print(response);
      List<dynamic> data=response.data;
      return data.map((depositRequest)=>DepositRequestModel.fromJson(depositRequest)).toList();
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<Map<String , dynamic>> insertDepositRequest({
    required int? withdrawId,
    required int? accountId,
    required double? amount,
    required double? requestAmount,
  })async{
    try{
      Map<String , dynamic> depositRequestData={
        "withdrawRequest": {
          "bankAccount": {
            "bank": {
              "infos": []
            },
            "account": {
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "infos": []
            },
            "infos": []
          },
          "wallet": {
            "account": {
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "infos": []
            },
            "item": {
              "itemGroup": {
                "infos": []
              },
              "itemUnit": {
                "infos": []
              },
              "infos": []
            },
            "infos": []
          },
          "id": withdrawId,
          "infos": []
        },
        "account": {
          "name": "شرکت BI",
          "contactInfo": "0993882350",
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
        "item": {
          "itemGroup": {
            "infos": []
          },
          "itemUnit": {
            "infos": []
          },
          "infos": []
        },
        "amount": amount,
        "requestAmount": requestAmount,
        "paidAmount": 75.000,
        "notPaidAmount": 0.000,
        "status": 0,
        "date": "2025-02-20T15:41:55",
        "deposits": [],
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": "23f235da-c565-4a43-9395-ac47d86e293a",
        "infos": []
      };
      var response=await depositRequestDio.post('DepositRequest/insert',data: depositRequestData);
      return response.data;
    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }
}