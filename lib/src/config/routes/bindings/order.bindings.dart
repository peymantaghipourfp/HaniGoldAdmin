
import 'package:get/get.dart';

import '../../../domain/order/controller/order.controller.dart';

class OrderBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>OrderController());
  }

}