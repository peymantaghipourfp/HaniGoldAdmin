import 'package:get/get.dart';
import '../../../domain/remittance/controller/remittance.controller.dart';
import '../../../domain/remittance/controller/remittance_pending.controller.dart';

class RemittanceBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>RemittanceController());
    Get.lazyPut(()=>RemittancePendingController());
    //Get.lazyPut(()=>HomeController());
  }

}