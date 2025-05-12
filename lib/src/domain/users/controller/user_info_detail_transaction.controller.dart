

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageStateDe{loading,err,empty,list}

class UserInfoDetailTransactionController extends GetxController{

  Rx<PageStateDe> state=Rx<PageStateDe>(PageStateDe.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 7.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
   RxList<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  RxList<TransactionInfoItemModel> transactionInfoList=<TransactionInfoItemModel>[].obs;
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  var id = 0.obs; // or `false`...


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
    getTransactionInfoList(id.value.toString());

  }
  void nextPage() {
    if (hasMore.value) {
      currentPageIndex.value++;
      currentPage.value+=7;
      itemsPerPage.value+=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getTransactionInfoList(id.value.toString());

    }
  }

  void previousPage() {
    if (currentPageIndex.value > 1) {
      currentPageIndex.value--;
      currentPage.value-=7;
      itemsPerPage.value-=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getTransactionInfoList(id.value.toString());
    }
  }



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

  // لیست تراکنش های کاربر
  Future<void> getTransactionInfoList(String id) async {
    print("getTransactionInfoList : 1");
    isOpenMore.value = false;
    transactionInfoList.clear();
    try {
      // state.value=PageStateDe.loading;
      var response = await userInfoTransactionRepository.getTransactionInfoList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          accountId: id);
      transactionInfoList.addAll(response);
     //  state.value=PageStateDe.list;
      isOpenMore.value = true;
      update();
    }
    catch (e) {
      state.value = PageStateDe.err;
    } finally {}
  }

}