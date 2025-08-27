

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';

import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';

class WalletRepository{
  Dio walletDio=Dio();

  WalletRepository(){
    walletDio.options.baseUrl=BaseUrl.baseUrl;
    walletDio.interceptors.add(DioInterceptor());
  }

  Future<WalletModel> getWalletCurrency(int accountId)async{
    try{
      final response=await walletDio.get('Wallet/getCurrency',queryParameters: {'id':accountId});
      print('Status Code getWalletCurrency: ${response.statusCode}');
      print('Response Data getWalletCurrency: ${response.data}');
      Map<String, dynamic> data=response.data;
      return WalletModel.fromJson(data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }
  
  Future<List<WalletModel>>  getWalletList(WalletAccountReqModel walletAccountReqModel)async{
    final response=await walletDio.post('Wallet/get',data: {"options":walletAccountReqModel});
    print('Status Code getWalletList: ${response.statusCode}');
    print('Response Data getWalletList: ${response.data}');
    List<dynamic> data=response.data;
    return data.map((wallet)=>WalletModel.fromJson(wallet)).toList();
  }
}