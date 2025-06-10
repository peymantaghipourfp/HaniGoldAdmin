import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/laboratory/model/laboratory.model.dart';
import '../../domain/laboratory/model/list_laboratory.model.dart';

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
      final response = await laboratoryDio.post('Laboratory/get', data: options);
      print("request getLaboratoryList : $options" );
      print("response getLaboratoryList : ${response.data}" );
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
      print("request getLaboratoryListPager : $options" );
      print("response getLaboratoryListPager : ${response.data}" );
      if (response.statusCode == 200) {
        return
          ListLaboratoryModel.fromJson(response.data);
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
      print(options);
      final response = await laboratoryDio.post('Laboratory/insert', data: options);
      print('Status Code insertLaboratory: ${response.statusCode}');
      print('Response Data insertLaboratory: ${response.data}');
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
      print(options);
      final response = await laboratoryDio.put('Laboratory/update', data: options);
      print('Status Code updateLaboratory: ${response.statusCode}');
      print('Response Data updateLaboratory: ${response.data}');
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

}