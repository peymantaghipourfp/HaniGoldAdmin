

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/analyticalReports/model/candle_price_chart.model.dart';

import '../../domain/analyticalReports/model/statistics_report.model.dart';
import '../../domain/analyticalReports/model/statistics_report_header.model.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';

class AnalyticalReportsRepository {

  Dio analyticalReportsDio=Dio();

  AnalyticalReportsRepository(){
    analyticalReportsDio.options.baseUrl=BaseUrl.baseUrl;
    analyticalReportsDio.options.connectTimeout=Duration(seconds: 30);
    analyticalReportsDio.interceptors.add(DioInterceptor());
  }

  Future<List<StatisticsReportModel>> getStatisticsReportList(String startDate,String endDate)async{
    try{

      final response=await analyticalReportsDio.get('Order/statisticsReport',queryParameters: {'startDate':startDate,'endDate':endDate});
      print("Request parameters: startDate=$startDate, endDate=$endDate");
      print("response getStatisticsReportList : ${response.data}" );

      if (response.data == null) {
        print("API داده های خالی را برگرداند - هیچ داده ای برای پارامترهای مشخص شده موجود نیست");
        return <StatisticsReportModel>[];
      }

      List<dynamic> data=response.data;
      return data.map((statisticsReport)=>StatisticsReportModel.fromJson(statisticsReport)).toList();

    }
    catch(e){
      print("Error in getStatisticsReportList: $e");
      throw ErrorException('خطا:$e');
    }
  }

  Future<StatisticsReportHeaderModel> getStatisticsReportHeader(String startDate,String endDate)async{
    try{

      final response=await analyticalReportsDio.get('Order/statisticsReportHeader',queryParameters: {'startDate':startDate,'endDate':endDate});
      print("Request parameters: startDate=$startDate, endDate=$endDate");
      print("response getStatisticsReportHeader : ${response.data}" );

      if (response.data == null) {
        print("API داده های خالی را برگرداند - هیچ داده ای برای پارامترهای مشخص شده موجود نیست");
        return StatisticsReportHeaderModel(
            adminOrders: 0,approvedOrders: 0,buyAccountCount: 0,rejectedOrders: 0,sellAccountCount: 0,totalActiveAccounts: 0,userOrders: 0
        );
      }

      return StatisticsReportHeaderModel.fromJson(response.data);

    }
    catch(e){
      print("Error in getStatisticsReportList: $e");
      throw ErrorException('خطا:$e');
    }
  }

  Future<List<CandlePriceChartModel>> getCandlePriceChartList(int itemId, int timeFrame, String date,String startTime, String endTime)async{
    try{

      final response=await analyticalReportsDio.get('ItemPrice/getCandlePrice',queryParameters: { 'itemId':itemId,'timeFrame':timeFrame,'date':date,'startTime':startTime,'endTime':endTime});
      print("Request parameters: startTime=$startTime, endTime=$endTime, date=$date, timeFrame=$timeFrame, itemId=$itemId");
      print("response getCandlePriceChartList : ${response.data}" );

      if (response.data == null) {
        print("API داده های خالی را برگرداند - هیچ داده ای برای پارامترهای مشخص شده موجود نیست");
        return <CandlePriceChartModel>[];
      }

      List<dynamic> data=response.data;
      return data.map((candlePriceChart)=>CandlePriceChartModel.fromJson(candlePriceChart)).toList();

    }
    catch(e){
      print("Error in getCandlePriceChartList: $e");
      throw ErrorException('خطا:$e');
    }
  }


}