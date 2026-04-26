import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/creditHelper/model/credit_helper.model.dart';
import 'package:hanigold_admin/src/domain/creditHelper/model/list_credit_helper.model.dart';
import '../../domain/creditHelper/model/credit_type.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class CreditHelperRepository {
  Dio creditHelperDio = Dio();

  CreditHelperRepository() {
    creditHelperDio.options.baseUrl = BaseUrl.baseUrl;
    creditHelperDio.interceptors.add(DioInterceptor());
  }

  Future<ListCreditHelperModel> getCreditHelperListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    int? type,
    int? itemId,
    String? accountName,
    required String startDate,
    required String endDate,
    required String amount,
    required bool isActive,
  })async{
    try{
      Map<String, dynamic> options =
      {
        "options" : { "creditHelper" :{
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(type != null)
                {
                  "fieldName": "Type",
                  "filterValue": "$type",
                  "filterType": 5,
                  "RefTable": "CreditHelper"
                },
                if(accountId != null)
                {
                  "fieldName": "AccountId",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "CreditHelper"
                },
                if(accountName != null)
                  {
                    "fieldName": "Name",
                    "filterValue": accountName,
                    "filterType": 0,
                    "RefTable": "Account"
                  },
                if(itemId != null)
                {
                  "fieldName": "ItemId",
                  "filterValue": "$itemId",
                  "filterType": 5,
                  "RefTable": "CreditHelper"
                },
                /*if(isActive)
                {
                  "fieldName": "IsActive",
                  "filterValue": "1",
                  "filterType": 5,
                  "RefTable": "CreditHelper"
                },*/
                if(amount!="")
                  {
                    "fieldName": "Amount",
                    "filterValue": amount,
                    "filterType": 0,
                    "RefTable": "CreditHelper"
                  },
                if(startDate!="")
                {
                  "fieldName": "StartDate",
                  "filterValue": startDate,
                  "filterType": 26,
                  "RefTable": "CreditHelper"
                },
                if(endDate!="")
                  {
                    "fieldName": "EndDate",
                    "filterValue": endDate,
                    "filterType": 26,
                    "RefTable": "CreditHelper"
                  },
              ]
            }
          ],
          "orderBy": "CreditHelper.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response=await creditHelperDio.post('CreditHelper/getWrapper',data: options);
      return ListCreditHelperModel.fromJson(response.data);
    }
    catch(e,s){
      AppLogger.e('getCreditHelperListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<CreditTypeModel>> getTypeCreditHelper() async{
    try{
      Map<String , dynamic> options= {
        "options" : { "creditType" :{
          "orderBy": "CreditType.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 1000000
        }}
      };
      final response=await creditHelperDio.post('CreditHelper/getType',data: options);
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((types)=>CreditTypeModel.fromJson(types)).toList();
      }
      else{
        throw ErrorException('خطا');
      }
    }
    catch(e,s){
      AppLogger.e('getTypeCreditHelper failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<CreditHelperModel> getOneCreditHelper(int id)async{
    try {
      final response = await creditHelperDio.get(
          'CreditHelper/getOne', queryParameters: {'id': id});
      Map<String, dynamic> data=response.data;
      return CreditHelperModel.fromJson(data);
    }catch(e,s){
      AppLogger.e('getOneCreditHelper failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> insertCreditHelper({
    required String? startDate,
    required String? endDate,
    required int accountId,
    required int type,
    required int itemId,
    required double amount,
    required String? description,
    required bool? isActive,
  })async{
    try{
      Map<String, dynamic> creditHelperData = {
        "account": {
          "id": accountId,
        },
        "item": {
          "id": itemId,
        },
        "type": type,
        "amount": amount,
        "startDate": startDate,
        "endDate": endDate,
        "isActive": isActive,
        "description": description,
      };

      var response=await creditHelperDio.post('CreditHelper/insert',data: creditHelperData);
      return response.data;
    }
    catch(e,s){
      AppLogger.e('insertCreditHelper failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> updateCreditHelper({
    required int id,
    required String? startDate,
    required String? endDate,
    required int accountId,
    required int type,
    required int itemId,
    required double amount,
    required String? description,
    required bool? isActive,
  })async{
    try{
      Map<String, dynamic> creditHelperData = {
        "id": id,
        "account": {
          "id": accountId,
        },
        "item": {
          "id": itemId,
        },
        "type": type,
        "amount": amount,
        "startDate": startDate,
        "endDate": endDate,
        "isActive": isActive,
        "description": description,
      };
      var response=await creditHelperDio.put('CreditHelper/update',data: creditHelperData );
      return response.data;
    }
    catch(e,s){
      AppLogger.e('updateCreditHelper failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> updateActiveCreditHelper({
    required bool isActive,
    required int id,
  })async{
    try{
      Map<String,dynamic> creditHelperData={
        "isActive": isActive,
        "id": id,
      };

      var response=await creditHelperDio.put('CreditHelper/updateActive',data: creditHelperData);
      return response.data;
    }
    catch(e,s){
      AppLogger.e('updateActiveCreditHelper failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> deleteCreditHelper({
    required bool isDeleted,
    required int id,
  })async{
    try{
      Map<String,dynamic> creditHelperData={
        "id": id,
        "isDeleted" : isDeleted,
      };


      var response=await creditHelperDio.delete('CreditHelper/updateToIsDeleted',data: creditHelperData);
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch(e,s){
      AppLogger.e('deleteCreditHelper failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}