
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/auth/model/user.model.dart';

import '../../../config/repository/auth.repository.dart';

class AuthController extends GetxController{
  final AuthRepository authRepository=AuthRepository();
  final TextEditingController mobileController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final Rxn<UserModel> accountModel=Rxn<UserModel>();
  final box = GetStorage();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
  Future<void> login() async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      var fetch=await authRepository.login(mobileController.text,passwordController.text);
      Get.snackbar(fetch.infos!.first["title"].toString(), fetch.infos!.first["description"].toString());
      if(fetch.user!.id!=null){
        box.write('id', fetch.id??"");
        box.write('mobile', mobileController.text);
        Get.toNamed('/home');
      }

    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }
}