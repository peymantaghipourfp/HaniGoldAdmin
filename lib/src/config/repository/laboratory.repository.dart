import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/laboratory/model/laboratory.model.dart';

class LaboratoryRepository {

  Dio laboratoryDio = Dio();

  LaboratoryRepository() {
    laboratoryDio.options.baseUrl = BaseUrl.baseUrl;
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
      final response = await laboratoryDio.post(
          'Laboratory/get', data: options);
      //print(response);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((laboratories) =>
            LaboratoryModel.fromJson(laboratories)).toList();
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e) {
      throw ErrorException('خطا:$e');
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
}