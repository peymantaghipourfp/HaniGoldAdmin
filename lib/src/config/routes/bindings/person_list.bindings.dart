import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/balance/controller/trading_balance.controller.dart';
import '../../../domain/auth/controller/auth.controller.dart';
import '../../../domain/remittance/controller/remittance.controller.dart';
import '../../../domain/users/controller/person_list.controller.dart';
import '../../../domain/users/controller/user_info_detail_transaction.controller.dart';
import '../../../domain/users/controller/user_info_transaction.controller.dart';
import '../../../domain/users/controller/user_list.controller.dart';

class PersonListBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>PersonListController());
  }

}