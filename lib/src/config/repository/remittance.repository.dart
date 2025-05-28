
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/list_remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';

import '../../domain/remittance/model/image_guid_model.dart';

class RemittanceRepository{

  Dio remittanceDio=Dio();
  RemittanceRepository(){
    remittanceDio.options.baseUrl=BaseUrl.baseUrl;
  }
  Future<List<RemittanceModel>> getRemittanceList({required String startDate,
    required String endDate,})async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "remittance" :{
            "Predicate": startDate!=""?  [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Remittance"
                  }
                ]
              }
            ]:[],
          "orderBy": "Remittance.Id",
          "orderByType": "desc",
          "StartIndex": 1,
          "ToIndex": 10000
        }
        }
      };
      final response=await remittanceDio.post('Remittance/get',data: options);
      // print("url : Remittance/get" );
      // print("request : $options" );
      // print("response : ${response.data}" );
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((account)=>RemittanceModel.fromJson(account)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
 Future<ImageGuidModel> getImage({required String fileName,
    required String type,})async{
    try{
      Map<String , dynamic> options={
       "fileName":fileName,
       "type":type
      };
      final response=await remittanceDio.get('Attachment/downloadAttachmentGuidList',queryParameters: options);
      print("url : Attachment/downloadAttachmentGuidList" );
      print("request : $options" );
      print("response : ${response.data}" );
        return ImageGuidModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<ListRemittanceModel> getRemittanceListPager({
    required int startIndex,
    required int toIndex,
    required String startDate,
    required String endDate,
  })async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "remittance" :{
           "Predicate": startDate!=""?  [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Remittance"
                  }
                ]
              }
            ]:[],
          "orderBy": "Remittance.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await remittanceDio.post('Remittance/getWrapper',data: options);
      print("url : Remittance/get" );
      print("request : $options" );
      print("response : ${response.data}" );
      if(response.statusCode==200){
        return ListRemittanceModel.fromJson(response.data);
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
  Future<RemittanceModel> insertRemittance({
    required String date,
    required int accountIdPayer,
    required String accountNamePayer,
    required int accountIdReciept,
    required String accountNameReciept,
    required String recId,
    required int itemId,
    required double quantity,
    required String? description,
  })async{
    try{
      Map<String, dynamic> orderData =
        {
          "date": date,
          "walletPayer": {
            "address": null,
            "account": {
              "name": accountNamePayer,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdPayer,
              "infos": []
            },
            "item": {
              "itemGroup": {
                "infos": []
              },
              "itemUnit": {
                "infos": []
              },
              "infos": []
            },
            "id": null,
            "infos": []
          },
          "walletReciept": {
            "address": null,
            "account": {
              "name": accountNameReciept,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdReciept,
              "infos": []
            },
            "item": {
              "itemGroup": {
                "infos": []
              },
              "itemUnit": {
                "infos": []
              },
              "infos": []
            },
            "id": null,
            "infos": []
          },
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "name": null,
              "id": null,
              "infos": []
            },
            "name": "طلای آبشده",
            "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
            "id": itemId,
            "infos": []
          },
          "quantity": quantity,
          "status": 1,
          "isDeleted": false,
          "rowNum": 1,
          "id": 1,
          "recId": recId,
          "attribute": "cus",
          "description": description,
          "infos": []

      };

      var response=await remittanceDio.post('Remittance/insert',data: orderData);
      /*if(response.statusCode==200){
        print('ثبت با موفقیت انجام شد');
      }else{
        throw ErrorException('خطا');
      }*/
      return RemittanceModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<RemittanceModel> updateRemittance({
    required String date,
    required int accountIdPayer,
    required String accountNamePayer,
    required int accountIdReciept,
    required String accountNameReciept,
    required String recId,
    required int itemId,
    required int id,
    required double quantity,
    required String? description,
  })async{
    try{
      Map<String, dynamic> orderData =
        {
          "date": date,
          "walletPayer": {
            "address": null,
            "account": {
              "name": accountNamePayer,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdPayer,
              "infos": []
            },
            "item": {
              "itemGroup": {
                "infos": []
              },
              "itemUnit": {
                "infos": []
              },
              "infos": []
            },
            "id": null,
            "infos": []
          },
          "walletReciept": {
            "address": null,
            "account": {
              "name": accountNameReciept,
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "id": accountIdReciept,
              "infos": []
            },
            "item": {
              "itemGroup": {
                "infos": []
              },
              "itemUnit": {
                "infos": []
              },
              "infos": []
            },
            "id": null,
            "infos": []
          },
          "item": {
            "itemGroup": {
              "infos": []
            },
            "itemUnit": {
              "name": null,
              "id": null,
              "infos": []
            },
            "name": "طلای آبشده",
            "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
            "id": itemId,
            "infos": []
          },
          "quantity": quantity,
          "status": 1,
          "isDeleted": false,
          "rowNum": 1,
          "id": id,
          "recId": recId,
          "attribute": "cus",
          "description": description,
          "infos": []

      };
      print(orderData);

      var response=await remittanceDio.put('Remittance/update',data: orderData);
      /*if(response.statusCode==200){
        print('ثبت با موفقیت انجام شد');
      }else{
        throw ErrorException('خطا');
      }*/
      return RemittanceModel.fromJson(response.data);
    }
    catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future< RemittanceModel> updateRegistered({
    required bool registered,
    required int remittanceId,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "registered": registered,
        "id": remittanceId,
      };
      print(remittanceData);

      var response=await remittanceDio.put('Remittance/updateRegistered',data: remittanceData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return RemittanceModel.fromJson(response.data) ;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }

  Future< bool> deleteImage({
    required String fileName,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "fileName":fileName,
      };
      print(remittanceData);

      var response=await remittanceDio.delete('Attachment/Delete',queryParameters: remittanceData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data ;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }

  Future< RemittanceModel> getOneRemittance({
    required int id,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "id": id,
      };
      print(remittanceData);

      var response=await remittanceDio.get('Remittance/getOne',queryParameters: remittanceData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return RemittanceModel.fromJson(response.data) ;
    }
    catch(e){
      throw ErrorException('خطا در ریجیستر:$e');
    }
  }
}

