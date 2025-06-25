

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/routes/bindings/auth.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/deposit.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/home.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/inventory.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/order.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/person_list.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/product.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/remittance.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/splash.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/user.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/withdraw.bindings.dart';
import 'package:hanigold_admin/src/domain/auth/view/login.view.dart';
import 'package:hanigold_admin/src/domain/deposit/view/deposit_create.view.dart';
import 'package:hanigold_admin/src/domain/deposit/view/deposits_list.dart';
import 'package:hanigold_admin/src/domain/home/view/home.view.dart';
import 'package:hanigold_admin/src/domain/inventory/view/inventory_create.view.dart';
import 'package:hanigold_admin/src/domain/inventory/view/inventory_detail_insert_receive.view.dart';
import 'package:hanigold_admin/src/domain/inventory/view/inventory_detail_update_receive.view.dart';
import 'package:hanigold_admin/src/domain/inventory/view/inventory_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_create.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_update.view.dart';
import 'package:hanigold_admin/src/domain/product/view/item_update_price.view.dart';
import 'package:hanigold_admin/src/domain/tools/view/tools.view.dart';
import 'package:hanigold_admin/src/domain/users/view/insert_user.view.dart';
import 'package:hanigold_admin/src/domain/users/view/list_user.view.dart';
import 'package:hanigold_admin/src/domain/users/view/person_list.view.dart';
import 'package:hanigold_admin/src/domain/wallet/view/wallet.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_create.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_getOne.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraws_list.view.dart';
import '../../domain/balance/view/trading_balance.view.dart';
import '../../domain/deposit/view/deposit_update.view.dart';
import '../../domain/home/view/more.view.dart';
import '../../domain/inventory/view/inventory_detail_insert_payment.view.dart';
import '../../domain/inventory/view/inventory_detail_update_payment.view.dart';
import '../../domain/laboratory/view/laboratory.view.dart';
import '../../domain/remittance/view/insert_remittance.view.dart';
import '../../domain/remittance/view/remittance.view.dart';
import '../../domain/remittance/view/update_remittance.view.dart';
import '../../domain/splash/view/splash.view.dart';
import '../../domain/transaction/view/transaction.view.dart';
import '../../domain/users/view/list_user_info_transaction.view.dart';
import '../../domain/users/view/user_detail.view.dart';
import '../../domain/users/view/user_info_transaction.view.dart';
import '../../domain/withdraw/view/deposit_request_getOne.view.dart';
import '../../domain/withdraw/view/withdraw_update.view.dart';
import 'bindings/laboratory.bindings.dart';
import 'bindings/trading_balance.bindings.dart';
import 'bindings/transaction.bindings.dart';

class RoutePage{
  static List<GetPage> routePage=[
    GetPage(name: '/splash', page: ()=>SplashView(),binding: SplashBindings()),
    GetPage(name: '/home', page: ()=>HomeView(),binding:HomeBindings()),
    GetPage(name: '/more', page: ()=>MoreView(),binding:HomeBindings()),
    GetPage(name: '/login', page: ()=>LoginView(),binding: AuthBindings()),
    GetPage(name: '/orderList', page: ()=>OrderListView(),binding: OrderBindings()),
    GetPage(name: '/orderCreate', page: ()=>OrderCreateView(),binding: OrderBindings()),
    GetPage(name: '/orderUpdate', page: ()=>OrderUpdateView(),binding: OrderBindings()),
    GetPage(name: '/productUpdatePrice', page: ()=>ProductUpdatePriceView(),binding: ProductBindings()),
    GetPage(name: '/tools', page: ()=>ToolsView()),
    GetPage(name: '/inventoryCreate', page: ()=>InventoryCreateView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryList', page: ()=>InventoryListView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailInsertReceive', page: ()=>InventoryDetailInsertReceiveView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailInsertPayment', page: ()=>InventoryDetailInsertPaymentView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailUpdateReceive', page: ()=>InventoryDetailUpdateReceiveView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailUpdatePayment', page: ()=>InventoryDetailUpdatePaymentView(),binding: InventoryBindings()),
    GetPage(name: '/withdrawCreate', page: ()=>WithdrawCreateView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawUpdate', page: ()=>WithdrawUpdateView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawsList', page: ()=>WithdrawsListView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawGetOne', page: ()=>WithdrawGetOneView(),binding: WithdrawBindings()),
    GetPage(name: '/depositsList', page: ()=>DepositsListView(),binding: DepositBindings()),
    GetPage(name: '/depositCreate', page: ()=>DepositCreateView(),binding: DepositBindings()),
    GetPage(name: '/depositUpdate', page: ()=>DepositUpdateView(),binding: DepositBindings()),
    GetPage(name: '/depositRequestGetOne', page: ()=>DepositRequestGetOneView(),binding: WithdrawBindings()),
    GetPage(name: '/wallet', page: ()=>WalletView()),
    GetPage(name: '/remittance', page: ()=>RemittanceView(),binding: RemittanceBindings()),
    GetPage(name: '/insertRemittance', page: ()=>InsertRemittanceView(),binding: RemittanceBindings()),
    GetPage(name: '/updateRemittance', page: ()=>UpdateRemittanceView(),binding: RemittanceBindings()),
    GetPage(name: '/userInfoTransaction', page: ()=>UserInfoTransactionView(),binding: UserBindings()),
    GetPage(name: '/listUserInfoTransaction', page: ()=>ListUserInfoTransactionView(),binding: UserBindings()),
    GetPage(name: '/tradingBalance', page: ()=>TradingBalanceView(),binding: TradingBalanceBindings()),
    GetPage(name: '/userList', page: ()=>UserListView(),binding: UserBindings()),
    GetPage(name: '/insertUser', page: ()=>InsertUserView(),binding: UserBindings()),
    GetPage(name: '/laboratory', page: ()=>LaboratoryView(),binding: LaboratoryBindings()),
    GetPage(name: '/personList', page: ()=>PersonListView(),binding: PersonListBindings()),
    GetPage(name: '/userDetail', page: ()=>UserDetailView(),binding: UserBindings()),
    GetPage(name: '/transactionList', page: ()=>TransactionView(),binding: TransactionBindings()),
  ];
}