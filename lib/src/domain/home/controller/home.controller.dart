
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../config/repository/auth.repository.dart';
import '../../account/model/account.model.dart';
import '../../auth/model/user_login.model.dart';

class HomeController extends GetxController{
  /*final List<Map<String,dynamic>> homeListView=[
    {'text':'سفارشات','route':'/orderList'},
    {'text':'محصولات','route':'/product'},
    {'text':'کاربران','route':'/inventory'},
    {'text':'تنظیمات','route':'/tools'},
  ];*/
  final AuthRepository authRepository=AuthRepository();
  final TextEditingController passwordOldController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController retypePasswordController=TextEditingController();
  final Rxn<UserLoginModel> accountModel=Rxn<UserLoginModel>();
  var activeSubMenu = ''.obs; //
  final box = GetStorage();
  var bottomNavIndex = 0.obs;
  void toggleSubMenu(String menuName) {
    if (activeSubMenu.value == menuName) {
      activeSubMenu.value = ''; //
    } else {
      activeSubMenu.value = menuName; //
    }
  }

  bool isSubMenuOpen(String menuName) {
    return activeSubMenu.value == menuName;
  }

  Future<Map<String , dynamic>?> changePassword() async{

    if(passwordController.text==retypePasswordController.text){
      try{
        EasyLoading.show(status: 'لطفا منتظر بمانید');
        var fetch=await authRepository.changePassword(box.read("mobile"),passwordController.text,passwordOldController.text,box.read("id")as int);
        print(fetch["infos"][0]["title"]);
        Get.back();
        Get.snackbar(fetch["infos"][0]["title"], fetch["infos"][0]["description"]);
      }
      catch(e){
        print("خطا در تغییر رمز عبور: $e");
        Get.snackbar("خطا", "خطا در تغییر رمز عبور: $e");
        //  state.value=PageState.err;
      }finally{
        EasyLoading.dismiss();
      }
    }else{
      Get.snackbar("رمز عبور", "عدم تطابق رمز عبور و تکرار آن");
    }
    return null;

  }

  void clearChangePasswordForm() {
    passwordController.clear();
    passwordOldController.clear();
    retypePasswordController.clear();
  }
}