

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../product/model/item.model.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/transaction_item.model.dart';


enum PageState{loading,err,empty,list}

class UserInfoTransactionController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController searchControllerP=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController namePayerController=TextEditingController();
  final TextEditingController mobilePayerController=TextEditingController();
  final TextEditingController quantityPayerController=TextEditingController();
  final TextEditingController descController=TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var isLoading=false.obs;
  var namePayer="".obs;
  var mobilePayer="".obs;


  @override
  void onInit() {
    super.onInit();
    getHeaderTransaction(1);
    getBalanceList(1);
  }
  void nextPage() {
    if (hasMore.value) {
      currentPage.value++;
      // fetchRemittanceList();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
     // fetchRemittanceList();
    }
  }
  // هدر مانده کاربر
  Future<void> getHeaderTransaction(int id) async{
    print("getHeaderTransaction : $id");
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getHeaderUserInfoTransaction(id);
      headerInfoUserTransactionModel=response;
      state.value=PageState.list;
      if(headerInfoUserTransactionModel==null){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }
  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      state.value=PageState.list;
      if(balanceList.isEmpty){
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