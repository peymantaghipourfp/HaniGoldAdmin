import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit_create.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';

import '../../../domain/deposit/controller/deposit_pending.controller.dart';
import '../../../domain/deposit/controller/deposit_update.controller.dart';
import '../../../domain/home/controller/home.controller.dart';
import '../../../domain/withdraw/controller/deposit_request_getOne.controller.dart';

class DepositBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>DepositController());
    Get.lazyPut(()=>DepositPendingController());
    Get.lazyPut(()=>DepositCreateController());
    Get.lazyPut(()=>DepositUpdateController());
    Get.lazyPut(()=>DepositRequestGetOneController());
    Get.lazyPut(()=>WithdrawController());
    //Get.lazyPut(()=>HomeController());
  }
}