

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import '../../../config/repository/url/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageStateUser{loading,err,empty,list}

class UserListController extends GetxController{

  Rx<PageStateUser> state=Rx<PageStateUser>(PageStateUser.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 7.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  UserRepository userRepository=UserRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
   RxList<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  RxList<AccountModel> accountList=<AccountModel>[].obs;
  PaginatedModel? paginated;
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
      //  accountList.sort((a, b) => a.toWallet!.account!.name!.toString().compareTo(b.toWallet!.account!.name!.toString()));
      } else {
      //  transactionInfoList.sort((a, b) => b.toWallet!.account!.name!.toString().compareTo(a.toWallet!.account!.name!.toString()));
      }
    }

    accountList.refresh();
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
    getUserList();

  }
  void nextPage() {
    if (hasMore.value) {
      currentPageIndex.value++;
      currentPage.value+=7;
      itemsPerPage.value+=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getUserList();

    }
  }

  void previousPage() {
    if (currentPageIndex.value > 1) {
      currentPageIndex.value--;
      currentPage.value-=7;
      itemsPerPage.value-=7;
      print(currentPage.value);
      print(itemsPerPage.value);
      getUserList();
    }
  }



  // لیست کاربران
  Future<void> getUserList() async {
    print("getTransactionInfoList : 1");
    isOpenMore.value = false;
    accountList.clear();
    try {
      // state.value=PageStateDe.loading;
      var response = await userRepository.getUserList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          );
      accountList.addAll(response.accounts??[]);
      paginated=response.paginated;
      print(paginated?.totalCount??0);
     //  state.value=PageStateDe.list;
      isOpenMore.value = true;
      update();
    }
    catch (e) {
      state.value = PageStateUser.err;
    } finally {}
  }

}