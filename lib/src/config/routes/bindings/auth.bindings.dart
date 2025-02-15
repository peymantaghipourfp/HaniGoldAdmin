import 'package:get/get.dart';
import '../../../domain/auth/controller/auth.controller.dart';

class AuthBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>AuthController());
  }

}