

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/account.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_list.controller.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/account_sales_group.repository.dart';
import '../../../config/repository/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../../accountSalesGroup/model/account_sales_group.model.dart';
import '../model/balance_item.model.dart';
import '../model/city_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageState{loading,err,empty,list}

class InsertUserController extends GetxController{

  var controller=Get.find<UserListController>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  UserRepository userRepository=UserRepository();
  AccountSalesGroupRepository accountSalesGroupRepository=AccountSalesGroupRepository();
  AccountRepository accountRepository=AccountRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController nameController=TextEditingController();
  final TextEditingController nationalCodeController=TextEditingController();
  final TextEditingController userController=TextEditingController();
  final TextEditingController mobileController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  //final TextEditingController passwordController=TextEditingController();
  final TextEditingController addressController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  RxList<StateItemModel> stateList=<StateItemModel>[].obs;
  RxList<CityItemModel> cityList=<CityItemModel>[].obs;
  RxList<AccountGroupModel> accountGroupList=<AccountGroupModel>[].obs;
  RxList<AccountSalesGroupModel> accountSalesGroupList=<AccountSalesGroupModel>[].obs;
  RxList<AccountLevelModel> accountLevelList=<AccountLevelModel>[].obs;
  late Rxn<StateItemModel> selectedState=Rxn<StateItemModel>();
  final Rxn<CityItemModel> selectedCity=Rxn<CityItemModel>();
  final Rxn<AccountGroupModel> selectedAccountGroup=Rxn<AccountGroupModel>();
  final Rxn<AccountSalesGroupModel> selectedAccountSalesGroup=Rxn<AccountSalesGroupModel>();
  final Rxn<AccountLevelModel> selectedAccountLevel=Rxn<AccountLevelModel>();
  AccountModel? accountModel;
  var idUser=0.obs;
  var title="".obs;
  RxInt type= 0.obs;
  RxString code= "".obs;
  RxInt accountId= 0.obs;
  RxInt contactId= 0.obs;
  RxInt contactInfoId0= 0.obs;
  RxInt contactInfoId1= 0.obs;
  RxInt contactInfoId2= 0.obs;
  RxInt addressId= 0.obs;

  @override
  void onInit() {
    super.onInit();
    idUser.value=int.parse(Get.parameters["id"] as String);
    idUser.value!=0? getOneUser(idUser.value):null;
    idUser.value!=0? title.value="ویرایش":title.value="افزودن";
    getAccountGroup();
    getAccountSalesGroupList();
    getAccountLevelList();
    getStateList();
    getCityList();
  }


  setChecked(){
    isChecked.value=!isChecked.value;
    update();
  }
  void changeSelectedState(StateItemModel? newValue) {
    selectedState.value = newValue;
  }

  void changeSelectedCity(CityItemModel? newValue) {
    selectedCity.value = newValue;
  }

  void changeSelectedAccountGroup(AccountGroupModel? newValue) {
    selectedAccountGroup.value = newValue;
  }
  void changeSelectedAccountSalesGroup(AccountSalesGroupModel? newValue) {
    selectedAccountSalesGroup.value = newValue;
  }

  void changeSelectedAccountLevel(AccountLevelModel? newValue) {
    selectedAccountLevel.value = newValue;
  }


