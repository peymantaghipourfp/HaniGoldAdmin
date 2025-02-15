
import 'package:get/get.dart';

class HomeController extends GetxController{
  final List<Map<String,dynamic>> homeListView=[
    {'text':'سفارشات','route':'/orderList'},
    {'text':'محصولات','route':'/product'},
    {'text':'کاربران','route':'/users'},
    {'text':'تنظیمات','route':'/tools'},
  ];
}