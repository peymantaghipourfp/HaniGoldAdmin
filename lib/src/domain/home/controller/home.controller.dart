
import 'package:get/get.dart';

class HomeController extends GetxController{
  /*final List<Map<String,dynamic>> homeListView=[
    {'text':'سفارشات','route':'/orderList'},
    {'text':'محصولات','route':'/product'},
    {'text':'کاربران','route':'/users'},
    {'text':'تنظیمات','route':'/tools'},
  ];*/

  var activeSubMenu = ''.obs; // نام منویی که باز است

  void toggleSubMenu(String menuName) {
    if (activeSubMenu.value == menuName) {
      activeSubMenu.value = ''; // اگر منو باز بود، بسته شود
    } else {
      activeSubMenu.value = menuName; // اگر منو بسته بود، باز شود
    }
  }

  bool isSubMenuOpen(String menuName) {
    return activeSubMenu.value == menuName;
  }
}