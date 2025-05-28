

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../model/balance_item.model.dart';
import '../model/city_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';


enum PageState{loading,err,empty,list}

class InsertUserController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  UserRepository userRepository=UserRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController nameController=TextEditingController();
  final TextEditingController userController=TextEditingController();
  final TextEditingController mobileController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController addressController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  RxList<StateItemModel> stateList=<StateItemModel>[].obs;
  RxList<CityItemModel> cityList=<CityItemModel>[].obs;
  late Rxn<StateItemModel> selectedState=Rxn<StateItemModel>();
  final Rxn<CityItemModel> selectedCity=Rxn<CityItemModel>();
  AccountModel? accountModel;
  var idUser=0.obs;
  var title="".obs;

  @override
  void onInit() {
    super.onInit();
    idUser.value=int.parse(Get.parameters["id"] as String);
    idUser.value!=0? getOneUser(idUser.value):null;
    idUser.value!=0? title.value="ویرایش":title.value="افزودن";
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
           name: nameController.text,
           mobile: mobileController.text,
           phoneNumber: phoneController.text,
           email: emailController.text,
           user: userController.text,
           hasDeposit:  isChecked.value,
           password: passwordController.text,
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
       mobileController.text="";
       phoneController.text="";
       emailController.text="";
       userController.text="";
       passwordController.text="";
       addressController.text="";
       state.value=PageState.list;
      update();
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
           name: nameController.text,
           mobile: mobileController.text,
           phoneNumber: phoneController.text,
           email: emailController.text,
           user: userController.text,
           hasDeposit:  isChecked.value,
           password: passwordController.text,
           state: selectedState.value?.name??"",
           idState: selectedState.value?.id??0,
           city: selectedCity.value?.name??"",
           idCity: selectedCity.value?.id??0,
           address: addressController.text, id: idUser.value
          );
       Get.back();
       Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
           titleText: Text(response.infos?.first["title"],
             textAlign: TextAlign.center,
             style: TextStyle(color: AppColor.textColor),),
           messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
       nameController.text="";
       mobileController.text="";
       phoneController.text="";
       emailController.text="";
       userController.text="";
       passwordController.text="";
       addressController.text="";
       state.value=PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {
      EasyLoading.dismiss();
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
      mobileController.text=accountModel?.contactInfos?.first.value??"";
      phoneController.text=(accountModel?.contactInfos?.length)! > 2? accountModel!.contactInfos![2].value??"":"";
      emailController.text=(accountModel?.contactInfos?.length)! > 3? accountModel!.contactInfos![3].value??"":"";
      userController.text="";
      passwordController.text="";
      addressController.text=accountModel?.addresses?.first.fullAddress??"";
      selectedState.value=accountModel?.addresses?.first.state;
      selectedCity.value=accountModel?.addresses?.first.city;

      //  print(paginated?.totalCount??0);

      update();
    }
    catch (e) {

    } finally {
      EasyLoading.dismiss();
    }
  }

}