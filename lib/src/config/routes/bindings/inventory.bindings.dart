

import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_detail_insert_receive.controller.dart';

import '../../../domain/inventory/controller/inventory_create_payment.controller.dart';
import '../../../domain/inventory/controller/inventory_detail_insert_payment.controller.dart';
import '../../../domain/inventory/controller/inventory_update_payment.controller.dart';
import '../../../domain/inventory/controller/inventory_update_receive.controller.dart';

class InventoryBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>InventoryCreateReceiveController());
    Get.lazyPut(()=>InventoryCreatePaymentController());
    Get.lazyPut(()=>InventoryController());
    Get.lazyPut(()=>InventoryUpdateReceiveController());
    Get.lazyPut(()=>InventoryDetailInsertReceiveController());
    Get.lazyPut(()=>InventoryDetailInsertPaymentController());
    Get.lazyPut(()=>InventoryDetailUpdatePaymentController());
  }

}