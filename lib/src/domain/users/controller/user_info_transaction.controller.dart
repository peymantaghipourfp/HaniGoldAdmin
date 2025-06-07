

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageState{loading,err,empty,list}

class UserInfoTransactionController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
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
  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController mobileFilterController = TextEditingController();
  RxList<TransactionInfoItemModel> transactionInfoList=<TransactionInfoItemModel>[].obs;
  RxList<ListTransactionInfoItemModel> listTransactionInfo=<ListTransactionInfoItemModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
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
  void isChangePage(int index) {
    currentPage.value = index * 10 - 10;
    itemsPerPage.value = index * 10;
    getListTransactionInfoPager();
  }

  void clearFilter() {
    nameFilterController.clear();
    mobileFilterController.clear();
  }
  @override
  void onInit() {
    super.onInit();
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
      var response=await userInfoTransactionRepository.getListTransactionInfoListPager( startIndex: currentPage.value, toIndex: itemsPerPage.value, name: searchController.text,);
      state.value=PageState.list;
      listTransactionInfo.addAll(response.transactionWallets??[]);
      paginated.value=response.paginated;
      if(listTransactionInfo.isEmpty){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }
}
