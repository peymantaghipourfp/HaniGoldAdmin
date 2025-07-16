import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import '../../../domain/home/controller/home.controller.dart';

class HomeBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>HomeController(), fenix: true);
    //Get.lazyPut(()=>HomeController());
  }
}