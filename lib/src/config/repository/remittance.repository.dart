
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
      print("url getRemittanceList : Remittance/get" );
      print("request getRemittanceList : $options" );
      print("response getRemittanceList : ${response.data}" );
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
      print("url getImage : Attachment/downloadAttachmentGuidList" );
      print("request getImage : $options" );
      print("response getImage : ${response.data}" );
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
    int? accountId,
    required String namePayer,
    required String nameReciept,
  })async{
    try{
      Map<String , dynamic> options=
      {
        "options" : { "remittance" : {
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
                  "RefTable": "Users"
                },
                if(startDate!="")
                  {
                    "fieldName": "Date",
                    "filterValue": "$startDate|$endDate",
                    "filterType": 25,
                    "RefTable": "Remittance"
                  },
                if(namePayer!="")
                  {
                    "fieldName": "Name",
                    "filterValue": namePayer,
                    "filterType": 0,
                    "RefTable": "AccountPayer"
                  },
                if(nameReciept!="")
                  {
                    "fieldName": "Name",
                    "filterValue": nameReciept,
                    "filterType": 0,
                    "RefTable": "AccountReciept"
                  },
              ],
            }
          ],
          "orderBy": "Remittance.Id",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      final response=await remittanceDio.post('Remittance/getWrapper',data: options);
      print("url getRemittanceListPager : Remittance/get" );
      print("request getRemittanceListPager : $options" );
      print("response getRemittanceListPager : ${response.data}" );
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
      print('Status Code insertRemittance: ${response.statusCode}');
      print('Response Data insertRemittance: ${response.data}');
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
    required int walletPayerId,
    required int walletRecieptId,
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
            "id": walletPayerId,
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
            "id": walletRecieptId,
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
      print('Status Code updateRemittance: ${response.statusCode}');
      print('Response Data updateRemittance: ${response.data}');
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
      print('Status Code updateRegistered: ${response.statusCode}');
      print('Response Data updateRegistered: ${response.data}');
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
      print('Status Code deleteImage: ${response.statusCode}');
      print('Response Data deleteImage: ${response.data}');
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
      print('Status Code getOneRemittance: ${response.statusCode}');
      print('Response Data getOneRemittance: ${response.data}');
      return RemittanceModel.fromJson(response.data) ;
    }
    catch(e){
      throw ErrorException('خطا در دریافت:$e');
    }
  }

  Future<List< dynamic>> deleteRemittance({
    required bool isDeleted,
    required int remittanceId,
  })async{
    try{
      Map<String,dynamic> remittanceData={
        "id": remittanceId,
        "isDeleted" : isDeleted,
      };

      print(remittanceData);

      var response=await remittanceDio.delete('Remittance/updateToIsDeleted',data: remittanceData);
      print('Status Code deleteRemittance: ${response.statusCode}');
      print('Response Data deleteRemittance: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }
}

