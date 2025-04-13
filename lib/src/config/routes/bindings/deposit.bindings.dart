import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit_create.controller.dart';

import '../../../domain/deposit/controller/deposit_update.controller.dart';

class DepositBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>DepositController());
    Get.lazyPut(()=>DepositCreateController());
    Get.lazyPut(()=>DepositUpdateController());
  }
}