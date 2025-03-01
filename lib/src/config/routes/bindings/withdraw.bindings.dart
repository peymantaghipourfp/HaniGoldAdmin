
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';

class WithdrawBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>WithdrawController());
  }

}