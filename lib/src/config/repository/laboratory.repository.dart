import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/laboratory/model/laboratory.model.dart';
import '../../domain/laboratory/model/list_laboratory.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class LaboratoryRepository {

  Dio laboratoryDio = Dio();

  LaboratoryRepository() {
    laboratoryDio.options.baseUrl = BaseUrl.baseUrl;
    laboratoryDio.interceptors.add(DioInterceptor());
  }

  Future<List<LaboratoryModel>> getLaboratoryList() async {
    try {
      Map<String, dynamic> options = {
        "options": { "laboratory": {
          "orderBy": "laboratory.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 10000
        }}
      };
      final response = await laboratoryDio.post('Laboratory/get', data: options);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((laboratories) =>
            LaboratoryModel.fromJson(laboratories)).toList();
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getLaboratoryList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListLaboratoryModel> getLaboratoryListPager({required int startIndex, required int toIndex,required String name}) async {
    try {
      Map<String, dynamic> options =
          name != "" ?
      {
        "options": { "laboratory": {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                  {
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Laboratory"
                  },
              ]
            }
          ],
          "orderBy": "laboratory.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      } :
          {
            "options": { "laboratory": {
              "orderBy": "laboratory.Id",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          };
      final response = await laboratoryDio.post('Laboratory/getWrapper', data: options);
      if (response.statusCode == 200) {
        return
          ListLaboratoryModel.fromJson(response.data);
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('getLaboratoryListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<LaboratoryModel>> searchLaboratoryList(String name) async {
    try {
      Map<String, dynamic> options = {
        "options": {
          "laboratory": {
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Name",
                    "filterValue": name,
                    "filterType": 0,
                    "RefTable": "Laboratory"
                  }
                ]
              }
            ],
            "orderBy": "Laboratory.Id",
            "orderByType": "desc",
            "StartIndex": 1,
            "ToIndex": 1000000
          }
        }
      };

      final response = await laboratoryDio.post('Laboratory/get', data: options);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((laboratory) => LaboratoryModel.fromJson(laboratory)).toList();
      } else {
        throw ErrorException('خطا در دریافت اطلاعات');
      }
    } catch (e) {
      throw ErrorException('خطا: $e');
    }
  }



  Future<LaboratoryModel> insertLaboratory({required String name, required String phone,required String address,required String createdOn}) async {

    try {
      Map<String, dynamic> options = {
          "name": name,
          "Phone": phone,
          "Address": address,
          "rowNum": 1,
          "attribute": "cus",
          "recId": null,
      };
      final response = await laboratoryDio.post('Laboratory/insert', data: options);
      if (response.statusCode == 200) {
        return
          LaboratoryModel.fromJson(response.data);
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e) {
      throw ErrorException('خطا:$e');
    }
  }



  Future<LaboratoryModel> updateLaboratory({required String name, required String phone,required String address,required int id}) async {
    try {
      Map<String, dynamic> options = {
          "name": name,
          "Phone": phone,
          "Address": address,
          "rowNum": 1,
          "id": id,
          "attribute": "cus",
          "recId": null,
      };
      final response = await laboratoryDio.put('Laboratory/update', data: options);
      if (response.statusCode == 200) {
        return
          LaboratoryModel.fromJson(response.data);
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  Future<List<dynamic>> deleteLaboratory({
    required int laboratoryId
  })async{
    try{
      Map<String,dynamic> laboratoryData={
        "id": laboratoryId,
      };

      var response=await laboratoryDio.delete('Laboratory/Delete',data: laboratoryData);
      if (response.data is List) {
        return response.data;
      } else {
        return [response.data];
      }
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

}