

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/dio_Interceptor.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/role/model/element.model.dart';
import 'package:hanigold_admin/src/domain/role/model/element_getOne.model.dart';
import 'package:hanigold_admin/src/domain/role/model/role.model.dart';

import '../network/error/network.error.dart';

class RoleRepository{
  Dio roleDio=Dio();

  RoleRepository(){
    roleDio.options.baseUrl=BaseUrl.baseUrl;
    roleDio.interceptors.add(DioInterceptor());
  }

  Future<List<ElementModel>> getElementList()async{
    try{
      Map<String , dynamic> options= {
        "options" : { "element" :{
          "orderBy": "Element.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 10000
        }}
      };
      final response=await roleDio.post('Element/get',data: options);
      print("url : Element/get" );
      print("request getElementList : $options" );
      print("response getElementList : ${response.data}" );
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((elements)=>ElementModel.fromJson(elements)).toList();
      }
      else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ElementGetOneModel> getOneElement(int elementId)async{
    try {
      final response = await roleDio.get(
          'Element/getOne', queryParameters: {'id': elementId});
      print("url : Element/getOne" );
      print('Status Code getOneElement: ${response.statusCode}');
      print('Response Data getOneElement: ${response.data}');
      Map<String, dynamic> data=response.data;
      return ElementGetOneModel.fromJson(data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List<RoleModel>> getRoleList()async{
    try{
      Map<String , dynamic> options= {
        "options" : { "role" :{
          "orderBy": "Role.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 10000
        }}
      };
      final response=await roleDio.post('Role/get',data: options);
      print("url : Role/get" );
      print("request getRoleList : $options" );
      print("response getRoleList : ${response.data}" );
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((roles)=>RoleModel.fromJson(roles)).toList();
      }
      else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

}