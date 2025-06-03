

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/auth/model/user.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';

import '../network/error/network.error.dart';

class AuthRepository{
  Dio authDio=Dio();

  AuthRepository(){
    authDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<UserModel> login(String mobile,String password)async{
    try{
      Map<String , dynamic> options={
          "password" : password,
          "user": {
            "MobileNumber" : mobile
          }
      };
      final response=await authDio.post('Login/LoginAdmin',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      return UserModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
  Future<UserModel> changePassword(String mobile,String password,String oldPassword,)async{
    try{
      Map<String , dynamic> options={
        "password" : password,
        "RetypePassword" : password,
        "OldPassword" : oldPassword,
        "user": {
          "MobileNumber" : mobile
        }
      };
      final response=await authDio.post('Login/changePassword',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      return UserModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


}