

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/routes/bindings/auth.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/deposit.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/home.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/inventory.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/order.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/person_list.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/product.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/remittance.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/setting.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/splash.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/user.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/withdraw.bindings.dart';
import 'package:hanigold_admin/src/widget/main_layout.widget.dart';
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
import 'package:hanigold_admin/src/domain/tools/view/setting.view.dart';
import 'package:hanigold_admin/src/domain/users/view/insert_user.view.dart';
import 'package:hanigold_admin/src/domain/users/view/list_user.view.dart';
import 'package:hanigold_admin/src/domain/users/view/person_list.view.dart';
import 'package:hanigold_admin/src/domain/wallet/view/wallet.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_create.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_getOne.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraws_list.view.dart';
import '../../domain/balance/view/trading_balance.view.dart';
import '../../domain/deposit/view/deposit_pending_list.view.dart';
import '../../domain/deposit/view/deposit_update.view.dart';
import '../../domain/home/view/more.view.dart';
import '../../domain/inventory/view/inventory_detail_insert_payment.view.dart';
import '../../domain/inventory/view/inventory_detail_update_payment.view.dart';
import '../../domain/laboratory/view/laboratory.view.dart';
import '../../domain/product/view/product_edit.view.dart';
import '../../domain/remittance/view/insert_remittance.view.dart';
import '../../domain/remittance/view/remittance.view.dart';
import '../../domain/remittance/view/remittance_pending_list.view.dart';
import '../../domain/remittance/view/update_remittance.view.dart';
import '../../domain/splash/view/splash.view.dart';
import '../../domain/transaction/view/transaction.view.dart';
import '../../domain/users/view/list_user_info_transaction.view.dart';
import '../../domain/users/view/user_detail.view.dart';
import '../../domain/users/view/user_info_transaction.view.dart';
import '../../domain/withdraw/view/deposit_request_getOne.view.dart';
import '../../domain/withdraw/view/withdraw_pending_list.view.dart';
import '../../domain/withdraw/view/withdraw_update.view.dart';
import 'bindings/laboratory.bindings.dart';
import 'bindings/trading_balance.bindings.dart';
import 'bindings/transaction.bindings.dart';

class RoutePage{
  static List<GetPage> routePage=[
    // Pages without sidebar (auth pages)
    GetPage(name: '/splash', page: ()=>SplashView(),binding: SplashBindings()),
    GetPage(name: '/login', page: ()=>LoginView(),binding: AuthBindings()),

    // Admin pages with fixed sidebar
    GetPage(name: '/home', page: ()=>MainLayout(child: HomeView()),binding:HomeBindings()),
    GetPage(name: '/more', page: ()=>MainLayout(child: MoreView()),binding:HomeBindings()),
    GetPage(name: '/orderList', page: ()=>MainLayout(child: OrderListView()),binding: OrderBindings()),
    GetPage(name: '/orderCreate', page: ()=>MainLayout(child: OrderCreateView()),binding: OrderBindings()),
    GetPage(name: '/orderUpdate', page: ()=>MainLayout(child: OrderUpdateView()),binding: OrderBindings()),
    GetPage(name: '/productUpdatePrice', page: ()=>MainLayout(child: ProductUpdatePriceView()),binding: ProductBindings()),
    GetPage(name: '/productEdit', page: ()=>MainLayout(child: ProductEditView()),binding: ProductBindings()),
    GetPage(name: '/setting', page: ()=>MainLayout(child: SettingView()),binding: SettingBinding()),
    GetPage(name: '/inventoryCreate', page: ()=>MainLayout(child: InventoryCreateView()),binding: InventoryBindings()),
    GetPage(name: '/inventoryList', page: ()=>MainLayout(child: InventoryListView()),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailInsertReceive', page: ()=>MainLayout(child: InventoryDetailInsertReceiveView()),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailInsertPayment', page: ()=>MainLayout(child: InventoryDetailInsertPaymentView()),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailUpdateReceive', page: ()=>MainLayout(child: InventoryDetailUpdateReceiveView()),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailUpdatePayment', page: ()=>MainLayout(child: InventoryDetailUpdatePaymentView()),binding: InventoryBindings()),
    GetPage(name: '/withdrawCreate', page: ()=>MainLayout(child: WithdrawCreateView()),binding: WithdrawBindings()),
    GetPage(name: '/withdrawUpdate', page: ()=>MainLayout(child: WithdrawUpdateView()),binding: WithdrawBindings()),
    GetPage(name: '/withdrawsList', page: ()=>MainLayout(child: WithdrawsListView()),binding: WithdrawBindings()),
    GetPage(name: '/withdrawsPendingList', page: ()=>MainLayout(child: WithdrawsPendingListView()),binding: WithdrawBindings()),
    GetPage(name: '/withdrawGetOne', page: ()=>MainLayout(child: WithdrawGetOneView()),binding: WithdrawBindings()),
    GetPage(name: '/depositsList', page: ()=>MainLayout(child: DepositsListView()),binding: DepositBindings()),
    GetPage(name: '/depositsPendingList', page: ()=>MainLayout(child: DepositsPendingListView()),binding: DepositBindings()),
    GetPage(name: '/depositCreate', page: ()=>MainLayout(child: DepositCreateView()),binding: DepositBindings()),
    GetPage(name: '/depositUpdate', page: ()=>MainLayout(child: DepositUpdateView()),binding: DepositBindings()),
    GetPage(name: '/depositRequestGetOne', page: ()=>MainLayout(child: DepositRequestGetOneView()),binding: WithdrawBindings()),
    GetPage(name: '/wallet', page: ()=>MainLayout(child: WalletView())),
    GetPage(name: '/remittance', page: ()=>MainLayout(child: RemittanceView()),binding: RemittanceBindings()),
    GetPage(name: '/remittancesPendingList', page: ()=>MainLayout(child: RemittancesPendingListView()),binding: RemittanceBindings()),
    GetPage(name: '/insertRemittance', page: ()=>MainLayout(child: InsertRemittanceView()),binding: RemittanceBindings()),
    GetPage(name: '/updateRemittance', page: ()=>MainLayout(child: UpdateRemittanceView()),binding: RemittanceBindings()),
    GetPage(name: '/userInfoTransaction', page: ()=>MainLayout(child: UserInfoTransactionView()),binding: UserBindings()),
    GetPage(name: '/listUserInfoTransaction', page: ()=>MainLayout(child: ListUserInfoTransactionView()),binding: UserBindings()),
    GetPage(name: '/tradingBalance', page: ()=>MainLayout(child: TradingBalanceView()),binding: TradingBalanceBindings()),
    GetPage(name: '/userList', page: ()=>MainLayout(child: UserListView()),binding: UserBindings()),
    GetPage(name: '/insertUser', page: ()=>MainLayout(child: InsertUserView()),binding: UserBindings()),
    GetPage(name: '/laboratory', page: ()=>MainLayout(child: LaboratoryView()),binding: LaboratoryBindings()),
    GetPage(name: '/personList', page: ()=>MainLayout(child: PersonListView()),binding: PersonListBindings()),
    GetPage(name: '/userDetail', page: ()=>MainLayout(child: UserDetailView()),binding: UserBindings()),
    GetPage(name: '/transactionList', page: ()=>MainLayout(child: TransactionView()),binding: TransactionBindings()),
  ];
}
