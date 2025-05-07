import 'package:get/get.dart';
import '../../../domain/auth/controller/auth.controller.dart';
import '../../../domain/remittance/controller/remittance.controller.dart';
import '../../../domain/users/controller/user_info_transaction.controller.dart';

class UserInfoTransactionBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>UserInfoTransactionController());
  }

}