

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/auth/model/user_login.model.dart';

import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';

class AuthRepository{
  Dio authDio=Dio();
  Dio authDioWithInterceptor = Dio();

  AuthRepository(){
    authDio.options.baseUrl=BaseUrl.baseUrl;
    authDioWithInterceptor.options.baseUrl = BaseUrl.baseUrl;
    authDioWithInterceptor.interceptors.add(DioInterceptor());
  }
  Future<UserLoginModel> login(String mobile,String password)async{
    try{
      Map<String , dynamic> options={
          "password" : password,
          "user": {
            "MobileNumber" : mobile
          }
      };
      final response=await authDio.post('Login/LoginAdmin',data: options,options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),);
      print("request login : $options" );
      print("response login : ${response.data}" );
      print("responseHeaderF login : ${response.headers.value('Authorization')}" );

      UserLoginModel userLoginModel = UserLoginModel.fromJson(response.data);

      if (userLoginModel.token == null) {
        final token = response.headers.value('Authorization');
        if (token != null && token.isNotEmpty) {
          if (token.toLowerCase().startsWith('bearer ')) {
            userLoginModel.token = token.substring(7);
          } else {
            userLoginModel.token = token;
          }
        }
      }
      final box = GetStorage();
      box.write('token', userLoginModel.token);
      return userLoginModel;
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
Future<Map<String , dynamic>> forgetPasswordVerify(String mobile,String code)async{
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
      return response.data;
      //return UserLoginModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<Map<String , dynamic>> changePassword(String mobile,String password,String oldPassword,int id)async{
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
      final response = await authDioWithInterceptor.post('Login/changePassword', data: options);
      print("request : $options");
      print("response : ${response.data}");
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


}