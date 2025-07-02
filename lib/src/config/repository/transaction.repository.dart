import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';

import '../../domain/laboratory/model/laboratory.model.dart';
import '../../domain/laboratory/model/list_laboratory.model.dart';
import '../../domain/users/model/list_transaction.model.dart';

class TransactionRepository {

  Dio transactionDio = Dio();

  TransactionRepository() {
    transactionDio.options.baseUrl = BaseUrl.baseUrl;
  }

  Future<ListTransactionModel> getTransactionList({
    required int startIndex,
    required int toIndex,
    int? accountId,
    int? itemId,
    String? name,
    String? type,
    required String startDate,
    required String endDate,
        }) async {
    try {
      Map<String, dynamic> options =
      //accountId != null?
      {
        "options" : { "transaction" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                if(accountId != null)
                {
                  "fieldName": "[Account.Id]",
                  "filterValue": accountId.toString(),
                  "filterType": 5,
                  "RefTable": "Combined"
                },
                if(itemId != null)
                {
                  "fieldName": "[Item.Id]",
                  "filterValue": itemId.toString(),
                  "filterType": 5,
                  "RefTable": "Combined"
                },
                if(name!="")
                {
                  "fieldName": "[Account.Name]",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "Combined"
                },
                if(type!="")
                {
                  "fieldName": "[Type]",
                  "filterValue": type,
                  "filterType": 4,
                  "RefTable": "Combined"
                },
                if(startDate!="")
                {
                  "fieldName": "[Date]",
                  "filterValue": "$startDate|$endDate",
                  "filterType": 25,
                  "RefTable": "Combined"
                }
              ],
            }
          ],
          "orderBy": "Combined.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      };
      /*itemId != null?
      {
        "options" : { "transaction" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "[Item.Id]",
                  "filterValue": itemId.toString(),
                  "filterType": 5,
                  "RefTable": "Combined"
                },
              ],
            }
          ],
          "orderBy": "Combined.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      }:
      name!="" ?
      {
        "options" : { "transaction" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "[Account.Name]",
                  "filterValue": name,
                  "filterType": 0,
                  "RefTable": "Combined"
                },
              ],
            }
          ],
          "orderBy": "Combined.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      }:
      type!="" ?
      {
        "options" : { "transaction" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "[Type]",
                  "filterValue": type,
                  "filterType": 4,
                  "RefTable": "Combined"
                },
              ],
            }
          ],
          "orderBy": "Combined.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }
        }
      }:
      startDate!=""? {
        "options" : { "transaction" : {
          "Predicate": [
            {
              "innerCondition": 0,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "[Date]",
                  "filterValue": "$startDate|$endDate",
                  "filterType": 25,
                  "RefTable": "Combined"
                }
              ]
            }
          ],
          "orderBy": "Combined.Date",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      }:
      {
        "options" : { "transaction" :{
        "orderBy": "Combined.Date",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
      }}};*/
      final response = await transactionDio.post('Transaction/getTransactionJournalWrapper', data: options);
      print("request getTransactionList : $options" );
      print("response getTransactionList : ${response.data}" );
      if (response.statusCode == 200) {
        return ListTransactionModel.fromJson(response.data);
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