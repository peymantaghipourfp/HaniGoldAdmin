

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';

import '../../domain/product/model/item.model.dart';
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

  Future<List< dynamic>> sendBalanceToTelegram({
    required int accountId,
  })async{
    try {
      final response = await walletDio.get('Wallet/getForTelegram', queryParameters: {'accountId': accountId});
      print('Status Code sendBalanceToTelegram: ${response.statusCode}');
      print('Response Data sendBalanceToTelegram: ${response.data}');
      return response.data;
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List<ItemModel>> getItemNotWallet({
    required int accountId,
  }) async {
    try {
      final response = await walletDio.get('Wallet/GetItemNotWallet', queryParameters: {"accountId": accountId});
      print('Status Code getItemNotWallet: ${response.statusCode}');
      print("response getItemNotWallet : ${response.data}" );
      List<dynamic> data = response.data;
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } catch (e) {
      throw ErrorException('خطا:$e');
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
      print("request insertWallet : $options" );
      final response = await walletDio.post('Wallet/insert', data: options);
      print('Status Code insertWallet: ${response.statusCode}');
      print("request insertWallet : $options" );
      print("response insertWallet : ${response.data}" );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return data;
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

}