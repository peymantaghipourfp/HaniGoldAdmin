

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_list.controller.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../model/account_child.model.dart';
import '../model/balance_item.model.dart';
import '../model/city_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageStateUser{loading,err,empty,list}

class UserDetailController extends GetxController{

  Rx<PageStateUser> state=Rx<PageStateUser>(PageStateUser.list);
  final AccountRepository accountRepository=AccountRepository();
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxInt currentPageAccount = 1.obs;
  RxInt itemsPerPageAccount = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  var isShowListAccount=false.obs;
  UserRepository userRepository=UserRepository();
  ScrollController scrollController = ScrollController();
  RxList<StateItemModel> stateList=<StateItemModel>[].obs;
  RxList<CityItemModel> cityList=<CityItemModel>[].obs;
  RxList<AccountModel> accountChildModelList=<AccountModel>[].obs;
  RxList<AccountModel> accountChildModelListRemove=<AccountModel>[].obs;
  RxList<int> accountIdList=<int>[].obs;
  late Rxn<StateItemModel> selectedState=Rxn<StateItemModel>();
  final Rxn<CityItemModel> selectedCity=Rxn<CityItemModel>();
  final Rxn<AccountModel> accountModel=Rxn<AccountModel>();
  final TextEditingController searchController=TextEditingController();
  var idUser=0.obs;
  var title="".obs;
  final List<AccountModel> accountChildList=<AccountModel>[].obs;
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  final Rxn<PaginatedModel> paginatedChild = Rxn<PaginatedModel>();

  @override
  void onInit() {
    super.onInit();
    idUser.value=int.parse(Get.parameters["accountId"] as String);
    print(idUser.value);
    idUser.value!=0? getOneUser(idUser.value):null;
    idUser.value!=0? fetchAccountList(idUser.value.toString()):null;
    idUser.value!=0? fetchChildList(idUser.value.toString()):null;
    // getStateList();
    // getCityList();
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    fetchChildList(idUser.value.toString());
  }

  void isChangePageAccount(int index){
    currentPageAccount.value=index*10-10;
    itemsPerPageAccount.value=index*10;
    fetchAccountList(idUser.value.toString());
  }

  setChecked(){
    isChecked.value=!isChecked.value;
    update();
  }

  setAccountChild(AccountModel element){
    if(accountChildModelList.contains( element)){
      accountChildModelList.remove(element);
    }else{
      element.parent?.id=accountModel.value?.id;
      accountChildModelList.add(element);
    }
    print(accountChildModelList);
    update();
  }

  setAccountChildAdd(AccountModel element)async{
    element.parent?.id=accountModel.value?.id;
      accountChildModelList.add(element);
    await addChild();
    print(accountChildModelList);
    update();
  }

  setAccountChildRemove(AccountModel element){
    if(accountChildModelListRemove.contains( element)){
      accountChildModelListRemove.remove(element);
    }else{
      accountChildModelListRemove.add(element);
    }
    print(accountChildModelListRemove);
    update();
  }

  setAccountChildRemoveOne(AccountModel element)async{
    accountChildModelListRemove.add(element);
    await  removeChild();
    print(accountChildModelListRemove);
    update();
  }

  setCheckedAccount(){
    isLoading.value=!isLoading.value;
    update();
  }

  setCheckedAccountList(){
    isShowListAccount.value=!isShowListAccount.value;
    update();
  }

  void changeSelectedState(StateItemModel? newValue) {
    selectedState.value = newValue;
  }

  void changeSelectedCity(CityItemModel? newValue) {
    selectedCity.value = newValue;
  }

//   // لیست استان ها
//   Future<void> getStateList() async {
//     print("getStateList : 1");
//     stateList.clear();
//     try {
//       // state.value=PageStateUser.loading;
//       var response = await userRepository.getStateList(
//           startIndex: currentPage.value,
//           toIndex: itemsPerPage.value,
//           );
//        stateList.addAll(response);
//        if(stateList.isNotEmpty){
//          selectedState.value=stateList.first;
//        }
//      //  state.value=PageStateUser.list;
//       update();
//     }
//     catch (e) {
//      // state.value = PageStateUser.err;
//     } finally {}
//   }
// // لیست شهر ها
//   Future<void> getCityList() async {
//     print("getCityList : 1");
//     cityList.clear();
//     try {
//       // state.value=PageStateUser.loading;
//       var response = await userRepository.getCityList(
//           startIndex: currentPage.value,
//           toIndex: itemsPerPage.value,
//           );
//        cityList.addAll(response);
//        if(cityList.isNotEmpty){
//          selectedCity.value=cityList.first;
//        }
//       // state.value=PageStateUser.list;
//       update();
//     }
//     catch (e) {
//    //   state.value = PageStateUser.err;
//     } finally {}
//   }

  // لیست کاربران قابل اضافه کردن
  Future<void> fetchAccountList(String parentId) async{
    try{
      accountList.clear();
      //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getCandidateChild(parentId,currentPageAccount.value,searchController.text,itemsPerPageAccount.value,);
      accountList.assignAll(fetchedAccountList.accounts??[]);
      paginated.value=fetchedAccountList.paginated;
      //  state.value=PageState.list;
      if(accountList.isEmpty){
        //   state.value=PageState.empty;
      }
      print('تعداد55 :${accountList.length}');
    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
    }
  }

  Future<void> addChild() async{
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try{
      //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.addChild(status: accountChildModelList);
      accountChildModelList.clear();
     fetchAccountList(idUser.value.toString());
       fetchChildList(idUser.value.toString());
      //  state.value=PageState.list;
      print('تعداد55 :${accountList.length}');
    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }

  Future<void> removeChild() async{
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try{
      //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.removeChild(status: accountChildModelListRemove);
      accountChildModelListRemove.clear();
      fetchAccountList(idUser.value.toString());
      fetchChildList(idUser.value.toString());
      //  state.value=PageState.list;
      print('تعداد55 :${accountList.length}');
    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }

  // لیست زیر مجوعه ها
  Future<void> fetchChildList(String parentId) async{
    try{
      //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getChildList(parentId,currentPage.value,itemsPerPage.value);
      accountChildList.clear();
      accountChildList.assignAll(fetchedAccountList.accounts??[]);
      paginatedChild.value=fetchedAccountList.paginated;
      //  state.value=PageState.list;
      if(accountChildList.isEmpty){
        //   state.value=PageState.empty;
      }
      print('تعداد55 :${accountChildList.length}');
    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
    }
  }

  // کاربر
  Future<void> getOneUser(int id) async {
    // EasyLoading.show(
    //   status: 'لطفا صبر کنید',
    //   dismissOnTap: false,
    // );
    try {
      state.value=PageStateUser.loading;
      var response = await userRepository.getOneAccount(id: id
      );
      accountModel.value=response;
      state.value=PageStateUser.list;
      update();
    }
    catch (e) {
      state.value=PageStateUser.empty;
    } finally {
    //  EasyLoading.dismiss();
    }
  }

}