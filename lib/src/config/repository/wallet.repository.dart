

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';

import '../../domain/product/model/item.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

class WalletRepository{
  Dio walletDio=Dio();

  WalletRepository(){
    walletDio.options.baseUrl=BaseUrl.baseUrl;
    walletDio.interceptors.add(DioInterceptor());
  }

  Future<WalletModel> getWalletCurrency(int accountId)async{
    try{
      final response=await walletDio.get('Wallet/getCurrency',queryParameters: {'id':accountId});
      Map<String, dynamic> data=response.data;
      return WalletModel.fromJson(data);
    }
    catch (e, s) {
      AppLogger.e('getWalletCurrency failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
  
  Future<List<WalletModel>>  getWalletList(WalletAccountReqModel walletAccountReqModel)async{
    final response=await walletDio.post('Wallet/get',data: {"options":walletAccountReqModel});
    List<dynamic> data=response.data;
    return data.map((wallet)=>WalletModel.fromJson(wallet)).toList();
  }

  Future<List< dynamic>> sendBalanceToTelegram({
    required int accountId,
  })async{
    try {
      final response = await walletDio.get('Wallet/getForTelegram', queryParameters: {'accountId': accountId});
      return response.data;
    }catch (e, s) {
      AppLogger.e('sendBalanceToTelegram failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<ItemModel>> getItemNotWallet({
    required int accountId,
  }) async {
    try {
      final response = await walletDio.get('Wallet/GetItemNotWallet', queryParameters: {"accountId": accountId});
      List<dynamic> data = response.data;
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } catch (e, s) {
      AppLogger.e('getItemNotWallet failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String, dynamic>> insertWallet({
    required int accountId,
    required List<int> itemIds,
  }) async {
    try {
      Map<String, dynamic> options = {
        "account": {
          "id": accountId,
        },
        "items": itemIds.map((id) => {"id": id}).toList(),
      };
      final response = await walletDio.post('Wallet/insert', data: options);
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return data;
    } catch (e, s) {
      AppLogger.e('insertWallet failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}