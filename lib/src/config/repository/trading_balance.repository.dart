
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import '../../domain/balance/model/balance_trading.model.dart';
import '../network/dio_Interceptor.dart';
import 'dart:typed_data';

class TradingBalanceRepository{

  Dio tradingBalanceDio=Dio();
  TradingBalanceRepository(){
    tradingBalanceDio.options.baseUrl=BaseUrl.baseUrl;
    tradingBalanceDio.interceptors.add(DioInterceptor());
  }

  Future<List<BalanceTradingModel>> getTradingBalanceList(int itemId,String startDate,String endDate)async{
    try{

      final response=await tradingBalanceDio.get('Order/balanceResultBetweenDay',queryParameters: {'itemId': itemId,'startDate':startDate,'endDate':endDate});
      print("Request parameters: itemId=$itemId, startDate=$startDate, endDate=$endDate");
      print("response getTradingBalanceList : ${response.data}" );

      if (response.data == null) {
        print("API returned null data - no trading data available for the specified parameters");
        return <BalanceTradingModel>[];
      }

      List<dynamic> data=response.data;
      return data.map((transaction)=>BalanceTradingModel.fromJson(transaction)).toList();

    }
    catch(e){
      print("Error in getTradingBalanceList: $e");
      throw ErrorException('خطا:$e');
    }
  }

  Future<Uint8List> getTradingBalanceExcel(int itemId,String startDate,String endDate)async{
    try{

      final response=await tradingBalanceDio.get('Order/balanceResultBetweenDayExcel',
          queryParameters: {'itemId': itemId,'startDate':startDate,'endDate':endDate},
          options: Options(responseType: ResponseType.bytes)
      );
      print("Request getTradingBalanceExcel parameters: itemId=$itemId, startDate=$startDate, endDate=$endDate");
      print("response getTradingBalanceExcel : ${response.data}" );

      return Uint8List.fromList(response.data);

    }
    catch(e){
      print("Error in getTradingBalanceExcel: $e");
      throw ErrorException('خطا:$e');
    }
  }

}