

import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create.controller.dart';

class InventoryBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>InventoryCreateController());
    Get.lazyPut(()=>InventoryController());
  }

}