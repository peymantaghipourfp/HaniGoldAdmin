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

  Future<ListTransactionModel> getTransactionList(
       int? startIndex,
       int? toIndex,
      ) async {
    try {
      Map<String, dynamic> options = {"options" : { "transaction" :{

        "orderBy": "Combined.Date",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
      }}};
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