

import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_edit.controller.dart';

import '../../../domain/home/controller/home.controller.dart';
import '../../../domain/product/controller/product_inventory.controller.dart';

class ProductBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ProductController());
    Get.lazyPut(()=>ProductEditController());
    Get.lazyPut(()=>ProductInventoryController());
    //Get.lazyPut(()=>HomeController());
  }
}