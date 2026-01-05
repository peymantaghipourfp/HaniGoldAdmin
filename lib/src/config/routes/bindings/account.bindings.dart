
import 'package:get/get.dart';

import '../../../domain/account/controller/account_level.controller.dart';

class AccountBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>AccountLevelController());
  }
}
