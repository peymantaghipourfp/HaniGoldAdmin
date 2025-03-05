
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account_req.model.dart';

import '../../domain/withdraw/model/bank_account.model.dart';

class BankAccountRepository{
  Dio bankAccountDio=Dio();

  
  BankAccountRepository(){
    bankAccountDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<List<BankAccountModel>> getBankAccountList(BankAccountReqModel bankAccountReqModel)async{
    final response=await bankAccountDio.post('BankAccount/get',data: {"options":bankAccountReqModel});
    print(response);
    List<dynamic> data=response.data;
    return data.map((bankAccount)=>BankAccountModel.fromJson(bankAccount)).toList();
  }
}