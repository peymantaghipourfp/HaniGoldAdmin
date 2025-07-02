import 'package:get/get.dart';
import '../../../domain/home/controller/home.controller.dart';
import '../../../domain/transaction/controller/transaction.controller.dart';
import '../../../domain/users/controller/insert_user.controller.dart';
import '../../../domain/users/controller/user_detail.controller.dart';
import '../../../domain/users/controller/user_info_detail_transaction.controller.dart';
import '../../../domain/users/controller/user_info_transaction.controller.dart';
import '../../../domain/users/controller/user_list.controller.dart';

class TransactionBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>TransactionController());
    Get.lazyPut(()=>HomeController());
  }
}