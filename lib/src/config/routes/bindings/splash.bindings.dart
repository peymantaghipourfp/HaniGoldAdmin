

import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/splash/controller/splash.controller.dart';

class SplashBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>SplashController());
  }

}