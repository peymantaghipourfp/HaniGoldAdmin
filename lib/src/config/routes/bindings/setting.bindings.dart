import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/tools/controller/setting.controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}