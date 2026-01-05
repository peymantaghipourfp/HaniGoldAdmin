import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/controller/invoice_preview.controller.dart';
import 'package:hanigold_admin/src/domain/users/controller/transactions_wallet_receivables.controller.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_info_date_transaction.controller.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_info_detail_gold_transaction.controller.dart';
import 'package:hanigold_admin/src/domain/users/controller/user_info_gold_transaction.controller.dart';
import 'package:hanigold_admin/src/domain/users/view/list_user_info_gold_transaction.view.dart';
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
    Get.lazyPut(()=>UserInfoGoldTransactionController());
    Get.lazyPut(()=>UserInfoDateTransactionController());
    Get.lazyPut(()=>UserInfoDetailTransactionController());
    Get.lazyPut(()=>UserInfoDetailGoldTransactionController());
    Get.lazyPut(()=>UserDetailController());
    Get.lazyPut(()=>InsertUserController());
    Get.lazyPut(()=>InvoicePreviewController());
    Get.lazyPut(()=>TransactionsWalletReceivablesController());
    //Get.lazyPut(()=>HomeController());
  }
}