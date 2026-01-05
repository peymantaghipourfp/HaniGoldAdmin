

import 'dart:async';
import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_footer.model.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/report_setting.model.dart';
import '../model/transaction_info_item.model.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;


enum PageState{loading,err,empty,list}

class UserInfoGoldTransactionController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final AccountRepository accountRepository=AccountRepository();
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerMobile = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
  RxList<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController mobileFilterController = TextEditingController();
  RxList<TransactionInfoItemModel> transactionInfoList=<TransactionInfoItemModel>[].obs;
  RxList<ListTransactionInfoItemModel> listTransactionInfo=<ListTransactionInfoItemModel>[].obs;
  RxList<TransactionInfoFooterModel> listTransactionInfoFooter=<TransactionInfoFooterModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;
  RxString currentOrderBy = "AccountValues.CurrencyValueBes".obs;
  RxString currentOrderByType = "DESC".obs;
  var id = 0.obs; // or `false`...
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final Rxn<ReportSettingModel> getOneReportSetting = Rxn<ReportSettingModel>();
  List<int>? filteredAccountIds;
  int? accountFilterType;


  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    /*if (columnIndex == 2) {
      listTransactionInfo.sort((a, b) {
        final aCurrency = a.currencyValue;
        final bCurrency = b.currencyValue;
        return ascending ? aCurrency.compareTo(bCurrency) : bCurrency.compareTo(aCurrency);
      });
    }else if(columnIndex == 3){
      listTransactionInfo.sort((a, b) {
        final aCurrency = a.currencyValue;
        final bCurrency = b.currencyValue;
        return ascending ? aCurrency.compareTo(bCurrency) : bCurrency.compareTo(aCurrency);
      });
    }*/

    // Map column indices to orderBy fields
    String orderByField;
    switch (columnIndex) {
      case 2: // Rial balance (credit)
        orderByField = "AccountValues.CashBalanceBes";
        break;
      case 3: // Rial balance (debit)
        orderByField = "AccountValues.CashBalanceBed";
        break;
      case 4: // Gold balance (credit)
        orderByField = "AccountValues.GoldBalanceBes";
        break;
      case 5: // Gold balance (debit)
        orderByField = "AccountValues.GoldBalanceBed";
        break;
      case 6: // Coin balance (credit)
        orderByField = "AccountValues.CoinBalanceBes";
        break;
      case 7: // Coin balance (debit)
        orderByField = "AccountValues.CoinBalanceBed";
        break;
      case 10: // Currency balance (debit)
        orderByField = "AccountValues.CurrencyValueBes";
        break;
      case 11: // Currency balance (debit)
        orderByField = "AccountValues.CurrencyValueBed";
        break;
      default:
        orderByField = "AccountValues.CurrencyValueBes";
    }

    currentOrderBy.value = orderByField;
    currentOrderByType.value = ascending ? "ASC" : "DESC";

    // Refresh data with new sorting
    getListTransactionInfoGoldPager();
  }


  void isChangePage(int index) {
    currentPage.value=(index*25-25)+1;
    itemsPerPage.value = index * 25;
    getListTransactionInfoGoldPager();
  }

  void clearFilter() {
    nameFilterController.clear();
    mobileFilterController.clear();
    filteredAccountIds = null;
    accountFilterType = null;
  }
  void clearSearch(){
    paginated.value=null;
    currentPage.value = 1;
    itemsPerPage.value=25;
    searchController.clear();
    // Reset sorting to default
    sortAscending.value = false;
    sortColumnIndex.value = null;
    currentOrderBy.value = "AccountValues.CurrencyValueBes";
    currentOrderByType.value = "DESC";
    filteredAccountIds = null;
    accountFilterType = null;
    getListTransactionInfoGoldPager();
  }
  @override
  void onInit() {
    super.onInit();
    // Initialize default sorting
    sortAscending.value = false;
    getListTransactionInfoGoldPager();
    setupScrollListener();
  }
  @override void onClose() {
    scrollControllerMobile.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollControllerMobile.addListener(() {
      if (scrollControllerMobile.position.pixels >=
          scrollControllerMobile.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }
  Future<void> loadMore() async {
    if (!scrollControllerMobile.hasClients || hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;
        var fetchedListTransactionInfo = await userInfoTransactionRepository.getListTransactionInfoListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          name: searchController.text,
          accountIds: filteredAccountIds,
          filterType: accountFilterType,
        );
        if (fetchedListTransactionInfo.transactionWallets!.isNotEmpty ) {
          listTransactionInfo.addAll(fetchedListTransactionInfo.transactionWallets ?? []);
          currentPage.value = nextPage;
          hasMore.value = fetchedListTransactionInfo.transactionWallets?.length == itemsPerPage.value;

        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false; // توقف بارگذاری بیشتر در صورت خطا
        "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }

  // void goToPage(int page) {
  //   if (page < 1) return;
  //   currentPage.value = page;
  //   getListTransactionInfoPager();
  // }
  //
  // void nextPage() {
  //   if (hasMore.value) {
  //     currentPageIndex.value++;
  //     currentPage.value+=7;
  //     itemsPerPage.value+=7;
  //     print(currentPage.value);
  //     print(itemsPerPage.value);
  //     getListTransactionInfoPager();
  //
  //   }
  // }

  // void previousPage() {
  //   if (currentPageIndex.value > 1) {
  //     currentPageIndex.value--;
  //     currentPage.value-=7;
  //     itemsPerPage.value-=7;
  //     print(currentPage.value);
  //     print(itemsPerPage.value);
  //     getListTransactionInfoPager();
  //   }
  // }



  // لیست مانده کاربران
  // Future<void> getListTransactionInfo() async{
  //   print("getListTransactionInfo : ");
  //   listTransactionInfo.clear();
  //   try{
  //     state.value=PageState.loading;
  //     var response=await userInfoTransactionRepository.getListTransactionInfoList( startIndex: currentPage.value, toIndex: itemsPerPage.value, name: searchController.text,);
  //     state.value=PageState.list;
  //     listTransactionInfo.addAll(response);
  //     if(listTransactionInfo.isEmpty){
  //       state.value=PageState.empty;
  //     }
  //     update();
  //   }
  //   catch(e){
  //     state.value=PageState.err;
  //   }finally{
  //   }
  // }

  // لیست مانده کاربران
  Future<void> getListTransactionInfoGoldPager() async{
    print("getListTransactionInfo : ");
    listTransactionInfo.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getListTransactionInfoListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        name: searchController.text,
        accountIds: filteredAccountIds,
        filterType: accountFilterType,
        orderBy: currentOrderBy.value,
        orderByType: currentOrderByType.value,
      );
      state.value=PageState.list;
      listTransactionInfo.assignAll(response.transactionWallets??[]);

      paginated.value=response.paginated;
      if(listTransactionInfo.isEmpty){
        state.value=PageState.empty;
      }
      getTransactionInfoFooter();
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  //فایل اکسل
  Future<void> getListUserInfoTransactionExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await userInfoTransactionRepository.getListUserInfoTransactionExcel(
        name:nameFilterController.text,
        accountIds: filteredAccountIds,
        filterType: accountFilterType,
      );

      String fileName = 'userTransaction_${DateTime.now().toIso8601String()}.xlsx';

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
      EasyLoading.dismiss();
      isLoading.value=false;
    }
  }

  // Footer data
  Future<void> getTransactionInfoFooter() async {
    try {
      var response = await userInfoTransactionRepository.getTransactionInfoFooter(
        startIndex: 1,
        toIndex: 100000,
        name: searchController.text,
        accountIds: filteredAccountIds,
        filterType: accountFilterType,
      );
      listTransactionInfoFooter.assignAll(response);
      print("Footer list updated with ${listTransactionInfoFooter.length} items");
      update();
    }
    catch(e){
      print("Error loading footer data: $e");
    }finally{
      print("getTransactionInfoFooter : completed");
    }
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      state.value=PageState.list;
      if(accountList.isEmpty){
        state.value=PageState.empty;
      }
      print('تعداد :${accountList.length}');
    }
    catch(e){
      state.value=PageState.err;
      " خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  // getOne reportSetting
  Future<ReportSettingModel?> fetchGetOneReportSetting(String name)async{
    try {
      state.value=PageState.loading;
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      var fetchedGetOneReportSetting = await userInfoTransactionRepository.getOneReportSetting(name);
      if(fetchedGetOneReportSetting!=null){
        getOneReportSetting.value = fetchedGetOneReportSetting;
        state.value=PageState.list;
        //EasyLoading.dismiss();
      }else{
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      " خطایی به وجود آمده است ${e.toString()}";
    }
    return null;
  }



  // Update report setting
  Future<void> updateReportSetting(ReportSettingModel reportSetting) async {
    try {
      EasyLoading.show(status: 'در حال به‌روزرسانی تنظیمات گزارش...');
      isLoading.value = true;

      await userInfoTransactionRepository.updateReportSetting(reportSetting);

      EasyLoading.showSuccess('تنظیمات گزارش با موفقیت به‌روزرسانی شد');
      Get.snackbar(
        'موفق',
        'تنظیمات گزارش با موفقیت به‌روزرسانی شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'خطا',
        'خطا در به‌روزرسانی تنظیمات گزارش',
        snackPosition: SnackPosition.BOTTOM,
      );
      print("Error updating report setting: $e");
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

}
