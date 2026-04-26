import 'package:get/get.dart';
import '../../../domain/home/controller/home_tabs.controller.dart';

class HomeBindings implements Bindings{
  @override
  void dependencies() {
    //Get.lazyPut(()=>HomeController(), fenix: true);
    //Get.lazyPut(()=>HomeController());
    if (!Get.isRegistered<HomeTabsController>()) {
      Get.put(HomeTabsController(), permanent: true);
    }
  }
}