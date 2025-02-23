
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';

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
}