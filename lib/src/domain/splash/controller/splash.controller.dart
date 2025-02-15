import 'package:get/get.dart';

class SplashController extends GetxController{

@override
  void onInit() {
  super.onInit();
    Future.delayed(Duration(seconds: 1),(){
      Get.offNamed('/login');
    });
  }
  /*void checkLoginStatus(){

  Get.offNamed('/home');
  }*/
}