

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

class UserInfoTransactionController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  ScrollController scrollController = ScrollController();
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
  // Fields for server-side sorting
  String _orderBy = "ABS(AccountValues.CurrencyValue)";
  String _orderByType = "DESC";
  var id = 0.obs; // or `false`...
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;


  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    /*if (columnIndex == 3) {
      listTransactionInfo.sort((a, b) {
        final aName = a.listTransactionInfo?.name ?? '';
        final bName = b.listTransactionInfo?.name ?? '';
        return ascending ? aName.compareTo(bName) : bName.compareTo(aName);
      });
    }*/
  }


  void isChangePage(int index) {
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value = index * 10;
    getListTransactionInfoPager();
  }

  void clearFilter() {
    nameFilterController.clear();
    mobileFilterController.clear();
  }
  void clearSearch(){
    currentPage.value = 1;
    searchController.clear();
    // Reset sorting to default
    sortAscending.value = false;
    sortColumnIndex.value = null;
    getListTransactionInfoPager();
  }
  @override
  void onInit() {
    super.onInit();
    // Initialize default sorting
    sortAscending.value = false;
    getListTransactionInfoPager();
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
  Future<void> getListTransactionInfoPager() async{
    print("getListTransactionInfo : ");
    listTransactionInfo.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getListTransactionInfoListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        name: searchController.text,
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

      Uint8List excelBytes = await userInfoTransactionRepository.getListUserInfoTransactionExcel();

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
  }

  // Footer data
  Future<void> getTransactionInfoFooter() async {
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
  }

}
