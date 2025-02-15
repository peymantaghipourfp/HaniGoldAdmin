import 'package:get/get.dart';
import '../../../domain/home/controller/home.controller.dart';

class HomeBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>HomeController());
  }

}