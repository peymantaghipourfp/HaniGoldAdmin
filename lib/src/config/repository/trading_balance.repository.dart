
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import '../../domain/balance/model/balance_trading.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import 'dart:typed_data';

import '../network/error_handler.dart';

class TradingBalanceRepository{

  Dio tradingBalanceDio=Dio();
  TradingBalanceRepository(){
    tradingBalanceDio.options.baseUrl=BaseUrl.baseUrl;
    tradingBalanceDio.interceptors.add(DioInterceptor());
  }

  Future<List<BalanceTradingModel>> getTradingBalanceList(int itemId,String startDate,String endDate)async{
    try{

      final response=await tradingBalanceDio.get('Order/balanceResultBetweenDay',queryParameters: {'itemId': itemId,'startDate':startDate,'endDate':endDate});

      if (response.data == null) {
        return <BalanceTradingModel>[];
      }

      List<dynamic> data=response.data;
      return data.map((transaction)=>BalanceTradingModel.fromJson(transaction)).toList();

    }
    catch (e, s) {
      AppLogger.e('getTradingBalanceList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Uint8List> getTradingBalanceExcel(int itemId,String startDate,String endDate)async{
    try{

      final response=await tradingBalanceDio.get('Order/balanceResultBetweenDayExcel',
          queryParameters: {'itemId': itemId,'startDate':startDate,'endDate':endDate},
          options: Options(responseType: ResponseType.bytes)
      );

      return Uint8List.fromList(response.data);

    }
    catch (e, s) {
      AppLogger.e('getTradingBalanceExcel failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

}