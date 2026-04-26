import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/transaction/controller/balance_dialog_id.controller.dart';
import '../../../domain/transaction/controller/balance_dialog.controller.dart';
import '../../../domain/transaction/controller/transaction.controller.dart';

class TransactionBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>TransactionController());
    Get.lazyPut(() => BalanceDialogController());
    Get.lazyPut(() => BalanceDialogIdController());
    //Get.lazyPut(()=>HomeController());
  }
}