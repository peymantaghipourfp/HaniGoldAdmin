
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/auth/model/user_login.model.dart';

import '../../../config/const/socket.service.dart';
import '../../../config/repository/auth.repository.dart';
import '../../../config/repository/url/web_socket_url.dart';
import '../view/forget_password.view.dart';

class AuthController extends GetxController{
  final AuthRepository authRepository=AuthRepository();
  final TextEditingController mobileController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final Rxn<UserLoginModel> accountModel=Rxn<UserLoginModel>();
  final box = GetStorage();
  RxString code = "0".obs;
  RxBool isForget = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
  Future<void> login() async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      var fetch=await authRepository.login(mobileController.text,passwordController.text);
      if(fetch.infos.isNotEmpty){
        Get.snackbar(fetch.infos.first["title"].toString(), fetch.infos.first["description"].toString());
      }
      if(fetch.id!=0){
      Get.offNamed('/home');
        box.write('id', fetch.user.id);
        box.write('mobile', mobileController.text);
        box.write('Authorization', fetch.token);
        box.write('userName', fetch.user.contact.name);
        print("userName::${fetch.user.contact.name}");
      print("writeToken:::Bearer ${fetch.token} ");
      print("userId:::Bearer ${fetch.user.id} ");
      //print("userId::: ${fetch.token} ");

      final socketService = SocketService.to;
      socketService.resetManualDisconnect();
      await socketService.ensureConnected(clientId: fetch.user.id.toString());
      socketService.send('{"clientId": "${fetch.user.id}"}');
     }else if(fetch.infos.first[""]=="2022"){
        Get.dialog(
            ForgetPasswordPage());
      }
    }

    catch(e){
      Get.snackbar('خطا', 'کاربری یا رمز عبور اشتباه می باشد');
      print(e);
      //  state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }

  Future<void> forgetPasswordMobile() async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isForget.value=false;
      var fetch=await authRepository.forgetPasswordMobile(mobileController.text);
      isForget.value=true;
       // if(fetch.infos.isNotEmpty){
       //   Get.snackbar(fetch.infos.first["title"].toString(), fetch.infos.first["description"].toString());
       // }
       print("fffff");


      update();
    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
  }

  Future<Map<String , dynamic>?> forgetPasswordVerify(BuildContext context) async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      var fetch=await authRepository.forgetPasswordVerify(mobileController.text,code.value);
      if(fetch["infos"].isNotEmpty){
        Get.snackbar(fetch["infos"][0]["title"], fetch["infos"][0]["description"]);
      }
     // if(fetch.user?.id!=null){
       Navigator.pop(context);
      isForget.value=false;
   //  }
      update();
    }
    catch(e){
      //  state.value=PageState.err;
    }finally{
      EasyLoading.dismiss();
    }
    return null;
  }
}