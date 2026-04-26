
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance_request.model.dart';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

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
      if(response.statusCode==200){
        return ListRemittanceRequestModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getRemittanceRequestListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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


      var response=await remittanceRequestDio.delete('RemittanceRequest/UpdateToIsDeleted',data: remittanceRequestData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('deleteRemittanceRequest failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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

      var response=await remittanceRequestDio.put('RemittanceRequest/updateStatus',data: remittanceRequestData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('updateStatusRemittanceRequest failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}