import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance_request.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';

import '../../domain/remittance/model/image_guid_model.dart';
import 'dart:typed_data';

import '../network/dio_Interceptor.dart';

class RemittanceRequestRepository{

  Dio remittanceRequestDio=Dio();
  RemittanceRequestRepository(){
    remittanceRequestDio.options.baseUrl=BaseUrl.baseUrl;
    remittanceRequestDio.interceptors.add(DioInterceptor());
  }




  Future<ListRemittanceRequestModel> getRemittanceRequestListPager({
    required int startIndex,
    required int toIndex,
    required String startDate,
    required String endDate,
    int? accountId,
    required String name,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "remittancerequest" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                  {
                    "fieldName": "Id",
                    "filterValue": accountId.toString(),
                    "filterType": 5,
                    "RefTable": "Account"
                  },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "RemittanceRequest"
                  },
                if(name!="")
                  {
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Account"
                  },
              ],
            }
          ],
          "orderBy": "remittancerequest.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await remittanceRequestDio.post('RemittanceRequest/getWrapper',data: options);
      print("url getRemittanceRequestListPager : RemittanceRequest/getWrapper" );
      print("request getRemittanceRequestListPager : $options" );
      print("response getRemittanceRequestListPager : ${response.data}" );
      if(response.statusCode==200){
        return ListRemittanceRequestModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<List< dynamic>> deleteRemittanceRequest({
    required bool isDeleted,
    required int remittanceRequestId,
  })async{
    try{
      Map<String,dynamic> remittanceRequestData={
        "id": remittanceRequestId,
        "isDeleted" : isDeleted,
      };

      print(remittanceRequestData);

      var response=await remittanceRequestDio.delete('RemittanceRequest/UpdateToIsDeleted',data: remittanceRequestData);
      print('Status Code deleteRemittanceRequest: ${response.statusCode}');
      print('Response Data deleteRemittanceRequest: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

  Future<Map<String , dynamic>> updateStatusRemittanceRequest({
    required int status,
    required int remittanceRequestId,
    int? reasonRejectionId,
  })async{
    try{
      Map<String,dynamic> remittanceRequestData={

        "status": status,
        if (reasonRejectionId != null) "reasonRejection":{
          "id": reasonRejectionId,
        },
        "id": remittanceRequestId,

      };
      print(remittanceRequestData);

      var response=await remittanceRequestDio.put('RemittanceRequest/updateStatus',data: remittanceRequestData);
      print('Status Code updateStatusRemittanceRequest: ${response.statusCode}');
      print('Response Data updateStatusRemittanceRequest: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
    }
  }
}