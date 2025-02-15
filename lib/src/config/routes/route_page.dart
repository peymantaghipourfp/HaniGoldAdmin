

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/routes/bindings/auth.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/home.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/order.bindings.dart';
import 'package:hanigold_admin/src/config/routes/bindings/splash.bindings.dart';
import 'package:hanigold_admin/src/domain/auth/view/login.view.dart';
import 'package:hanigold_admin/src/domain/home/controller/home.controller.dart';
import 'package:hanigold_admin/src/domain/home/view/home.view.dart';
import 'package:hanigold_admin/src/domain/order/view/order_list.view.dart';
import 'package:hanigold_admin/src/domain/product/view/product.view.dart';
import 'package:hanigold_admin/src/domain/splash/controller/splash.controller.dart';
import 'package:hanigold_admin/src/domain/tools/view/tools.view.dart';
import 'package:hanigold_admin/src/domain/users/view/users.view.dart';
import '../../domain/splash/view/splash.view.dart';

class RoutePage{
  static List<GetPage> routePage=[
    GetPage(name: '/splash', page: ()=>SplashView(),binding: SplashBindings()),
    GetPage(name: '/home', page: ()=>HomeView(),binding:HomeBindings()),
    GetPage(name: '/login', page: ()=>LoginView(),binding: AuthBindings()),
    GetPage(name: '/orderList', page: ()=>OrderListView()),
    GetPage(name: '/product', page: ()=>ProductView()),
    GetPage(name: '/tools', page: ()=>ToolsView()),
    GetPage(name: '/users', page: ()=>UsersView()),

  ];
}