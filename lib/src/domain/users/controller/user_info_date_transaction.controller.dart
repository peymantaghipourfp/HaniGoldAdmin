

import 'dart:async';
import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_footer.model.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;


enum PageState{loading,err,empty,list}

class UserInfoDateTransactionController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 25.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
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
  RxString currentOrderBy = "AV2.CurrencyValueBes".obs;
  RxString currentOrderByType = "DESC".obs;
  var id = 0.obs; // or `false`...
  var startDateFilter=DateTime.now().toString().obs;
  var endDateFilter=DateTime.now().toString().obs;


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
        orderByField = "AV2.CashBalanceBes";
        break;
      case 3: // Rial balance (debit)
        orderByField = "AV2.CashBalanceBed";
        break;
      case 4: // Gold balance (credit)
        orderByField = "AV2.GoldBalanceBes";
        break;
      case 5: // Gold balance (debit)
        orderByField = "AV2.GoldBalanceBed";
        break;
      case 6: // Coin balance (credit)
        orderByField = "AV2.CoinBalanceBes";
        break;
      case 7: // Coin balance (debit)
        orderByField = "AV2.CoinBalanceBed";
      case 10: // Currency balance (debit)
        orderByField = "AV2.CurrencyValueBes";
      case 11: // Currency balance (debit)
        orderByField = "AV2.CurrencyValueBed";
        break;
      default:
        orderByField = "AV2.CurrencyValueBes";
    }

    currentOrderBy.value = orderByField;
    currentOrderByType.value = ascending ? "ASC" : "DESC";

    // Refresh data with new sorting
    getListTransactionInfoDatePager();
  }


  void isChangePage(int index) {
    currentPage.value=(index*25-25)+1;
    itemsPerPage.value = index * 25;
    getListTransactionInfoDatePager();
  }

  void clearFilter() {
    paginated.value=null;
    currentPage.value = 1;
    itemsPerPage.value=25;
    dateStartController.clear();
    dateEndController.clear();
    startDateFilter.value=DateTime.now().toString();
    endDateFilter.value=DateTime.now().toString();
  }
  void clearSearch(){
    paginated.value=null;
    currentPage.value = 1;
    itemsPerPage.value=25;
    searchController.clear();
    // Reset sorting to default
    sortAscending.value = false;
    sortColumnIndex.value = null;
    currentOrderBy.value = "AV2.CurrencyValueBes";
    currentOrderByType.value = "DESC";
    getListTransactionInfoDatePager();
  }
  @override
  void onInit() {
    super.onInit();
    // Initialize default sorting
    sortAscending.value = false;
    getListTransactionInfoDatePager();
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
        var fetchedListTransactionInfo = await userInfoTransactionRepository.getListTransactionInfoDateListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          name: searchController.text,
          orderBy: currentOrderBy.value,
          orderByType: currentOrderByType.value,
          startDate: startDateFilter.value, endDate: endDateFilter.value,
        );
        if (fetchedListTransactionInfo.transactionWallets!.isNotEmpty ) {
          listTransactionInfo.addAll(fetchedListTransactionInfo.transactionWallets ?? []);
          currentPage.value = nextPage;
          hasMore.value = fetchedListTransactionInfo.transactionWallets!.length >= itemsPerPage.value;
          paginated.value = fetchedListTransactionInfo.paginated;
          listTransactionInfo.refresh();
          update();

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
  Future<void> getListTransactionInfoDatePager() async{
    print("getListTransactionInfoDate : ");
    listTransactionInfo.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getListTransactionInfoDateListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        name: searchController.text,
        orderBy: currentOrderBy.value,
        orderByType: currentOrderByType.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );
      state.value=PageState.list;
      listTransactionInfo.assignAll(response.transactionWallets??[]);

      paginated.value=response.paginated;
      if(listTransactionInfo.isEmpty){
        state.value=PageState.empty;
      }
      //getTransactionInfoFooter();
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  bool hasActiveFilters() {
    return dateStartController.text.isNotEmpty ||
        dateEndController.text.isNotEmpty;
  }

  //فایل اکسل
  /*Future<void> getListUserInfoTransactionExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await userInfoTransactionRepository.getListUserInfoTransactionExcel(
        name:nameFilterController.text,
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
          ext: 'xlsx',
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
  }*/

  // Footer data
  /*Future<void> getTransactionInfoFooter() async {
    try {
      var response = await userInfoTransactionRepository.getTransactionInfoFooter(
        startIndex: 1,
        toIndex: 100000,
        name: searchController.text,
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
  }*/
}
