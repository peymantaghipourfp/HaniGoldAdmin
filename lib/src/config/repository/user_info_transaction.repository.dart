
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/users/model/check_result.model.dart';
import 'package:hanigold_admin/src/domain/users/model/list_transactions_wallet_receivables.model.dart';
import 'package:hanigold_admin/src/domain/users/model/report_setting.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_footer.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_gold_list_pager.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import '../../domain/order/model/tooltip_total_balance.model.dart';
import '../../domain/users/model/balance_item.model.dart';
import '../../domain/users/model/header_info_user_transaction.model.dart';
import '../../domain/users/model/list_transaction_info.model.dart';
import '../../domain/users/model/list_transaction_info_item.model.dart';
import 'dart:typed_data';

import '../../domain/users/model/transaction_info_item.model.dart';
import '../../domain/users/model/transaction_info_item_list_pager.model.dart';
import '../network/dio_Interceptor.dart';

class UserInfoTransactionRepository{

  Dio userInfoTransactionDio=Dio();
  UserInfoTransactionRepository(){
    userInfoTransactionDio.options.baseUrl=BaseUrl.baseUrl;
    userInfoTransactionDio.interceptors.add(DioInterceptor());
  }
  Future<HeaderInfoUserTransactionModel> getHeaderUserInfoTransaction(int id)async{
    try{
      Map<String,dynamic> option={
        "id": id,
      };
      final response=await userInfoTransactionDio.get('Transaction/getTransactionsHeader',queryParameters: option);
      print("url : Transaction/getTransactionsHeader" );
      print("request getHeaderUserInfoTransaction : $option" );
      print("response getHeaderUserInfoTransaction : ${response.data}" );
      if(response.statusCode==200){

        return HeaderInfoUserTransactionModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
  Future<List<BalanceItemModel>> getBalanceList(int id)async{
    try{
      Map<String,dynamic> option={
        "id": id,
      };
      final response=await userInfoTransactionDio.get('Wallet/getBalance',queryParameters: option);
      print("url : Wallet/getBalance" );
      print("request getBalanceList : $option" );
      print("response getBalanceList : ${response.data}" );
      if(response.statusCode==200){
        if(response.data == null) {
          return <BalanceItemModel>[];
        }
        List<dynamic> data=response.data;
        return data.map((balance)=>BalanceItemModel.fromJson(balance)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<TooltipTotalBalanceModel> getTooltipTotalBalance(int id)async{
    try{
      Map<String,dynamic> option={
        "id": id,
      };
      final response=await userInfoTransactionDio.get('Wallet/getTotalBalance',queryParameters: option);
      print("url : Wallet/getTotalBalance" );
      print("request getTooltipTotalBalance : $option" );
      print("response getTooltipTotalBalance : ${response.data}" );
      if(response.statusCode==200){
        if(response.data == null) {
          return TooltipTotalBalanceModel(
            account: null,
            currencyValue: 0.0,
            goldValue: 0.0,
            coinValue: 0.0,
            balances: [],
          );
        }
        // Handle array response - get the first item
        List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return TooltipTotalBalanceModel.fromJson(data.first);
        } else {
          return TooltipTotalBalanceModel(
            account: null,
            currencyValue: 0.0,
            goldValue: 0.0,
            coinValue: 0.0,
            balances: [],
          );
        }
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<WalletModel> getChangeOneWallet(int accountId, int itemId)async{
    try{
      Map<String,dynamic> option={
        "accountId": accountId,
        "itemId": itemId,
      };
      final response=await userInfoTransactionDio.get('TransferWallet/changeOne',queryParameters: option);
      print("url : TransferWallet/changeOne" );
      print("request getChangeOneWallet : $option" );
      print("response getChangeOneWallet : ${response.data}" );
      if(response.statusCode==200){
        Map<String, dynamic> data=response.data;
        return WalletModel.fromJson(data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<TransactionInfoItemListPagerModel> getTransactionInfoListPager({
    required int startIndex,
    required int toIndex,
    required String accountId,
    required String startDate,
    required String endDate,
    String? type,
    String? amountFilter,
    int? item,
  })async{
    try{
      Map<String , dynamic> options={
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId,
                  "filterType": 5,
                  "RefTable": "at"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  },
                if(type!="" && !type!.contains(','))
                  {
                    "fieldName": "[Type]",
                    "filterValue": type,
                    "filterType": 4,
                    "RefTable": "at"
                  },
                if (item != null)
                  {
                    "fieldName": "ItemId",
                    "filterValue": "$item",
                    "filterType": 5,
                    "RefTable": "at"
                  },
              ]
            },
            // Multiple types filter (for comma-separated values like 'buy,sell')
            if(type!="" && type!.contains(','))
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountId,
                    "filterType": 5,
                    "RefTable": "at"
                  },
                  ...type.split(',').map((singleType) => {
                    "fieldName": "[Type]",
                    "filterValue": singleType.trim(),
                    "filterType": 4,
                    "RefTable": "at"
                  }).toList()
                ]
              },
            // Amount filter
            if(amountFilter != null && amountFilter.isNotEmpty)
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountId,
                    "filterType": 5,
                    "RefTable": "at"
                  },
                  {
                    "fieldName": "Amount",
                    "filterValue": amountFilter,
                    "filterType": 0,
                    "RefTable": "at"
                  },
                ]
              }
          ],
          "orderBy": "at.Date",
          "orderByType": "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getWrapper',data: options);
      print("request getTransactionInfoListPager : $options" );
      print("response getTransactionInfoListPager : ${response.data}" );

      return TransactionInfoItemListPagerModel.fromJson(response.data);

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<TransactionInfoGoldListPagerModel> getTransactionInfoGoldListPager({
    required int startIndex,
    required int toIndex,
    String? accountId,
    required String startDate,
    required String endDate,
    String? type,
    String? descriptionFilter,
    String? amountFilter,
    int? item,
  })async{
    try{
      Map<String , dynamic> options={
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountId,
                    "filterType": 5,
                    "RefTable": "at"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  },
                if(type!="" && !type!.contains(','))
                  {
                    "fieldName": "[Type]",
                    "filterValue": type,
                    "filterType": 4,
                    "RefTable": "at"
                  },
                if (item != null)
                  {
                    "fieldName": "ItemId",
                    "filterValue": "$item",
                    "filterType": 5,
                    "RefTable": "at"
                  },
              ]
            },
            // Multiple types filter (for comma-separated values like 'buy,sell')
            if(type!="" && type!.contains(','))
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountId,
                    "filterType": 5,
                    "RefTable": "at"
                  },
                  ...type.split(',').map((singleType) => {
                    "fieldName": "[Type]",
                    "filterValue": singleType.trim(),
                    "filterType": 4,
                    "RefTable": "at"
                  }).toList()
                ]
              },
            // Description filter
            if(descriptionFilter != null && descriptionFilter.isNotEmpty)
            {
              "innerCondition": 1,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId,
                  "filterType": 5,
                  "RefTable": "at"
                },
                {
                  "fieldName": "Name",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "ToAccount"
                },
                {
                  "fieldName": "Name",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "Item"
                },
                {
                  "fieldName": "Name",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "Laboratory"
                },
                {
                  "fieldName": "Carat",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "idetail"
                },
                {
                  "fieldName": "Weight",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "idetail"
                },
                {
                  "fieldName": "ReceiptNumber",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "idetail"
                },
                {
                  "fieldName": "Description",
                  "filterValue": descriptionFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
              ]
            },
            // Amount filter
            if(amountFilter != null && amountFilter.isNotEmpty)
            {
              "innerCondition": 1,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId,
                  "filterType": 5,
                  "RefTable": "at"
                },
                {
                  "fieldName": "Amount",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "[Cash.TotalRunning]",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "[Gold.TotalRunning]",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "[Coin.TotalRunning]",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "[HalfCoin.TotalRunning]",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "[QuarterCoin.TotalRunning]",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "Price",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                },
                {
                  "fieldName": "TotalPrice",
                  "filterValue": amountFilter,
                  "filterType": 0,
                  "RefTable": "at"
                }
                ]
            }
          ],
          "orderBy": "at.Date DESC, at.Id",
          "orderByType": "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getGoldWrapper',data: options);
      print("request getTransactionInfoGoldListPager : $options" );
      print("response getTransactionInfoGoldListPager : ${response.data}" );

      return TransactionInfoGoldListPagerModel.fromJson(response.data);

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<TransactionInfoItemListPagerModel> getTransactionInfoListForPdf({
    required int startIndex,
    required int toIndex,
    required String accountId,
    required String startDate,
    required String endDate
  })async{
    try{
      Map<String , dynamic> options={
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId,
                  "filterType": 5,
                  "RefTable": "at"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  }
              ]
            }
          ],
          "orderBy": "at.Date",
          "orderByType": "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getWrapper',data: options);
      print("request getTransactionInfoListPager : $options" );
      print("response getTransactionInfoListPager : ${response.data}" );
      return TransactionInfoItemListPagerModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Uint8List> getGoldPdf({
    required int startIndex,
    required int toIndex,
    required String accountId,
    required String startDate,
    required String endDate
  })async{
    try{
      Map<String , dynamic> options={
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId,
                  "filterType": 5,
                  "RefTable": "at"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  }
              ]
            }
          ],
          "orderBy": "at.Date DESC, at.Id",
          "orderByType": "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getGoldPdf',
          data: options,
          options: Options(responseType: ResponseType.bytes)
      );
      print("request getTransactionInfoListPager : $options" );
      print("response getTransactionInfoListPager : ${response.data}" );
      return Uint8List.fromList(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List<ListTransactionInfoItemModel>> getListTransactionInfoList({required int startIndex, required int toIndex,required String name})async{
    try{
      Map<String , dynamic> options=
          name!=""?
      {
        "options" : { "transaction" :{
             "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "accountName",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "AccountValues"
                }
              ]
            }
          ],
          "orderBy": "ABS(AccountValues.CurrencyValue)",
          "orderByType": "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      }:
          {
            "options" : { "transaction" :{
              "orderBy": "AccountValues.CurrencyValue",
              "orderByType": "DESC",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          }
      ;
      final response=await userInfoTransactionDio.post('Transaction/getWalletBalance',data: options);
      print("request getListTransactionInfoList : $options" );
      print("response getListTransactionInfoList : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((transaction)=>ListTransactionInfoItemModel.fromJson(transaction)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<ListTransactionInfoModel> getListTransactionInfoListPager({
    required int startIndex,
    required int toIndex,
    required String name,
    List<int>? accountIds,
    int? filterType,
    String? orderBy,
    String? orderByType,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "transaction" :{
             "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(name!="")
                {
                  "fieldName": "accountName",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "AccountValues"
                },
                if(accountIds != null && accountIds.isNotEmpty && filterType != null)
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountIds.join(','),
                    "filterType": filterType,
                    "RefTable": "AccountValues"
                  }
              ]
            }
          ],
          "orderBy": orderBy ?? "AccountValues.CurrencyValueBes",
          "orderByType": orderByType ?? "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getWalletBalanceWrapper',data: options);
      print("request getListTransactionInfoListPager : $options" );
      print("response getListTransactionInfoListPager : ${response.data}" );
      return ListTransactionInfoModel.fromJson(response.data);

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ListTransactionInfoModel> getListTransactionInfoDateListPager({
    required int startIndex,
    required int toIndex,
    required String name,
    String? orderBy,
    String? orderByType,
    required String startDate,
    required String endDate
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(name!="")
                  {
                    "fieldName": "accountName",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "AccountValues"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  }
              ]
            }
          ],
          "orderBy": orderBy ?? "AV2.CurrencyValueBes",
          "orderByType": orderByType ?? "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getWalletBalanceDate',data: options);
      print("request getListTransactionInfoDateListPager : $options" );
      print("response getListTransactionInfoDateListPager : ${response.data}" );
      return ListTransactionInfoModel.fromJson(response.data);

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ListTransactionsWalletReceivablesModel> getTransactionsWalletReceivablesListPager({
    required int startIndex,
    required int toIndex,
    required String name,
    String? orderBy,
    String? orderByType,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(name!="")
                  {
                    "fieldName": "accountName",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "AccountValues"
                  }
              ]
            }
          ],
          "orderBy": orderBy ?? "CurrencyValue",
          "orderByType": orderByType ?? "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await userInfoTransactionDio.post('Transaction/getTransactionsWalletReceivablesWrapper',data: options);
      print("request getTransactionsWalletReceivablesListPager : $options" );
      print("response getTransactionsWalletReceivablesListPager : ${response.data}" );
      return ListTransactionsWalletReceivablesModel.fromJson(response.data);

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List<TransactionInfoFooterModel>> getTransactionInfoFooter({
    required int startIndex,
    required int toIndex,
    required String name,
    List<int>? accountIds,
    int? filterType,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(name!="")
                  {
                    "fieldName": "accountName",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "AccountValues"
                  },
                if(accountIds != null && accountIds.isNotEmpty && filterType != null)
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountIds.join(','),
                    "filterType": filterType,
                    "RefTable": "AccountValues"
                  }
              ]
            }
          ],
          "orderBy": "ABS(AccountValues.CurrencyValue)",
          "orderByType": "DESC",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      }
      ;
      final response=await userInfoTransactionDio.post('Transaction/getWalletBalanceFooter',data: options);
      print("request getTransactionInfoFooter : $options" );
      print("response getTransactionInfoFooter : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((transaction)=>TransactionInfoFooterModel.fromJson(transaction)).toList();

    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Uint8List> getUserInfoTransactionDetailExcel({
    int? accountId,
    required String startDate,
    required String endDate
}) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "transaction" :{
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
                    "RefTable": "at"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  }
              ]
            }
          ],
          "orderBy": "at.Date",
          "orderByType": "DESC",
          "StartIndex": 1,
          "ToIndex": 100000
        }}
      };
      final response=await userInfoTransactionDio.post(
          'Transaction/getExcel',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      print("request userInfoTransactionDetailExcel : $options" );
      print("response userInfoTransactionDetailExcel : ${response.data}" );
      return Uint8List.fromList(response.data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Uint8List> getGoldExcel({
    int? accountId,
    required String startDate,
    required String endDate
  }) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "transaction" :{
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
                    "RefTable": "at"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "at"
                  }
              ]
            }
          ],
          "orderBy": "at.Date DESC, at.Id",
          "orderByType": "DESC",
          "StartIndex": 1,
          "ToIndex": 100000
        }}
      };
      final response=await userInfoTransactionDio.post(
          'Transaction/getGoldExcel',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      print("request userInfoTransactionDetailExcel : $options" );
      print("response userInfoTransactionDetailExcel : ${response.data}" );
      return Uint8List.fromList(response.data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<Uint8List> getListUserInfoTransactionExcel({
    String? name,
    List<int>? accountIds,
    int? filterType,
}
) async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "transaction" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(name != null && name != "")
                  {
                    "fieldName": "AccountName",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "AccountValues"
                  },
                if(accountIds != null && accountIds.isNotEmpty && filterType != null)
                  {
                    "fieldName": "AccountId",
                    "filterValue": accountIds.join(','),
                    "filterType": filterType,
                    "RefTable": "AccountValues"
                  }
              ]
            }
          ],
          "orderBy": "CurrencyValueBes",
          "orderByType": "DESC",
          "StartIndex": 1,
          "ToIndex": 10000000
        }}
      };
      final response=await userInfoTransactionDio.post(
          'Transaction/getExcelWalletBalance',
          data: options,
          options: Options(responseType: ResponseType.bytes));
      print("request getListUserInfoTransactionExcel : $options" );
      print("response getListUserInfoTransactionExcel : ${response.data}" );
      return Uint8List.fromList(response.data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List< dynamic>> updateChecked(int id, bool checked)async{
    try{
      Map<String,dynamic> option={
        "checked": checked,
        "id": id,
      };
      print("request updateChecked : $option" );
      var response=await userInfoTransactionDio.put('Transaction/updateChecked',queryParameters: option);
      print("url : Transaction/updateChecked" );
      print('Status Code updateChecked: ${response.statusCode}');
      print('Response Data updateChecked: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در checked:$e');
    }
  }

  Future<List< dynamic>> removeCheckedAll(int accountId, bool checked)async{
    try{
      Map<String,dynamic> option={
        "checked": checked,
        "accountId": accountId,
      };
      print("request removeCheckedAll : $option" );
      var response=await userInfoTransactionDio.put('Transaction/updateAllChecked',queryParameters: option);
      print("url : Transaction/updateAllChecked" );
      print('Status Code removeCheckedAll: ${response.statusCode}');
      print('Response Data removeCheckedAll: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در checkedAll:$e');
    }
  }

  Future<List<CheckResultModel>> getCheckResult(int id)async{
    try{
      Map<String,dynamic> option={
        "id": id,
      };
      final response=await userInfoTransactionDio.get('Transaction/checkResult',queryParameters: option);
      print("url : Transaction/checkResult" );
      print("request getCheckResult : $option" );
      print("response getCheckResult : ${response.data}" );
      if(response.statusCode==200){
        final dynamic body = response.data;
        if (body == null) {
          return <CheckResultModel>[];
        }
        if (body is List) {
          return body.map((e) => CheckResultModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        if (body is Map<String, dynamic>) {
          return <CheckResultModel>[CheckResultModel.fromJson(body)];
        }
        return <CheckResultModel>[];
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ReportSettingModel> getOneReportSetting(String name)async{
    try{
      Map<String,dynamic> option={
        "name": name,
      };
      final response=await userInfoTransactionDio.get('ReportSetting/getOneByName',queryParameters: option);
      print("url : ReportSetting/getOneByName" );
      print("request getOneReportSetting : $option" );
      print("response getOneReportSetting : ${response.data}" );
      if(response.statusCode==200){
        Map<String, dynamic> data=response.data;
        return ReportSettingModel.fromJson(data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ReportSettingModel> updateReportSetting(ReportSettingModel reportSetting)async{
    try{
      Map<String, dynamic> data = {
        "name": reportSetting.name,
        "includes": reportSetting.includes?.map((clude) => {
          "id": clude.id,
          "name": clude.name,
        }).toList() ?? [],
        "excludes": reportSetting.excludes?.map((clude) => {
          "id": clude.id,
          "name": clude.name,
        }).toList() ?? [],
        "includeString": reportSetting.includeString ?? "",
        "excludeString": reportSetting.excludeString ?? "",
        "id": reportSetting.id,
        "infos": reportSetting.infos ?? [],
      };
      final response=await userInfoTransactionDio.put('ReportSetting/update',data: data);
      print("url : ReportSetting/update" );
      print("request updateReportSetting : $data" );
      print("response updateReportSetting : ${response.data}" );
      if(response.statusCode==200){
        Map<String, dynamic> responseData=response.data;
        return ReportSettingModel.fromJson(responseData);
      }else{
        throw ErrorException('خطا');
      }
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