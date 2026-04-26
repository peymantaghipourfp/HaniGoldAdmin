import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';

class ChatBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ChatController());
  }
}