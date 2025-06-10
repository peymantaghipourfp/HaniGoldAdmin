

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/auth/model/user_login.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';

import '../network/error/network.error.dart';

class AuthRepository{
  Dio authDio=Dio();

  AuthRepository(){
    authDio.options.baseUrl=BaseUrl.baseUrl;

  }
  Future<UserLoginModel> login(String mobile,String password)async{
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
      return UserLoginModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<dynamic> forgetPasswordMobile(String mobile)async{
    try{
      Map<String , dynamic> options={
          "user": {
            "MobileNumber" : mobile
          }
      };
      final response=await authDio.post('Login/mobileVerificationForgetPassword',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      return jsonEncode(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
Future<UserLoginModel> forgetPasswordVerify(String mobile,String code)async{
    try{
      Map<String , dynamic> options={
        "VerificationCode" : code,
        "user": {
          "MobileNumber" : mobile
        }
      };
      final response=await authDio.post('Login/checkVerificationForgetPassword',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      return UserLoginModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<UserLoginModel> changePassword(String mobile,String password,String oldPassword,int id)async{
    try{
      Map<String , dynamic> options={
        "password" : password,
        "RetypePassword" : password,
        "OldPassword" : oldPassword,
        "user": {
          "MobileNumber" : mobile,
          "id" : id
        }
      };
      final response=await authDio.post('Login/changePassword',data: options);
      print("request : $options" );
      print("response : ${response.data}" );
      return UserLoginModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


}