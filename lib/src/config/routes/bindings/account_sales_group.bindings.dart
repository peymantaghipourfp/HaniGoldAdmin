

import 'package:get/get.dart';
import '../../../domain/accountSalesGroup/controller/account_sales_group.controller.dart';
import '../../../domain/accountSalesGroup/controller/insert_account_sales_group.controller.dart';
import '../../../domain/accountSalesGroup/controller/update_account_sales_group.controller.dart';

class AccountSalesGroupBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>AccountSalesGroupController());
    Get.lazyPut(()=>InsertAccountSalesGroupController());
    Get.lazyPut(()=>UpdateAccountSalesGroupController());
  }
}