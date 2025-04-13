
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/deposit_request_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_create.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_update.controller.dart';

class WithdrawBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>WithdrawController());
    Get.lazyPut(()=>WithdrawCreateController());
    Get.lazyPut(()=>WithdrawUpdateController());
    Get.lazyPut(()=>WithdrawGetOneController());
    Get.lazyPut(()=>DepositRequestGetOneController());
  }

}