

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';

import '../network/error/network.error.dart';

class WalletRepository{
  Dio walletDio=Dio();

  WalletRepository(){
    walletDio.options.baseUrl=BaseUrl.baseUrl;
  }

  Future<WalletModel> getWallet(int accountId)async{
    try{
      final response=await walletDio.get('Wallet/getCurrency',queryParameters: {'id':accountId});
      //print(response);
      Map<String, dynamic> data=response.data;
      return WalletModel.fromJson(data);
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

}