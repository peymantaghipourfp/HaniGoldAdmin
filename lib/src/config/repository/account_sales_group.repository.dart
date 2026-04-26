
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/account/model/account.model.dart';
import '../../domain/accountSalesGroup/model/account_sales_group.model.dart';
import '../../domain/accountSalesGroup/model/account_sales_group_get_one_item.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class AccountSalesGroupRepository{
  Dio accountSalesGroupDio=Dio();

  AccountSalesGroupRepository(){
    accountSalesGroupDio.options.baseUrl=BaseUrl.baseUrl;
    accountSalesGroupDio.options.connectTimeout=Duration(seconds: 30);
    accountSalesGroupDio.interceptors.add(DioInterceptor());
  }

  Future<List<AccountSalesGroupModel>> getAccountSalesGroupList() async{
    try{
      Map<String, dynamic> options = {
        "options": {"accountSalesGroup": {
            "orderBy": "AccountSalesgroup.Id",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 1000000
          }
        }
      };
      final response=await accountSalesGroupDio.post('AccountSalesGroup/get',data: options);
      List<dynamic> data=response.data;
      return data.map((accountSalesGroup) => AccountSalesGroupModel.fromJson(accountSalesGroup)).toList();

    }catch(e, s){
      AppLogger.e('getAccountSalesGroupList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountSalesGroupModel> getOneAccountSalesGroup({
    required int accountSalesGroupId,
  }) async {
    try {
      final response = await accountSalesGroupDio.get(
        'AccountSalesGroup/getOne',
        queryParameters: {'id': accountSalesGroupId},
      );

      Map<String, dynamic> data = response.data;
      return AccountSalesGroupModel.fromJson(data);
    } catch (e,s) {
      AppLogger.e('خطا در دریافت جزئیات زیر گروه قیمت گذاری:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> deleteAccountSalesGroup({
    required bool isDeleted,
    required int accountSalesGroupId,
  })async{
    try{
      Map<String,dynamic> accountSalesGroupData={
        "id": accountSalesGroupId,
        "isDeleted" : isDeleted,
      };

      var response=await accountSalesGroupDio.delete('AccountSalesGroup/delete',data: accountSalesGroupData);
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch(e,s){
      AppLogger.e('خطا در حذف:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> insertAccountSalesGroup({
    required String name,
    required List<Map<String, dynamic>> itemPrices,
  }) async {
    try {
      List<Map<String, dynamic>> cleanItemPrices = itemPrices.map((itemPrice) {
        Map<String, dynamic> cleanItem = {};
        if (itemPrice.containsKey('itemId')) {
          cleanItem['itemId'] = itemPrice['itemId'];
        }
        if (itemPrice.containsKey('buyRange')) {
          cleanItem['buyRange'] = itemPrice['buyRange'];
        }
        if (itemPrice.containsKey('salesRange')) {
          cleanItem['salesRange'] = itemPrice['salesRange'];
        }
        if (itemPrice.containsKey('sellStatus')) {
          cleanItem['sellStatus'] = itemPrice['sellStatus'];
        }
        if (itemPrice.containsKey('buyStatus')) {
          cleanItem['buyStatus'] = itemPrice['buyStatus'];
        }
       /* if (itemPrice.containsKey('maxBuy')) {
          cleanItem['maxBuy'] = itemPrice['maxBuy'];
        }
        if (itemPrice.containsKey('maxSell')) {
          cleanItem['maxSell'] = itemPrice['maxSell'];
        }*/
        return cleanItem;
      }).toList();

      Map<String, dynamic> accountSalesGroupData = {
        "account": {
          "accountGroup": {
            "infos": []
          },
          "accountSalesGroup": {
            "infos": []
          },
          "infos": []
        },
        "name": name,
        /*"hasDeposit": null,
        "deposit": null,
        "hasBalance": null,
        "balance": null,
        "color": null,
        "rowNum": null,
        "id": null,
        "attribute": null,
        "recId": null,
        "infos": [],*/
        "accountSalesGroupItems": cleanItemPrices,
      };
      var response = await accountSalesGroupDio.post('AccountSalesGroup/insert', data: accountSalesGroupData);
        return response.data;
    } catch (e,s) {
      AppLogger.e('خطا در ایجاد زیر گروه قیمت گذاری:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateAccountSalesGroup({
    required int accountSalesGroupId,
    String? name,
    List<Map<String, dynamic>>? itemPrices,
  }) async {
    try {
      final Map<String, dynamic> accountSalesGroupData = {
        'name': name,
        'id': accountSalesGroupId,
        'accountSalesGroupItems': itemPrices,
      };

      var response = await accountSalesGroupDio.put('AccountSalesGroup/update', data: accountSalesGroupData);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'data': response.data};
    } catch (e,s) {
      AppLogger.e('خطا در ویرایش زیر گروه قیمت گذاری:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<AccountModel>> getAccountListForSalesGroup({
    String? accountSalesGroupId,
    String? name,
})async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "account" :{
            "Predicate":[
              {
                "innerCondition": 1,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "AccountSalesGroupId",
                    "filterValue": "",
                    "filterType": 20,
                    "RefTable": "Account"
                  },
                  if (accountSalesGroupId != null && accountSalesGroupId.isNotEmpty)
                  {
                    "fieldName": "AccountSalesGroupId",
                    "filterValue": accountSalesGroupId,
                    "filterType": 5,
                    "RefTable": "Account"
                  }
                ]
              },
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  if (name != null && name.isNotEmpty)
                  {
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Account"
                  }
                ]
              }
            ],
            "orderBy": "Account.StartDate",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 100000
          }
        }
      };
      final response=await accountSalesGroupDio.post('Account/get',data: options);
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((account)=>AccountModel.fromJson(account)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e,s){
      AppLogger.e('getAccountListForSalesGroup failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<AccountModel>> getAssignedAccountsForSalesGroup({
    required String accountSalesGroupId,
    String name = '',
  }) async {
    if (accountSalesGroupId.isEmpty) {
      return <AccountModel>[];
    }
    try {
      Map<String, dynamic> options = {
        "options": {
          "account": {
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "AccountSalesGroupId",
                    "filterValue": accountSalesGroupId,
                    "filterType": 5,
                    "RefTable": "Account"
                  },
                  if (name.isNotEmpty)
                    {
                      "fieldName": "Name",
                      "filterValue": name,
                      "filterType": 0,
                      "RefTable": "Account"
                    }
                ]
              }
            ],
            "orderBy": "Account.StartDate",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 100000
          }
        }
      };
      final response = await accountSalesGroupDio.post('Account/get', data: options);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((account) => AccountModel.fromJson(account)).toList();
      } else {
        throw ErrorException('خطا');
      }
    } catch (e,s) {
      AppLogger.e('getAssignedAccountsForSalesGroup failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateAssignedAccountsForSalesGroup({
    required int accountSalesGroupId,
    required List<Map<String, dynamic>> accounts,
  }) async {
    try {
      // if (accounts.isEmpty) {
      //   throw ArgumentError('لیست حساب‌ها نباید خالی باشد');
      // }

      final List<Map<String, dynamic>> sanitizedAccounts =
      accounts.map((rawAccount) {
        final sanitizedAccount = Map<String, dynamic>.from(rawAccount);
        sanitizedAccount.removeWhere((key, value) => value == null);
        return sanitizedAccount;
      }).toList();

      final Map<String, dynamic> data = {
        'accounts': sanitizedAccounts,
        'accountSalesGroupId': accountSalesGroupId,
      };
      final response = await accountSalesGroupDio.put('AccountSalesGroup/assignment', data: data);

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'data': response.data};
    } catch (e,s) {
      AppLogger.e('خطا در به‌روزرسانی حساب‌های زیر گروه قیمت گذاری:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountSalesGroupGetOneItemModel> accountSalesGroupGetOneItem({
    required int accountId,
    required int itemId,
  }) async {
    try {
      final response = await accountSalesGroupDio.get(
        'AccountSalesGroup/getOneByAccount',
        queryParameters: {'accountId': accountId , 'itemId': itemId},
      );

      Map<String, dynamic> data = response.data;
      return AccountSalesGroupGetOneItemModel.fromJson(data);
    } catch (e,s) {
      AppLogger.e('خطا در دریافت یک گروه قیمت گذاری برای یک آیتم:', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}