

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/routes/bindings/auth.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/home.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/order.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/splash.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/withdraw.bindings.dart';
import 'package:hanigold_admin/src/domain/auth/view/login.view.dart';
import 'package:hanigold_admin/src/domain/deposit/view/deposits_list.dart';
import 'package:hanigold_admin/src/domain/home/view/home.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_create.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_list.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_update.view.dart';
import 'package:hanigold_admin/src/domain/product/view/item.view.dart';

import 'package:hanigold_admin/src/domain/tools/view/tools.view.dart';
import 'package:hanigold_admin/src/domain/users/view/users.view.dart';
import 'package:hanigold_admin/src/domain/wallet/view/users.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraw_create.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/withdraws_list.dart';
import '../../domain/splash/view/splash.view.dart';

class RoutePage{
  static List<GetPage> routePage=[
    GetPage(name: '/splash', page: ()=>SplashView(),binding: SplashBindings()),
    GetPage(name: '/home', page: ()=>HomeView(),binding:HomeBindings()),
    GetPage(name: '/login', page: ()=>LoginView(),binding: AuthBindings()),
    GetPage(name: '/orderList', page: ()=>OrderListView(),binding: OrderBindings()),
    GetPage(name: '/orderCreate', page: ()=>OrderCreateView(),binding: OrderBindings()),
    GetPage(name: '/orderUpdate', page: ()=>OrderUpdateView(),binding: OrderBindings()),
    GetPage(name: '/product', page: ()=>ProductView()),
    GetPage(name: '/tools', page: ()=>ToolsView()),
    GetPage(name: '/users', page: ()=>UsersView()),
    GetPage(name: '/withdrawCreate', page: ()=>WithdrawCreate()),
    GetPage(name: '/withdrawsList', page: ()=>WithdrawsList(),binding: WithdrawBindings()),
    GetPage(name: '/depositsList', page: ()=>DepositsList()),
    GetPage(name: '/wallet', page: ()=>WalletView()),

  ];
}