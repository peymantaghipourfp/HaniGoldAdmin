

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/user.repository.dart';
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
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  DataPagerController dataPagerController=DataPagerController();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  UserRepository userRepository=UserRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
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
    if (columnIndex > 0) {
      if (ascending) {
        accountList.sort((a, b) => a.name!.toString().compareTo(b.name!.toString()));
      } else {
        accountList.sort((a, b) => b.name!.toString().compareTo(a.name!.toString()));
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

  void isChangePage(int index){
       currentPage.value=index*10-10;
       itemsPerPage.value=index*10;
    getUserList();
  }

// آپدیت موقعیت
  Future<void> updateStatus(int status,int id) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await userRepository.updateStatus(status: status, id: id
      );
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
      getUserList();
      update();
    }
    catch (e) {
     // state.value = PageStateUser.err;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // لیست کاربران
  Future<void> getUserList() async {
    print("getTransactionInfoList : 1");
    isOpenMore.value = false;
    accountList.clear();
    try {
       state.value=PageStateUser.loading;
      var response = await userRepository.getUserList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value, name: nameFilterController.text, mobile: mobileFilterController.text,
          );
      accountList.addAll(response.accounts??[]);
      paginated=response.paginated;
       // nameFilterController.text="";
       // mobileFilterController.text="";
    //  print(paginated?.totalCount??0);
       state.value=PageStateUser.list;
      isOpenMore.value = true;

      update();
    }
    catch (e) {
      state.value = PageStateUser.err;
    } finally {}
  }


}