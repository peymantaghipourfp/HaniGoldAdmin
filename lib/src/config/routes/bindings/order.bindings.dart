
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_update.controller.dart';
import 'package:hanigold_admin/src/domain/order/view/order_update.view.dart';

import '../../../domain/order/controller/order.controller.dart';

class OrderBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>OrderController());
    Get.lazyPut(()=>OrderCreateController());
    Get.lazyPut(()=>OrderUpdateController());
  }
}