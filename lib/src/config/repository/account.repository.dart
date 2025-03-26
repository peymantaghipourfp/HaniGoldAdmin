
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';

class AccountRepository{

  Dio accountDio=Dio();
  AccountRepository(){
    accountDio.options.baseUrl=BaseUrl.baseUrl;
  }
  Future<List<AccountModel>> getAccountList()async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "account" :{
          "orderBy": "Account.Name",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 100
        }
        }
      };
      final response=await accountDio.post('Account/get',data: options);
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
  Future<List<AccountModel>> searchAccountList(String name) async {
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
                  }
                ]
              }
            ],
            "orderBy": "Account.Name",
            "orderByType": "asc",
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
    } catch (e) {
      throw ErrorException('خطا: $e');
    }
  }
}