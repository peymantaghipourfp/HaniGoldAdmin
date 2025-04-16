import 'package:get/get.dart';
import '../../../domain/auth/controller/auth.controller.dart';
import '../../../domain/remittance/controller/remittance.controller.dart';

class RemittanceBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>RemittanceController());
  }

}