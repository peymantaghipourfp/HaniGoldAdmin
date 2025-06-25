

import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';

import '../../../domain/home/controller/home.controller.dart';

class ProductBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ProductController());
    Get.lazyPut(()=>HomeController());
  }
}