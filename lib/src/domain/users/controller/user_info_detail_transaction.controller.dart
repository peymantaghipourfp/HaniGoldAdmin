

import 'dart:async';
import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
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
import 'package:path/path.dart' as path;


enum PageStateDe{loading,err,empty,list}

class UserInfoDetailTransactionController extends GetxController{

  Rx<PageStateDe> state=Rx<PageStateDe>(PageStateDe.list);
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
  RxList<TransactionInfoItemModel> transactionInfoList=<TransactionInfoItemModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  var id = 0.obs; // or `false`...
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;


  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        transactionInfoList.sort((a, b) => a.toWallet!.account!.name!.toString().compareTo(b.toWallet!.account!.name!.toString()));
      } else {
        transactionInfoList.sort((a, b) => b.toWallet!.account!.name!.toString().compareTo(a.toWallet!.account!.name!.toString()));
      }
    }

    transactionInfoList.refresh();
    update();
  }

  setSort(int index,bool val){
    sort.value= val;
    sortIndex.value= index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    print(int.parse(Get.parameters['accountId']!));
    id.value=int.parse(Get.parameters['accountId']!);
    getHeaderTransaction(int.parse(Get.parameters['accountId']!));
    getTransactionInfoListPager(id.value.toString());

  }

  /*void nextPage() {
    if (hasMore.value) {
      currentPageIndex.value++;
      currentPage.value+=7;
      itemsPerPage.value+=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getTransactionInfoListPager(id.value.toString());

    }
  }*/

  /*void previousPage() {
    if (currentPageIndex.value > 1) {
      currentPageIndex.value--;
      currentPage.value-=7;
      itemsPerPage.value-=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getTransactionInfoListPager(id.value.toString());
    }
  }*/



  // هدر مانده کاربر
  Future<void> getHeaderTransaction(int id) async{
    print("getHeaderTransaction : $id");
    try{
      state.value=PageStateDe.loading;
      var response=await userInfoTransactionRepository.getHeaderUserInfoTransaction(id);
      headerInfoUserTransactionModel=response;
     state.value=PageStateDe.list;
      getBalanceList(id);
      if(headerInfoUserTransactionModel==null){
        state.value=PageStateDe.empty;
      }
      update();
    }
    catch(e){
     // state.value=PageState.err;
    }finally{
    }
  }
  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
    try{
      state.value=PageStateDe.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      state.value=PageStateDe.list;
      // if(balanceList.isEmpty){
      //   state.value=PageState.empty;
      // }
      update();
    }
    catch(e){
      //state.value=PageState.err;
    }finally{
    }
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getTransactionInfoListPager(id.value.toString());
  }

  // لیست تراکنش های کاربر
  Future<void> getTransactionInfoListPager(String id) async {
    print("getTransactionInfoListPager ::::::::: 1");
    transactionInfoList.clear();
    isOpenMore.value=true;
    try {
      //state.value=PageStateDe.loading;
      var response = await userInfoTransactionRepository.getTransactionInfoListPager(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          accountId: id);
      isOpenMore.value=false;
      transactionInfoList.addAll(response.transactionInfoItems ?? []);
      print(transactionInfoList.length);
      paginated.value=response.paginated;
     //state.value=PageStateDe.list;
      update();
    }
    catch (e) {
      state.value = PageStateDe.err;
    } finally {}
  }

  //فایل اکسل
  Future<void> getUserInfoTransactionDetailExcel() async{
    try{
      EasyLoading.show(status: 'در حال دریافت فایل اکسل...');
      isLoading.value = true;

      Uint8List excelBytes = await userInfoTransactionRepository.getUserInfoTransactionDetailExcel(
        accountId: id.value == 0 ? null : id.value,
        startDate: startDateFilter.value, endDate: endDateFilter.value,
      );

      String fileName = 'userTransaction_${DateTime.now().toIso8601String()} ${headerInfoUserTransactionModel?.accountName}.xlsx';

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
      state.value = PageStateDe.err;
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

  Future<void> captureBalanceScreenshot(BuildContext context, GlobalKey balanceKey) async {
    try {
      RenderRepaintBoundary boundary = balanceKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        if (kIsWeb) {
          final blob = html.Blob([pngBytes], 'image/png');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'user_balance_screenshot_${headerInfoUserTransactionModel?.accountName}.png')
            ..click();
          html.Url.revokeObjectUrl(url);
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        } else {
          await FileSaver.instance.saveFile(
            name: "user_balance_screenshot_${headerInfoUserTransactionModel?.accountName}",
            bytes: pngBytes,
            ext: 'png',
            mimeType: MimeType.png,
          );
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        }
      }
    } catch (e) {
      Get.snackbar('خطا', 'ثبت اسکرین شات ناموفق بود: $e');
    }
  }

}