import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/controller/remittance_request.controller.dart';

class RemittanceRequestBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>RemittanceRequestController());
  }
}