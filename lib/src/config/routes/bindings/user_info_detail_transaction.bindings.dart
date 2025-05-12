import 'package:get/get.dart';
import '../../../domain/auth/controller/auth.controller.dart';
import '../../../domain/remittance/controller/remittance.controller.dart';
import '../../../domain/users/controller/user_info_detail_transaction.controller.dart';
import '../../../domain/users/controller/user_info_transaction.controller.dart';

class UserInfoDetailTransactionBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>UserInfoDetailTransactionController());
  }

}