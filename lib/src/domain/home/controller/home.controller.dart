
import 'package:get/get.dart';

class HomeController extends GetxController{
  /*final List<Map<String,dynamic>> homeListView=[
    {'text':'سفارشات','route':'/orderList'},
    {'text':'محصولات','route':'/product'},
    {'text':'کاربران','route':'/inventory'},
    {'text':'تنظیمات','route':'/tools'},
  ];*/

  var activeSubMenu = ''.obs; //

  void toggleSubMenu(String menuName) {
    if (activeSubMenu.value == menuName) {
      activeSubMenu.value = ''; //
    } else {
      activeSubMenu.value = menuName; //
    }
  }

  bool isSubMenuOpen(String menuName) {
    return activeSubMenu.value == menuName;
  }
}