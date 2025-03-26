

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/routes/bindings/auth.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/deposit.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/home.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/inventory.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/order.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/splash.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/withdraw.bindings.dart';
import 'package:hanigold_admin/src/domain/auth/view/login.view.dart';
import 'package:hanigold_admin/src/domain/deposit/view/deposit_create.view.dart';
import 'package:hanigold_admin/src/domain/deposit/view/deposits_list.dart';
import 'package:hanigold_admin/src/domain/home/view/home.view.dart';
import 'package:hanigold_admin/src/domain/inventory/view/inventory_create.view.dart';
import 'package:hanigold_admin/src/domain/inventory/view/inventory_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_create.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_update.view.dart';
import 'package:hanigold_admin/src/domain/product/view/item_update_price.view.dart';
import 'package:hanigold_admin/src/domain/tools/view/tools.view.dart';
import 'package:hanigold_admin/src/domain/wallet/view/wallet.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_create.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_getOne.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraws_list.view.dart';
import '../../domain/splash/view/splash.view.dart';
import '../../domain/withdraw/view/deposit_request_getOne.view.dart';

class RoutePage{
  static List<GetPage> routePage=[
    GetPage(name: '/splash', page: ()=>SplashView(),binding: SplashBindings()),
    GetPage(name: '/home', page: ()=>HomeView(),binding:HomeBindings()),
    GetPage(name: '/login', page: ()=>LoginView(),binding: AuthBindings()),
    GetPage(name: '/orderList', page: ()=>OrderListView(),binding: OrderBindings()),
    GetPage(name: '/orderCreate', page: ()=>OrderCreateView(),binding: OrderBindings()),
    GetPage(name: '/orderUpdate', page: ()=>OrderUpdateView(),binding: OrderBindings()),
    GetPage(name: '/productUpdatePrice', page: ()=>ProductUpdatePriceView()),
    GetPage(name: '/tools', page: ()=>ToolsView()),
    GetPage(name: '/inventoryCreate', page: ()=>InventoryCreateView(),binding: InventoryBindings()),
    GetPage(name: '/inventoryList', page: ()=>InventoryListView(),binding: InventoryBindings()),
    GetPage(name: '/withdrawCreate', page: ()=>WithdrawCreateView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawsList', page: ()=>WithdrawsListView(),binding: WithdrawBindings()),
    GetPage(name: '/withdrawGetOne', page: ()=>WithdrawGetOneView(),binding: WithdrawBindings()),
    GetPage(name: '/depositsList', page: ()=>DepositsListView(),binding: DepositBindings()),
    GetPage(name: '/depositCreate', page: ()=>DepositCreateView(),binding: DepositBindings()),
    GetPage(name: '/depositRequestGetOne', page: ()=>DepositRequestGetOneView(),binding: WithdrawBindings()),
    GetPage(name: '/wallet', page: ()=>WalletView()),
  ];
}