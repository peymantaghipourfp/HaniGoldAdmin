
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/account/model/account.model.dart';
import '../../domain/accountSalesGroup/model/account_sales_group.model.dart';
import '../../domain/accountSalesGroup/model/account_sales_group_get_one_item.model.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';

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
      print("request getAccountSalesGroupList : $options" );
      print("response getAccountSalesGroupList : ${response.data}" );
      List<dynamic> data=response.data;
      return data.map((accountSalesGroup) => AccountSalesGroupModel.fromJson(accountSalesGroup)).toList();

    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<AccountSalesGroupModel> getOneAccountSalesGroup({
    required int accountSalesGroupId,
  }) async {
    try {
      print("Request getOneAccountSalesGroup - accountSalesGroupId: $accountSalesGroupId");
      final response = await accountSalesGroupDio.get(
        'AccountSalesGroup/getOne',
        queryParameters: {'id': accountSalesGroupId},
      );
      print("url getOneAccountSalesGroup : AccountSalesGroup/getOne");
      print('Status Code getOneAccountSalesGroup: ${response.statusCode}');
      print('Response Data getOneAccountSalesGroup: ${response.data}');

      Map<String, dynamic> data = response.data;
      return AccountSalesGroupModel.fromJson(data);
    } catch (e) {
      throw ErrorException('خطا در دریافت جزئیات زیر گروه قیمت گذاری: $e');
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
      print("url deleteAccountSalesGroup : AccountSalesGroup/delete" );
      print('request deleteAccountSalesGroup: $accountSalesGroupData');
      print('Status Code deleteAccountSalesGroup: ${response.statusCode}');
      print('Response Data deleteAccountSalesGroup: ${response.data}');
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
      print("Request data insertAccountSalesGroup: $accountSalesGroupData");
      var response = await accountSalesGroupDio.post('AccountSalesGroup/insert', data: accountSalesGroupData);
      print("url insertAccountSalesGroup : AccountSalesGroup/insert");
      print('Status Code insertAccountSalesGroup: ${response.statusCode}');
      print('Response Data insertAccountSalesGroup: ${response.data}');
        return response.data;
    } catch (e) {
      throw ErrorException('خطا در ایجاد زیر گروه قیمت گذاری: $e');
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
      print("url updateAccountSalesGroup : AccountSalesGroup/update");
      print('request updateAccountSalesGroup: $accountSalesGroupData');
      print('Status Code updateAccountSalesGroup: ${response.statusCode}');
      print('Response Data updateAccountSalesGroup: ${response.data}');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'data': response.data};
    } catch (e) {
      throw ErrorException('خطا در ویرایش زیر گروه قیمت گذاری: $e');
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
                    "filterValue": accountSalesGroupId ?? "1",
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
      print("request getAccountListForSalesGroup : $options" );
      final response=await accountSalesGroupDio.post('Account/get',data: options);
      print("request getAccountListForSalesGroup : $options" );
      print("response getAccountListForSalesGroup : ${response.data}" );
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((account)=>AccountModel.fromJson(account)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
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
      print("request getAssignedAccountsForSalesGroup : $options");
      print("response getAssignedAccountsForSalesGroup : ${response.data}");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((account) => AccountModel.fromJson(account)).toList();
      } else {
        throw ErrorException('خطا');
      }
    } catch (e) {
      throw ErrorException('خطا:$e');
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
      print("url : AccountSalesGroup/assignment");
      print("request updateAssignedAccountsForSalesGroup : $data");
      print("response updateAssignedAccountsForSalesGroup : ${response.data}");

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'data': response.data};
    } catch (e) {
      throw ErrorException('خطا در به‌روزرسانی حساب‌های زیر گروه قیمت گذاری: $e');
    }
  }

  Future<AccountSalesGroupGetOneItemModel> accountSalesGroupGetOneItem({
    required int accountId,
    required int itemId,
  }) async {
    try {
      print("Request accountSalesGroupGetOneItem - accountId: $accountId - itemId: $itemId");
      final response = await accountSalesGroupDio.get(
        'AccountSalesGroup/getOneByAccount',
        queryParameters: {'accountId': accountId , 'itemId': itemId},
      );
      print("url accountSalesGroupGetOneItem : AccountSalesGroup/getOneByAccount");
      print('Status Code accountSalesGroupGetOneItem: ${response.statusCode}');
      print('Response Data accountSalesGroupGetOneItem: ${response.data}');

      Map<String, dynamic> data = response.data;
      return AccountSalesGroupGetOneItemModel.fromJson(data);
    } catch (e) {
      throw ErrorException('خطا در دریافت یک گروه قیمت گذاری برای یک آیتم: $e');
    }
  }

}