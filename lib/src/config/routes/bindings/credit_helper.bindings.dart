import 'package:get/get.dart';
import '../../../domain/creditHelper/controller/credit_helper.controller.dart';

class CreditHelperBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreditHelperController());
  }
}
