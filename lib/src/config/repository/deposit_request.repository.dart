

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';

import '../network/error/network.error.dart';

class DepositRequestRepository{

  Dio depositRequestDio=Dio();

  DepositRequestRepository(){
    depositRequestDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<List<DepositRequestModel>> getDepositRequest(int withdrawId)async{
    try{
      final response=await depositRequestDio.get('DepositRequest/getByWithdraw',queryParameters: {'id':withdrawId});
      print(response);
      List<dynamic> data=response.data;
      return data.map((depositRequest)=>DepositRequestModel.fromJson(depositRequest)).toList();
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }


  Future<Map<String , dynamic>> insertDepositRequest({
    required int? withdrawId,
    required int? accountId,
    required double? amount,
    required double? requestAmount,
  })async{
    try{
      Map<String , dynamic> depositRequestData={
        "withdrawRequest": {
          "bankAccount": {
            "bank": {
              "infos": []
            },
            "account": {
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "infos": []
            },
            "infos": []
          },
          "wallet": {
            "account": {
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
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
            "infos": []
          },
          "id": withdrawId,
          "infos": []
        },
        "account": {
          "name": "شرکت BI",
          "contactInfo": "0993882350",
          "accountGroup": {
            "infos": []
          },
          "accountItemGroup": {
            "infos": []
          },
          "accountPriceGroup": {
            "infos": []
          },
          "id": accountId,
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
        "amount": amount,
        "requestAmount": requestAmount,
        "paidAmount": 75.000,
        "notPaidAmount": 0.000,
        "status": 0,
        "date": "2025-02-20T15:41:55",
        "deposits": [],
        "rowNum": 1,
        "id": 1,
        "attribute": "cus",
        "recId": "23f235da-c565-4a43-9395-ac47d86e293a",
        "infos": []
      };
      var response=await depositRequestDio.post('DepositRequest/insert',data: depositRequestData);
      return response.data;
    }catch(e){
      throw ErrorException('خطا در درج اطلاعات:$e');
    }
  }

  Future<Map<String , dynamic>> updateStatusDepositRequest({
    required int status,
    required int depositRequestId,
    int? reasonRejectionId,
  })async{
    try{
      Map<String,dynamic> depositRequestData={
        "withdrawRequest": {
          "bankAccount": {
            "bank": {
              "infos": []
            },
            "account": {
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
              "infos": []
            },
            "infos": []
          },
          "wallet": {
            "account": {
              "accountGroup": {
                "infos": []
              },
              "accountItemGroup": {
                "infos": []
              },
              "accountPriceGroup": {
                "infos": []
              },
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
            "infos": []
          },
          "reasonRejection": {
            "infos": []
          },
          "id": 1,
          "infos": []
        },
        "account": {
          "code": "5",
          "name": "تیدا پخش",
          "contactInfo": "09123138080",
          "accountGroup": {
            "infos": []
          },
          "accountItemGroup": {
            "infos": []
          },
          "accountPriceGroup": {
            "infos": []
          },
          "id": 5,
          "infos": []
        },
        "item": {
          "itemGroup": {
            "infos": []
          },
          "itemUnit": {
            "infos": []
          },
          "name": "وجه نقد",
          "id": 6,
          "infos": []
        },
        "amount": 500000.000,
        "requestAmount": 500000.000,
        "paidAmount": 500000.000,
        "notPaidAmount": 0.000,
        "date": "2025-03-17T18:15:32",
        "deposits": [
          {
            "depositRequest": {
              "item": {
                "itemGroup": {
                  "infos": []
                },
                "itemUnit": {
                  "infos": []
                },
                "infos": []
              },
              "reasonRejection": {
                "infos": []
              },
              "id": 1,
              "infos": []
            },
            "walletWithdraw": {
              "account": {
                "accountGroup": {
                  "infos": []
                },
                "accountItemGroup": {
                  "infos": []
                },
                "accountPriceGroup": {
                  "infos": []
                },
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
              "infos": []
            },
            "wallet": {
              "address": "eabc82a2-1448-40f8-8462-6dc50edbb20f",
              "account": {
                "code": "5",
                "name": "تیدا پخش",
                "accountGroup": {
                  "infos": []
                },
                "accountItemGroup": {
                  "infos": []
                },
                "accountPriceGroup": {
                  "infos": []
                },
                "id": 5,
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
              "id": 1009,
              "infos": []
            },
            "bankAccount": {
              "bank": {
                "name": "اقتصاد نوین",
                "icon": "b409ec83-77ad-464f-80e1-4dfd940d383b",
                "id": 7,
                "infos": []
              },
              "account": {
                "accountGroup": {
                  "infos": []
                },
                "accountItemGroup": {
                  "infos": []
                },
                "accountPriceGroup": {
                  "infos": []
                },
                "infos": []
              },
              "number": "111",
              "ownerName": "مسعود",
              "cardNumber": "11",
              "sheba": "1111",
              "id": 13,
              "infos": []
            },
            "reasonRejection": {
              "infos": []
            },
            "amount": 250000.000,
            "date": "2025-03-17T18:17:16",
            "confirmDate": "2025-03-22T11:12:07",
            "status": 0,
            "attachments": [],
            "rowNum": 1,
            "id": 1,
            "attribute": "cus",
            "recId": "c5d14657-3411-4eca-82b6-e594132c4a49",
            "infos": []
          },
          {
            "depositRequest": {
              "item": {
                "itemGroup": {
                  "infos": []
                },
                "itemUnit": {
                  "infos": []
                },
                "infos": []
              },
              "reasonRejection": {
                "infos": []
              },
              "id": 1,
              "infos": []
            },
            "walletWithdraw": {
              "account": {
                "accountGroup": {
                  "infos": []
                },
                "accountItemGroup": {
                  "infos": []
                },
                "accountPriceGroup": {
                  "infos": []
                },
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
              "infos": []
            },
            "wallet": {
              "address": "eabc82a2-1448-40f8-8462-6dc50edbb20f",
              "account": {
                "code": "5",
                "name": "تیدا پخش",
                "accountGroup": {
                  "infos": []
                },
                "accountItemGroup": {
                  "infos": []
                },
                "accountPriceGroup": {
                  "infos": []
                },
                "id": 5,
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
              "id": 1009,
              "infos": []
            },
            "bankAccount": {
              "bank": {
                "name": "اقتصاد نوین",
                "icon": "b409ec83-77ad-464f-80e1-4dfd940d383b",
                "id": 7,
                "infos": []
              },
              "account": {
                "accountGroup": {
                  "infos": []
                },
                "accountItemGroup": {
                  "infos": []
                },
                "accountPriceGroup": {
                  "infos": []
                },
                "infos": []
              },
              "number": "111",
              "ownerName": "مسعود",
              "cardNumber": "11",
              "sheba": "1111",
              "id": 13,
              "infos": []
            },
            "reasonRejection": {
              "infos": []
            },
            "amount": 250000.000,
            "date": "2025-03-17T18:17:31",
            "confirmDate": "2025-03-19T18:24:43",
            "status": 2,
            "attachments": [
              {
                "recordId": "ed741d06-853d-4748-b45c-7ba9d042eaa0",
                "guidId": "932afb71-7d9d-4964-b468-e8a8ce393812",
                "name": "808c5c56-cb33-4d4c-bafd-386831dd1c549217765358619351427.jpg",
                "extension": "jpg",
                "entityType": "Deposit",
                "type": "image",
                "rowNum": 1,
                "attribute": "cus",
                "infos": []
              }
            ],
            "rowNum": 1,
            "id": 2,
            "attribute": "cus",
            "recId": "ed741d06-853d-4748-b45c-7ba9d042eaa0",
            "infos": []
          }
        ],
        "rowNum": 1,
        "attribute": "cus",
        "recId": "c562d446-bd5d-4803-8ff8-fc835d4bbc69",
        if (reasonRejectionId != null) "reasonRejection":{
          "id": reasonRejectionId,
        },
        "status": status,
        "id": depositRequestId,
        "infos": []
      };
      print(depositRequestData);

      var response=await depositRequestDio.put('DepositRequest/updateStatus',data: depositRequestData);
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در تغییر وضعیت:$e');
    }
  }
}