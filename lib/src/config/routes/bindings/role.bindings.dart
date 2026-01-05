import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/role/controller/role_cteation.controller.dart';

class RoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RoleCreationController());
  }
}