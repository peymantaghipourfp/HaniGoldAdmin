
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';

import '../../domain/users/model/list_user.model.dart';
import '../network/dio_Interceptor.dart';

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
      print("request getAccountList : $options" );
      print("response getAccountList : ${response.data}" );
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

  /*Future<List<AccountModel>> searchAccountList(AccountSearchReqModel? accountSearchReqModel)async{
    try{

      final response=await accountDio.post('Account/get',data: {'options':accountSearchReqModel});
      //print(response);
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
      print("response searchAccountList : ${response.data}" );
      print("request searchAccountList : $options" );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((account) => AccountModel.fromJson(account)).toList();
      } else {
        throw ErrorException('خطا در دریافت اطلاعات');
      }
    } catch (e) {
      throw ErrorException('خطا: $e');
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
      print("response searchAccountListNew : ${response.data}" );
      print("request searchAccountListNew : $options" );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((account) => AccountModel.fromJson(account)).toList();
      } else {
        throw ErrorException('خطا در دریافت اطلاعات');
      }
    } catch (e) {
      throw ErrorException('خطا: $e');
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
      print("response getCandidateChild : ${response.data}" );
      print("request getCandidateChild : $options" );
      if(response.statusCode==200){
        return ListUserModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
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
      print("request getChildList : $options" );
      print("response getChildList : ${response.data}" );
      if(response.statusCode==200){
        return ListUserModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<AccountModel> addChild({
    required List<AccountModel> status,
  }) async {
    try {
      final response = await accountDio.put('Account/addChilds', data: status.map((e)=>toJson(e)).toList() );
      print(response);
      return AccountModel.fromJson(response.data);
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  Future<AccountModel> removeChild({
    required List<AccountModel> status,
  }) async {
    try {
      final response = await accountDio.put('Account/removeChilds', data: status.map((e)=>toJson(e)).toList() );
      print(response);
      return AccountModel.fromJson(response.data);
    } catch (e) {
      throw ErrorException('خطا:$e');
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