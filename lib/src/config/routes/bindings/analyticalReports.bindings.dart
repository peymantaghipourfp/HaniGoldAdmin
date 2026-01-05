
import 'package:get/get.dart';

import '../../../domain/analyticalReports/controller/candle_price_chart.controller.dart';
import '../../../domain/analyticalReports/controller/statistics_report.controller.dart';

class AnalyticalReportsBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>StatisticsReportController());
    Get.lazyPut(()=>CandlePriceChartController());
  }
}