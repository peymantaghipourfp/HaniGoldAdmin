

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/routes/bindings/analyticalReports.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/auth.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/deposit.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/home.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/inventory.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/order.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/person_list.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/product.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/remittance.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/remittance_request.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/role.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/setting.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/splash.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/account_sales_group.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/transfer_wallet.bindings.dart';
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
import 'package:hanigold_admin/src/domain/notification/view/insert_notification.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_byAccount_report_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_create.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_edited_report_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_update.view.dart';
import 'package:hanigold_admin/src/domain/product/view/item_update_price.view.dart';
import 'package:hanigold_admin/src/domain/product/view/product_inventory_quantity.view.dart';
import 'package:hanigold_admin/src/domain/role/view/role_creation.view.dart';
import 'package:hanigold_admin/src/domain/accountSalesGroup/view/account_sales_group.view.dart';
import 'package:hanigold_admin/src/domain/tools/view/setting.view.dart';
import 'package:hanigold_admin/src/domain/transferWallet/view/transfer_wallet_list.view.dart';
import 'package:hanigold_admin/src/domain/users/view/insert_user.view.dart';
import 'package:hanigold_admin/src/domain/users/view/list_user.view.dart';
import 'package:hanigold_admin/src/domain/users/view/list_user_info_date_transaction.view.dart';
import 'package:hanigold_admin/src/domain/users/view/list_user_info_gold_transaction.view.dart';
import 'package:hanigold_admin/src/domain/users/view/person_list.view.dart';
import 'package:hanigold_admin/src/domain/users/view/transactions_wallet_receivables.view.dart';
import 'package:hanigold_admin/src/domain/users/view/user_info_gold_transaction.view.dart';
import 'package:hanigold_admin/src/domain/wallet/view/wallet.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_create.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_getOne.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraws_list.view.dart';
import '../../domain/account/view/account_level.view.dart';
import '../../domain/analyticalReports/view/candle_price_chart.view.dart';
import '../../domain/analyticalReports/view/statistics_report.view.dart';
import '../../domain/balance/view/trading_balance.view.dart';
import '../../domain/creditHelper/view/credit_helper_list.view.dart';
import '../../domain/deposit/view/deposit_pending_list.view.dart';
import '../../domain/deposit/view/deposit_update.view.dart';
import '../../domain/home/view/more.view.dart';
import '../../domain/inventory/view/inventory_detail_insert_payment.view.dart';
import '../../domain/inventory/view/inventory_detail_update_payment.view.dart';
import '../../domain/laboratory/view/laboratory.view.dart';
import '../../domain/notification/view/notification.view.dart';
import '../../domain/product/view/product_edit.view.dart';
import '../../domain/product/view/product_inventory.view.dart';
import '../../domain/remittance/view/insert_remittance.view.dart';
import '../../domain/remittance/view/remittance.view.dart';
import '../../domain/remittance/view/remittance_pending_list.view.dart';
import '../../domain/remittance/view/remittance_request_list.view.dart';
import '../../domain/remittance/view/update_remittance.view.dart';
import '../../domain/splash/view/splash.view.dart';
import '../../domain/accountSalesGroup/view/insert_account_sales_group.view.dart';
import '../../domain/accountSalesGroup/view/update_account_sales_group.view.dart';
import '../../domain/tools/view/setting_telegram.view.dart';
import '../../domain/transaction/view/transaction.view.dart';
import '../../domain/transferWallet/view/transfer_after_tomorrow_change.view.dart';
import '../../domain/users/view/invoice_preview.view.dart';
import '../../domain/users/view/list_user_info_transaction.view.dart';
import '../../domain/users/view/user_detail.view.dart';
import '../../domain/users/view/user_info_transaction.view.dart';
import '../../domain/withdraw/view/deposit_request_getOne.view.dart';
import '../../domain/withdraw/view/withdraw_pending_list.view.dart';
import '../../domain/withdraw/view/withdraw_update.view.dart';
import 'bindings/account.bindings.dart';
import 'bindings/credit_helper.bindings.dart';
import 'bindings/laboratory.bindings.dart';
import 'bindings/notification.bindings.dart';
import 'bindings/setting_telegram.bindings.dart';
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
    GetPage(name: '/orderByAccountReportList', page: ()=>OrderByAccountReportListView(),binding: OrderBindings()),
    GetPage(name: '/orderEditedReportList', page: ()=>OrderEditedReportListView(),binding: OrderBindings()),
    GetPage(name: '/statisticsReportList', page: ()=>StatisticsReportView(),binding: AnalyticalReportsBindings()),
    GetPage(name: '/candlePriceChart', page: ()=>CandlePriceChartView(),binding: AnalyticalReportsBindings()),
    GetPage(name: '/productUpdatePrice', page: ()=>ProductUpdatePriceView(),binding: ProductBindings()),
    GetPage(name: '/productEdit', page: ()=>ProductEditView(),binding: ProductBindings()),
    GetPage(name: '/productInventory', page: ()=>ProductInventoryView(),binding: ProductBindings()),
    GetPage(name: '/productInventoryQuantity', page: ()=>ProductInventoryQuantityView(),binding: ProductBindings()),
    GetPage(name: '/setting', page: ()=>SettingView(),binding: SettingBinding()),
    GetPage(name: '/settingTelegram', page: ()=>SettingTelegramView(),binding: SettingTelegramBinding()),
    GetPage(name: '/inventoryCreate', page: ()=>InventoryCreateView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryList', page: ()=>InventoryListView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailInsertReceive', page: ()=>InventoryDetailInsertReceiveView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailInsertPayment', page: ()=>InventoryDetailInsertPaymentView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailUpdateReceive', page: ()=>InventoryDetailUpdateReceiveView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryDetailUpdatePayment', page: ()=>InventoryDetailUpdatePaymentView(),binding: InventoryBindings()),
    GetPage(name: '/withdrawCreate', page: ()=>WithdrawCreateView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawUpdate', page: ()=>WithdrawUpdateView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawsList', page: ()=>WithdrawsListView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawsPendingList', page: ()=>WithdrawsPendingListView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawGetOne', page: ()=>WithdrawGetOneView(),binding: WithdrawBindings()),
    GetPage(name: '/depositsList', page: ()=>DepositsListView(),binding: DepositBindings()),
    GetPage(name: '/depositsPendingList', page: ()=>DepositsPendingListView(),binding: DepositBindings()),
    GetPage(name: '/depositCreate', page: ()=>DepositCreateView(),binding: DepositBindings()),
    GetPage(name: '/depositUpdate', page: ()=>DepositUpdateView(),binding: DepositBindings()),
    GetPage(name: '/depositRequestGetOne', page: ()=>DepositRequestGetOneView(),binding: WithdrawBindings()),
    GetPage(name: '/wallet', page: ()=>WalletView()),
    GetPage(name: '/remittance', page: ()=>RemittanceView(),binding: RemittanceBindings()),
    GetPage(name: '/remittancesPendingList', page: ()=>RemittancesPendingListView(),binding: RemittanceBindings()),
    GetPage(name: '/remittancesRequestList', page: ()=>RemittanceRequestListView(),binding: RemittanceRequestBindings()),
    GetPage(name: '/insertRemittance', page: ()=>InsertRemittanceView(),binding: RemittanceBindings()),
    GetPage(name: '/updateRemittance', page: ()=>UpdateRemittanceView(),binding: RemittanceBindings()),
    GetPage(name: '/userInfoTransaction', page: ()=>UserInfoTransactionView(),binding: UserBindings()),
    GetPage(name: '/userInfoGoldTransaction', page: ()=>UserInfoGoldTransactionView(),binding: UserBindings()),
    GetPage(name: '/userInfoDateTransaction', page: ()=>ListUserInfoDateTransactionView(),binding: UserBindings()),
    GetPage(name: '/transactionsWalletReceivables', page: ()=>TransactionsWalletReceivablesView(),binding: UserBindings()),
    GetPage(name: '/listUserInfoTransaction', page: ()=>ListUserInfoTransactionView(),binding: UserBindings()),
    GetPage(name: '/listUserInfoGoldTransaction', page: ()=>ListUserInfoGoldTransactionView(),binding: UserBindings()),
    GetPage(name: '/invoicePreview', page: ()=>InvoicePreviewView(),binding: UserBindings()),
    GetPage(name: '/tradingBalance', page: ()=>TradingBalanceView(),binding: TradingBalanceBindings()),
    GetPage(name: '/userList', page: ()=>UserListView(),binding: UserBindings()),
    GetPage(name: '/insertUser', page: ()=>InsertUserView(),binding: UserBindings()),
    GetPage(name: '/accountLevelList', page: ()=>AccountLevelView(),binding: AccountBindings()),
    GetPage(name: '/laboratory', page: ()=>LaboratoryView(),binding: LaboratoryBindings()),
    GetPage(name: '/personList', page: ()=>PersonListView(),binding: PersonListBindings()),
    GetPage(name: '/userDetail', page: ()=>UserDetailView(),binding: UserBindings()),
    GetPage(name: '/transactionList', page: ()=>TransactionView(),binding: TransactionBindings()),
    GetPage(name: '/transferWalletList', page: ()=>TransferWalletListView(),binding: TransferWalletBindings()),
    GetPage(name: '/transferAfterTomorrowChange', page: ()=>TransferAfterTomorrowChangeView(),binding: TransferWalletBindings()),
    GetPage(name: '/notificationList', page: ()=>NotificationView(),binding: NotificationBindings()),
    GetPage(name: '/insertNotification', page: ()=>InsertNotificationView.fromRoute(),binding: NotificationBindings()),
    GetPage(name: '/roleCreation', page: ()=>RoleCreationView(),binding: RoleBinding()),
    GetPage(name: '/accountSalesGroupList', page: ()=>AccountSalesGroupView(),binding: AccountSalesGroupBindings()),
    GetPage(name: '/insertAccountSalesGroup', page: ()=>InsertAccountSalesGroupView(),binding: AccountSalesGroupBindings()),
    GetPage(name: '/updateAccountSalesGroup', page: ()=>UpdateAccountSalesGroupView(),binding: AccountSalesGroupBindings()),
    GetPage(name: '/creditHelperList', page: ()=>CreditHelperListView(),binding: CreditHelperBindings()),
  ];
}