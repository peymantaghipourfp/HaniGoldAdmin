
import 'dart:async';
import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/base/base_controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/trading_balance.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../product/model/item.model.dart';
import '../model/balance_trading.model.dart';



enum PageStateBalance{loading,err,empty,list}

class TradingBalanceController extends BaseController{

  Rx<PageStateBalance> state=Rx<PageStateBalance>(PageStateBalance.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 7.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  TradingBalanceRepository tradingBalanceRepository=TradingBalanceRepository();
  final ItemRepository itemRepository=ItemRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final List<BalanceTradingModel> tradingBalanceList=<BalanceTradingModel>[].obs;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var sort = true.obs;
  var sortIndex = 0.obs;
  var id = 0.obs;
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();

  StreamSubscription? socketSubscription;


  @override
  void onInit() {
    super.onInit();
    socketSubscription?.cancel();
    _listenToSocket();
    // Set date range: first day of month to current date
    var now = Jalali.now();
    var firstDayOfMonth = Jalali(now.year, now.month, 1);
    DateTime currentDate = DateTime.now();

    // Display dates in Jalali format for user
    dateStartController.text = "${firstDayOfMonth.year}/${firstDayOfMonth.month.toString().padLeft(2, '0')}/01 00:00:00";
    dateEndController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${currentDate.hour.toString().padLeft(2, '0')}:${currentDate.minute.toString().padLeft(2, '0')}:${currentDate.second.toString().padLeft(2, '0')}";

    fetchItemList();
  }

  void _listenToSocket() {
    socketSubscription?.cancel();
    socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'order') {
            String gregorianStartDate = convertJalaliToGregorianForApi(dateStartController.text);
            String gregorianEndDate = convertJalaliToGregorianForApi(dateEndController.text);
            getTradingBalanceList(selectedItem.value!.id!, gregorianStartDate, gregorianEndDate);
          }
        } catch (e) {
          Get.log('Error processing socket message in OrderController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in OrderController: $error');
    });
  }

  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
    // Refresh data when item changes
    if (newValue?.id != null) {
      // Convert Jalali dates to Gregorian for API
      String gregorianStartDate = convertJalaliToGregorianForApi(dateStartController.text);
      String gregorianEndDate = convertJalaliToGregorianForApi(dateEndController.text);
      getTradingBalanceList(newValue!.id!, gregorianStartDate, gregorianEndDate);
    }
  }

  void onDateRangeChanged() {
    // Refresh data when date range changes
    if (selectedItem.value?.id != null) {
      // Convert Jalali dates to Gregorian for API
      String gregorianStartDate = convertJalaliToGregorianForApi(dateStartController.text);
      String gregorianEndDate = convertJalaliToGregorianForApi(dateEndController.text);
      getTradingBalanceList(selectedItem.value!.id!, gregorianStartDate, gregorianEndDate);
    }
  }

  String convertJalaliToGregorianForApi(String jalaliDateString) {
    try {
      // Parse Jalali date string (format: 1404/06/01 00:00:00)
      List<String> parts = jalaliDateString.split(' ');
      String datePart = parts[0]; // 1404/06/01
      String timePart = parts.length > 1 ? parts[1] : '00:00:00'; // 00:00:00

      List<String> dateComponents = datePart.split('/');
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);

      // Convert to Jalali object then to Gregorian DateTime
      Jalali jalaliDate = Jalali(year, month, day);
      DateTime gregorianDate = jalaliDate.toDateTime();

      // Format as ISO string for API (2025-09-1T00:00:00)
      String formattedDate = "${gregorianDate.year}-${gregorianDate.month}-${gregorianDate.day}T$timePart";
      return formattedDate;
    } catch (e) {
      print("Error converting date: $e");
      // Fallback to current date
      DateTime now = DateTime.now();
      return "${now.year}-${now.month}-${now.day}T00:00:00";
    }
  }

  // لیست محصولات
  Future<void> fetchItemList() async{
    try{
      state.value=PageStateBalance.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      itemList.removeWhere((e) => e.status==false,);

      // ایجاد آیتم "همه" با id=null
      ItemModel allItem = ItemModel(
        id: 0,
        name: "همه",
        status: true,itemPriceDate: null,
        itemGroup:null, itemUnit:null, price: null,basePrice: null, mesghalPrice: null,baseMesghalPrice: null, differentPrice: null,baseDifferentPrice: null,
        mesghalDifferentPrice: null,baseMesghalDifferentPrice: null, isDefault: null, isDecimal: null, showMarket: null, sellStatus: null, buyStatus: null,
        hasWage: null, wage: null, hasCard: null, cardPrice: null, maxSell: null, maxBuy: null, w750: null, initBalance: null, openPrice: null, openPriceValue: null,
        symbol: '', icon: '', rowNum: null, attribute: '', recId: '', infos: [], salesRange: null, buyRange: null, refrence: null,
      );

      itemList.insert(0, allItem);

      // Set default selected item to the first item with id = 1, or first active item if id=1 doesn't exist
      if (itemList.isNotEmpty) {
        var defaultItem = itemList.firstWhere((item) => item.id == 0, orElse: () => itemList.first);
        selectedItem.value = defaultItem;
        // Load initial data with converted dates (this will set the proper state)
        String gregorianStartDate = convertJalaliToGregorianForApi(dateStartController.text);
        String gregorianEndDate = convertJalaliToGregorianForApi(dateEndController.text);
        getTradingBalanceList(selectedItem.value?.id ?? 0, gregorianStartDate, gregorianEndDate);
      } else {
        state.value=PageStateBalance.empty;
      }
      print("itemList${itemList.length}");
    }
    catch(e){
      state.value=PageStateBalance.err;
      " خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }



  // لیست مانده کاربران
  Future<void> getTradingBalanceList(int itemId,String startDate,String endDate) async{
    print("getTradingBalanceList called with: itemId=$itemId, startDate=$startDate, endDate=$endDate");
    tradingBalanceList.clear();
    try{
      state.value=PageStateBalance.loading;
      var response=await tradingBalanceRepository.getTradingBalanceList(itemId,startDate,endDate);
      print("Received ${response.length} trading balance records");
      state.value=PageStateBalance.list;
      tradingBalanceList.addAll(response);
      if(tradingBalanceList.isEmpty){
        print("No trading data found - setting state to empty");
        state.value=PageStateBalance.empty;
      }
      update();
    }
    catch(e){
      print("Error in getTradingBalanceList: $e");
      state.value=PageStateBalance.err;
    }finally{
    }
  }

  //فایل اکسل
  Future<void> getTradingBalanceExcel(int itemId,String startDate,String endDate) async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await tradingBalanceRepository.getTradingBalanceExcel(itemId,startDate,endDate);

      String fileName = 'balance_${DateTime.now().toIso8601String()}.xlsx';

      if (kIsWeb) {
        final blob = html.Blob([excelBytes], 'application/vnd.ms-excel');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: excelBytes,
          fileExtension: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
      EasyLoading.showSuccess('فایل اکسل با موفقیت دانلود شد');
    }
    catch(e){
      EasyLoading.dismiss();
      "خطا در دریافت فایل اکسل: ${e.toString()}";
      Get.snackbar(
        'خطا',
        'خطا در دریافت فایل اکسل',
        snackPosition: SnackPosition.BOTTOM,
      );
    }finally{
      isLoading.value=false;
    }
  }
}
