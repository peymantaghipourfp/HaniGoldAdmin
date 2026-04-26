
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/domain/auth/model/user_login.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/socket.service.dart';
import '../../../config/repository/auth.repository.dart';
import '../view/forget_password.view.dart';
import '../service/credentials_storage.dart';

class AuthController extends GetxController{
  AuthController({
    AuthRepository? authRepository,
    CredentialsStorage? credentialsStorage,
    GetStorage? storage,
  })  : authRepository = authRepository ?? AuthRepository(),
        _credentialsStorage = credentialsStorage ?? SecureCredentialsStorage(),
        box = storage ?? GetStorage();
  final AuthRepository authRepository;
  final CredentialsStorage _credentialsStorage;
  final GetStorage box;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Rxn<UserLoginModel> accountModel = Rxn<UserLoginModel>();
  final RxBool rememberMe = false.obs;
  RxString code = "0".obs;
  RxBool isForget = false.obs;
  @override
  void onInit() {
    loadRememberedCredentials();
    super.onInit();
  }

  Future<void> loadRememberedCredentials() async {
    final shouldRemember = box.read('rememberMe') ?? false;
    rememberMe.value = shouldRemember;
    if (!shouldRemember) {
      return;
    }

    try {
      final stored = await _credentialsStorage.readCredentials();
      if (stored == null) {
        rememberMe.value = false;
        await box.write('rememberMe', false);
        return;
      }

      mobileController.text = stored.mobile;
      passwordController.text = stored.password;
    } catch (e) {
      rememberMe.value = false;
      await box.write('rememberMe', false);
      debugPrint('AuthController: Failed to load remembered credentials: $e');
    }
  }

  Future<void> updateRememberMe(bool value) async {
    rememberMe.value = value;
    await box.write('rememberMe', value);
    if (!value) {
      await _credentialsStorage.clearCredentials();
    }
  }

  Future<void> _persistRememberedCredentials() async {
    try {
      if (rememberMe.value) {
        await _credentialsStorage.saveCredentials(
          mobileController.text,
          passwordController.text,
        );
        await box.write('rememberMe', true);
      } else {
        await _credentialsStorage.clearCredentials();
        await box.write('rememberMe', false);
      }
    } catch (e) {
      debugPrint('AuthController: Failed to persist credentials: $e');
    }
  }

  Future<void> login() async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      final normalizedMobile = mobileController.text.toEnglishDigit();
      final normalizedPassword = passwordController.text.toEnglishDigit();
      mobileController.text = normalizedMobile;
      passwordController.text = normalizedPassword;
      var fetch=await authRepository.login(normalizedMobile, normalizedPassword);
      if(fetch.infos.isNotEmpty){
        Get.snackbar(fetch.infos.first["title"].toString(), fetch.infos.first["description"].toString());
      }
      if(fetch.id!=0){
      Get.offNamed('/home');
        box.write('id', fetch.user.id);
        box.write('mobile', mobileController.text);
        box.write('password', passwordController.text);
        box.write('Authorization', fetch.token);
        box.write('userName', fetch.user.contact.name);
      await _persistRememberedCredentials();

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
      await authRepository.forgetPasswordMobile(mobileController.text.toEnglishDigit());
      isForget.value=true;
       // if(fetch.infos.isNotEmpty){
       //   Get.snackbar(fetch.infos.first["title"].toString(), fetch.infos.first["description"].toString());
       // }


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
      var fetch=await authRepository.forgetPasswordVerify(mobileController.text.toEnglishDigit(),code.value.toEnglishDigit());
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