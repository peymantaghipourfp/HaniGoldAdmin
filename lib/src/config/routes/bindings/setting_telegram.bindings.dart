import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/tools/controller/setting_telegram.controller.dart';

class SettingTelegramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingTelegramController());
  }
}

