

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/analyticalReports.repository.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../model/statistics_report.model.dart';
import '../model/statistics_report_header.model.dart';

enum PageState{loading,err,empty,list}

class StatisticsReportController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  AnalyticalReportsRepository analyticalReportsRepository=AnalyticalReportsRepository();

  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final List<StatisticsReportModel> statisticsReportList=<StatisticsReportModel>[].obs;
  final Rxn<StatisticsReportHeaderModel> headerData = Rxn<StatisticsReportHeaderModel>();
  var isLoading=false.obs;

  @override
  void onInit() {
    var now = Jalali.now();
    var firstDayOfMonth = Jalali(now.year, now.month, 1);
    dateStartController.text = "${firstDayOfMonth.year}/${firstDayOfMonth.month.toString().padLeft(2, '0')}/01";
    //dateStartController.text = "1404/01/01";
    dateEndController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
    super.onInit();
  }

  String convertJalaliToGregorianForApi(String jalaliDateString) {
    try {
      // Parse Jalali date string (format: 1404/06/01 00:00:00)
      List<String> parts = jalaliDateString.split(' ');
      String datePart = parts[0]; // 1404/06/01

      List<String> dateComponents = datePart.split('/');
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);

      // Convert to Jalali object then to Gregorian DateTime
      Jalali jalaliDate = Jalali(year, month, day);
      DateTime gregorianDate = jalaliDate.toDateTime();

      // Format as ISO string for API (2025-09-1T00:00:00)
      String formattedDate = "${gregorianDate.year}-${gregorianDate.month}-${gregorianDate.day}";
      return formattedDate;
    } catch (e) {
      print("Error converting date: $e");
      // Fallback to current date
      DateTime now = DateTime.now();
      return "${now.year}-${now.month}-${now.day}";
    }
  }

  // لیست گزارش حجمی سفارشات
  Future<void> getStatisticsReportList(String startDate,String endDate) async{
    statisticsReportList.clear();
    headerData.value = null;
    try{
      state.value=PageState.loading;

      final results = await Future.wait([
        analyticalReportsRepository.getStatisticsReportList(startDate,endDate),
        getStatisticsReportHeader(startDate, endDate)
      ]);

      var listResponse = results[0] as List<StatisticsReportModel>;
      var headerResponse = results[1] as StatisticsReportHeaderModel?;

      state.value=PageState.list;
      statisticsReportList.addAll(listResponse);
      headerData.value = headerResponse;

      if(statisticsReportList.isEmpty){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      print("Error in getStatisticsReportList: $e");
      state.value=PageState.err;
    }finally{
    }
  }

  Future<StatisticsReportHeaderModel?> getStatisticsReportHeader(String startDate,String endDate) async {
    try {
      final statisticsReportHeader = await analyticalReportsRepository.getStatisticsReportHeader(startDate,endDate);
      return statisticsReportHeader;
    } catch (e) {
      print('Error fetching statistics report header: $e');
      return null;
    }
  }
}

