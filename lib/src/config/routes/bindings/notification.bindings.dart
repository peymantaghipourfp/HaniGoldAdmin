import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/notification/controller/notification.controller.dart';

class NotificationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}