  // لیست استان ها
  Future<void> getStateList() async {
    print("getStateList : 1");
    stateList.clear();
    try {
       state.value=PageState.loading;
      var response = await userRepository.getStateList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          );
       stateList.addAll(response);
       if(stateList.isNotEmpty){
         selectedState.value=stateList.first;
       }
       state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }
// لیست شهر ها
  Future<void> getCityList() async {
    print("getCityList : 1");
    cityList.clear();
    try {
       state.value=PageState.loading;
      var response = await userRepository.getCityList(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          );
       cityList.addAll(response);
       if(cityList.isNotEmpty){
         selectedCity.value=cityList.first;
       }
       state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // لیست گروه اکانت ها
  Future<void> getAccountGroup() async {

    accountGroupList.clear();
    try {
      state.value=PageState.loading;
      var response = await userRepository.getAccountGroup();
      accountGroupList.addAll(response);
      if(accountGroupList.isNotEmpty){
        selectedAccountGroup.value=accountGroupList.first;
      }
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // لیست گروه قیمت گذاری
  Future<void> getAccountSalesGroupList() async {
    accountSalesGroupList.clear();
    try {
      state.value=PageState.loading;
      var response = await accountSalesGroupRepository.getAccountSalesGroupList();
      accountSalesGroupList.addAll(response);
      if (accountSalesGroupList.isNotEmpty) {
        if (selectedAccountSalesGroup.value != null) {
          final match = accountSalesGroupList.firstWhereOrNull(
                  (g) => g.id == selectedAccountSalesGroup.value?.id);
          if (match != null) {
            selectedAccountSalesGroup.value = match;
          } else {
            selectedAccountSalesGroup.value =
                accountSalesGroupList.firstWhereOrNull((g) => g.isDefault == true) ??
                    accountSalesGroupList.first;
          }
        } else {
          selectedAccountSalesGroup.value =
              accountSalesGroupList.firstWhereOrNull((g) => g.isDefault == true) ??
                  accountSalesGroupList.first;
        }
      }
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

  // لیست سطوح کاربر
  Future<void> getAccountLevelList() async {
    accountLevelList.clear();
    try {
      state.value=PageState.loading;
      var response = await accountRepository.getAccountLevelList();
      accountLevelList.addAll(response);
      if (accountLevelList.isNotEmpty) {
        if (selectedAccountLevel.value != null) {
          final match = accountLevelList.firstWhereOrNull(
                  (g) => g.id == selectedAccountLevel.value?.id);
          if (match != null) {
            selectedAccountLevel.value = match;
          } else {
            selectedAccountLevel.value = accountLevelList.first;
          }
        } else {
          selectedAccountLevel.value = accountLevelList.first;
        }
      }
      state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }


  Future<void> insertUser(
      ) async {
    print("insertUser : 1");
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
       state.value=PageState.loading;
       var response = await userRepository.insertUser(
         accountGroupId: selectedAccountGroup.value?.id ?? 0,
           accountSalesGroupId: selectedAccountSalesGroup.value?.id ?? 0,
           accountLevelId: selectedAccountLevel.value?.id ?? 0,
           name: nameController.text,
           nationalCode: nationalCodeController.text,
           mobile: mobileController.text.toEnglishDigit(),
           phoneNumber: phoneController.text.toEnglishDigit(),
           email: emailController.text,
           //user: userController.text,
           hasDeposit:  isChecked.value,
           //password: passwordController.text,
           state: selectedState.value?.name??"",
           idState: selectedState.value?.id??0,
           city: selectedCity.value?.name??"",
           idCity: selectedCity.value?.id??0,
           address: addressController.text
          );
       Get.back();
       Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
           titleText: Text(response.infos?.first["title"],
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       nameController.text="";
       nationalCodeController.text="";
       mobileController.text="";
       phoneController.text="";
       emailController.text="";
       userController.text="";
       //passwordController.text="";
       addressController.text="";
       state.value=PageState.list;
       controller.getUserList();
      update();
       clearList();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateUser(
      ) async {
    print("insertUser : 1");
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
       state.value=PageState.loading;
       var response = await userRepository.updateUser(
           accountGroupId: selectedAccountGroup.value?.id ?? 0,
         accountSalesGroupId: selectedAccountSalesGroup.value?.id ?? 0,
           accountLevelId: selectedAccountLevel.value?.id ?? 0,
           name: nameController.text,
           nationalCode: nationalCodeController.text,
           mobile: mobileController.text.toEnglishDigit(),
           phoneNumber: phoneController.text.toEnglishDigit(),
           email: emailController.text,
           //user: userController.text,
           hasDeposit:  isChecked.value,
           //password: passwordController.text,
           state: selectedState.value?.name??"",
           idState: selectedState.value?.id??0,
           city: selectedCity.value?.name??"",
           idCity: selectedCity.value?.id??0,
           address: addressController.text, id: idUser.value,
         status: 1,
         type: type.value,
         code: code.value,
         accountId: accountId.value,
         contactId: contactId.value,
         contactInfoId0: contactInfoId0.value,
         contactInfoId1: contactInfoId1.value,
         contactInfoId2: contactInfoId2.value,
         //addressId: addressId.value,
          );
       Get.back();
       Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
           titleText: Text(response.infos?.first["title"],
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       nameController.text="";
       nationalCodeController.text="";
       mobileController.text="";
       phoneController.text="";
       emailController.text="";
       userController.text="";
       //passwordController.text="";
       addressController.text="";
       state.value=PageState.list;
       controller.getUserList();
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {
      EasyLoading.dismiss();
      clearList();
    }
  }

  // کاربر
  Future<void> getOneUser(int id) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await userRepository.getOneAccount(id: id
      );
      accountModel=response;
      nameController.text=accountModel?.name??"";
      nationalCodeController.text=accountModel?.nationalCode??"";

      for(int i=0;i<accountModel!.contactInfos!.length;i++){
        if(accountModel!.contactInfos![i].type==0){
          mobileController.text=accountModel?.contactInfos?[i].value??"";
          contactId.value=accountModel?.contactInfos?[i].contact?.id ?? 0;
          contactInfoId0.value=accountModel?.contactInfos?[i].id ?? 0;
          print("contactInfoId::type0:::${contactInfoId0.value=accountModel?.contactInfos?[i].id ?? 0}");
        }else  if(accountModel!.contactInfos![i].type==1){
          phoneController.text=accountModel?.contactInfos?[i].value??"";
          contactId.value=accountModel?.contactInfos?[i].contact?.id ?? 0;
          contactInfoId1.value=accountModel?.contactInfos?[i].id ?? 0;
          print("contactInfoId::type1:::${contactInfoId1.value=accountModel?.contactInfos?[i].id ?? 0}");
        }else  if(accountModel!.contactInfos![i].type==2){
          emailController.text=accountModel?.contactInfos?[i].value??"";
          contactId.value=accountModel?.contactInfos?[i].contact?.id ?? 0;
          contactInfoId2.value=accountModel?.contactInfos?[i].id ?? 0;
          print("contactInfoId::type2:::${contactInfoId2.value=accountModel?.contactInfos?[i].id ?? 0}");
        }
      }
      userController.text="";
      //passwordController.text="";
      addressController.text=accountModel?.addresses?.first.fullAddress??"";
      selectedState.value=accountModel?.addresses?.first.state;
      selectedCity.value=accountModel?.addresses?.first.city;
      selectedAccountGroup.value=accountModel?.accountGroup;
      selectedAccountSalesGroup.value=accountModel?.accountSalesGroup;
      selectedAccountLevel.value=accountModel?.accountLevel;
      type.value=accountModel?.type ?? 0;
      code.value=accountModel?.code ?? "";
      accountId.value=idUser.value;
      //addressId.value=accountModel?.addresses?.first.id ?? 0;
      //  print(paginated?.totalCount??0);

      update();
    }
    catch (e) {

    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearList() {
    nameController.clear();
    nationalCodeController.clear();
    mobileController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    selectedAccountGroup.value=null;
    selectedAccountSalesGroup.value=null;
    selectedAccountLevel.value=null;
    selectedCity.value=null;
    selectedState.value=null;
  }

}