
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';

import '../../domain/balance/model/balance_trading.model.dart';
import '../../domain/inventory/model/inventory.model.dart';
import '../../domain/users/model/balance_item.model.dart';
import '../../domain/users/model/header_info_user_transaction.model.dart';
import '../../domain/users/model/list_transaction_info_item.model.dart';
import '../../domain/users/model/transaction_info_item.model.dart';

class TradingBalanceRepository{

  Dio tradingBalanceDio=Dio();
  TradingBalanceRepository(){
    tradingBalanceDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<List<BalanceTradingModel>> getTradingBalanceList()async{
    try{

      final response=await tradingBalanceDio.get('Order/orderReport');
      print("response getTradingBalanceList : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((transaction)=>BalanceTradingModel.fromJson(transaction)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }




  // Future<RemittanceModel> insertRemittance({
  //   required String date,
  //   required int accountIdPayer,
  //   required String accountNamePayer,
  //   required int accountIdReciept,
  //   required String accountNameReciept,
  //   required int itemId,
  //   required double quantity,
  //   required String? description,
  // })async{
  //   try{
  //     Map<String, dynamic> orderData =
  //       {
  //         "date": date,
  //         "walletPayer": {
  //           "address": null,
  //           "account": {
  //             "name": accountNamePayer,
  //             "accountGroup": {
  //               "infos": []
  //             },
  //             "accountItemGroup": {
  //               "infos": []
  //             },
  //             "accountPriceGroup": {
  //               "infos": []
  //             },
  //             "id": accountIdPayer,
  //             "infos": []
  //           },
  //           "item": {
  //             "itemGroup": {
  //               "infos": []
  //             },
  //             "itemUnit": {
  //               "infos": []
  //             },
  //             "infos": []
  //           },
  //           "id": null,
  //           "infos": []
  //         },
  //         "walletReciept": {
  //           "address": null,
  //           "account": {
  //             "name": accountNameReciept,
  //             "accountGroup": {
  //               "infos": []
  //             },
  //             "accountItemGroup": {
  //               "infos": []
  //             },
  //             "accountPriceGroup": {
  //               "infos": []
  //             },
  //             "id": accountIdReciept,
  //             "infos": []
  //           },
  //           "item": {
  //             "itemGroup": {
  //               "infos": []
  //             },
  //             "itemUnit": {
  //               "infos": []
  //             },
  //             "infos": []
  //           },
  //           "id": null,
  //           "infos": []
  //         },
  //         "item": {
  //           "itemGroup": {
  //             "infos": []
  //           },
  //           "itemUnit": {
  //             "name": null,
  //             "id": null,
  //             "infos": []
  //           },
  //           "name": "طلای آبشده",
  //           "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
  //           "id": itemId,
  //           "infos": []
  //         },
  //         "quantity": quantity,
  //         "status": 1,
  //         "isDeleted": false,
  //         "rowNum": 1,
  //         "id": 1,
  //         "attribute": "cus",
  //         "description": description,
  //         "infos": []
  //
  //     };
  //
  //     var response=await userInfoTransactionDio.post('Remittance/insert',data: orderData);
  //     /*if(response.statusCode==200){
  //       print('ثبت با موفقیت انجام شد');
  //     }else{
  //       throw ErrorException('خطا');
  //     }*/
  //     return RemittanceModel.fromJson(response.data);
  //   }
  //   catch(e){
  //     throw ErrorException('خطا در درج اطلاعات:$e');
  //   }
  // }
}