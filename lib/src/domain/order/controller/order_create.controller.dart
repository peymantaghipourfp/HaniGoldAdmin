
import 'package:get/get.dart';

class OrderCreateController extends GetxController{

  final List<String> orderTypeList=['فروش به کاربر','خرید از کاربر'];

  final RxnString selectedValue = RxnString();
  void changeSelectedValue(String? newValue) {
    selectedValue.value = newValue;
  }


}