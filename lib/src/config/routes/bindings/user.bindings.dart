import 'package:get/get.dart';
import '../../../domain/home/controller/home.controller.dart';
import '../../../domain/users/controller/insert_user.controller.dart';
import '../../../domain/users/controller/user_detail.controller.dart';
import '../../../domain/users/controller/user_info_detail_transaction.controller.dart';
import '../../../domain/users/controller/user_info_transaction.controller.dart';
import '../../../domain/users/controller/user_list.controller.dart';

class UserBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>UserListController());
    Get.lazyPut(()=>UserInfoTransactionController());
    Get.lazyPut(()=>UserInfoDetailTransactionController());
    Get.lazyPut(()=>UserDetailController());
    Get.lazyPut(()=>InsertUserController());
    //Get.lazyPut(()=>HomeController());
  }
}