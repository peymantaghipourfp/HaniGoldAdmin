
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level_get_one_item.model.dart';
import 'package:hanigold_admin/src/domain/account/model/social.model.dart';

import '../../domain/users/model/list_user.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class AccountRepository{

  Dio accountDio=Dio();
  AccountRepository(){
    accountDio.options.baseUrl=BaseUrl.baseUrl;
    accountDio.interceptors.add(DioInterceptor());
  }

  Future<List<AccountModel>> getAccountList(String status)async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "account" :{
            "Predicate": status!="" ? [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Status",
                    "filterValue": status,
                    "filterType": 4,
                    "RefTable": "Account"
                  }
                ]
              }
            ] : [],
          "orderBy": "Account.StartDate",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 100000
        }
        }
      };
      final response=await accountDio.post('Account/get',data: options);
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((account)=>AccountModel.fromJson(account)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getAccountList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  /*Future<List<AccountModel>> searchAccountList(AccountSearchReqModel? accountSearchReqModel)async{
    try{

      final response=await accountDio.post('Account/get',data: {'options':accountSearchReqModel});
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
  }*/
  Future<List<AccountModel>> searchAccountList(String name,String status) async {
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
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Account"
                  },
                  if(status!="")
                  {
                    "fieldName": "Status",
                    "filterValue": status,
                    "filterType": 4,
                    "RefTable": "Account"
                  }
                ]
              }
            ],
            "orderBy": "Account.StartDate",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 1000000
          }
        }
      };

      final response = await accountDio.post('Account/get', data: options);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((account) => AccountModel.fromJson(account)).toList();
      } else {
        throw ErrorException('خطا در دریافت اطلاعات');
      }
    } catch (e, s) {
      AppLogger.e('searchAccountList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<AccountModel>> searchAccountListNew(String name,String status) async {
    try {
      Map<String, dynamic> options =name!=""? {
        "options": {
          "account": {
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Account"
                  },
                  if(status!="")
                  {
                    "fieldName": "Status",
                    "filterValue": status,
                    "filterType": 4,
                    "RefTable": "Account"
                  }
                ]
              }
            ],
            "orderBy": "Account.StartDate",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 1000000
          }
        }
      }:{
        "options" : {
          "account" :{
            "orderBy": "Account.StartDate",
            "orderByType": "asc",
            "StartIndex": 1,
            "ToIndex": 100000
          }
        }
      };

      final response = await accountDio.post('Account/get', data: options);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((account) => AccountModel.fromJson(account)).toList();
      } else {
        throw ErrorException('خطا در دریافت اطلاعات');
      }
    } catch (e, s) {
      AppLogger.e('searchAccountListNew failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<AccountLevelModel>> getAccountLevelList() async{
    try{
      Map<String, dynamic> options = {
        "options": {"accountLevel": {
          "orderBy": "AccountLevel.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 1000000
        }
        }
      };
      final response=await accountDio.post('AccountLevel/get',data: options);
      List<dynamic> data=response.data;
      return data.map((accountLevel) => AccountLevelModel.fromJson(accountLevel)).toList();

    }catch (e, s) {
      AppLogger.e('getAccountLevelList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountLevelModel> getOneAccountLevel({
    required int accountLevelId,
  }) async {
    try {
      final response = await accountDio.get(
        'AccountLevel/getOne',
        queryParameters: {'id': accountLevelId},
      );

      Map<String, dynamic> data = response.data;
      return AccountLevelModel.fromJson(data);
    }catch (e, s) {
      AppLogger.e('getOneAccountLevel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateAccountLevel({
    required int accountLevelId,
    String? name,
    required double balance,
    required double positiveGold,
    required double negativeGold,
    List<Map<String, dynamic>>? accountLevelItems,
  }) async {
    try {
      final Map<String, dynamic> accountLevelData = {
        "balance": balance,
        "positiveGold": positiveGold,
        "negativeGold": negativeGold,
        'name': name,
        'id': accountLevelId,
        'accountLevelItems': accountLevelItems,
      };

      var response = await accountDio.put('AccountLevel/update', data: accountLevelData);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'data': response.data};
    } catch (e, s) {
      AppLogger.e('updateAccountLevel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountLevelGetOneItemModel> accountLevelGetOneItem({
    required int accountId,
    required int itemId,
  }) async {
    try {
      final response = await accountDio.get(
        'AccountLevel/getOneByAccount',
        queryParameters: {'accountId': accountId , 'itemId': itemId},
      );

      Map<String, dynamic> data = response.data;
      return AccountLevelGetOneItemModel.fromJson(data);
    } catch (e, s) {
      AppLogger.e('accountLevelGetOneItem failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<ListUserModel> getCandidateChild(String parentId,int startIndex,String name,
      int toIndex,)async{
    try{
      Map<String, dynamic> options = name != ""
          ? {
        "options": {
          "account": {
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  name != ""
                      ? {
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Account"
                  }
                      : []
                ]
              }
            ],
            "orderBy": "Account.Name",
            "orderByType": "desc",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      }
          : {
        "options": {
          "account": {
            "orderBy": "Account.StartDate",
            "orderByType": "DESC",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      };
      final response=await accountDio.post('Account/getCandidateChild',data: options);
      if(response.statusCode==200){
        return ListUserModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getCandidateChild failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListUserModel> getChildList(String parentId,  int startIndex,
   int toIndex,)async{
    try{
      Map<String , dynamic> options=
      {"options" : { "account" :{
        "Predicate": [
          {
            "innerCondition": 1,
            "outerCondition": 0,
            "filters": [
              {
                "fieldName": "ParentId",
                "filterValue": parentId,
                "filterType": 5,
                "RefTable": "Account"
              }
            ]
          }

        ],
        "orderBy": "Account.StartDate",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
      }}};
      final response=await accountDio.post('Account/getWrapper',data: options);
      if(response.statusCode==200){
        return ListUserModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getChildList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> addChild({
    required List<AccountModel> status,
  }) async {
    try {
      final response = await accountDio.put('Account/addChilds', data: status.map((e)=>toJson(e)).toList() );
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('addChild failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> removeChild({
    required List<AccountModel> status,
  }) async {
    try {
      final response = await accountDio.put('Account/removeChilds', data: status.map((e)=>toJson(e)).toList() );
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('removeChild failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<SocialModel> checkSocialStatus({
    required int accountId,
  })async{
    try {
      final response = await accountDio.get('Account/checkSocialStatus', queryParameters: {'id': accountId});
      return SocialModel.fromJson(response.data);
    }catch (e, s) {
      AppLogger.e('checkSocialStatus failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}


 Map<String, dynamic> toJson(AccountModel instance) =>
    <String, dynamic>{
      'parent':  <String, dynamic>{
        'id': instance.parent?.id,
      },
      'id': instance.id,
    };