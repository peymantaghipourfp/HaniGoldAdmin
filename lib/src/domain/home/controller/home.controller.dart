
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/config/repository/url/web_socket_url.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/socket.service.dart';
import '../../../config/repository/auth.repository.dart';
import '../../account/model/account.model.dart';
import '../../auth/model/user_login.model.dart';
import '../../order/model/socket_order.model.dart';
import '../../product/model/socket_item.model.dart';

class HomeController extends GetxController{
  /*final List<Map<String,dynamic>> homeListView=[
    {'text':'سفارشات','route':'/orderList'},
    {'text':'محصولات','route':'/product'},
    {'text':'کاربران','route':'/inventory'},
    {'text':'تنظیمات','route':'/tools'},
  ];*/

  final SocketService socketService = Get.find();
  StreamSubscription? _socketSubscription;

  final AuthRepository authRepository=AuthRepository();
  final TextEditingController passwordOldController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController retypePasswordController=TextEditingController();
  final Rxn<UserLoginModel> accountModel=Rxn<UserLoginModel>();
  var activeSubMenu = ''.obs; //
  final box = GetStorage();
  var bottomNavIndex = 0.obs;

  @override
  void onInit() {
    _connectToSocket();
    _listenToSocket();
    super.onInit();
  }


  Future<void> _connectToSocket() async {
    await socketService.connect("ws://172.30.25.225:10000/ws");
  }

  void _listenToSocket() {
    _socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          print(data['channel']);
          /*if (data['channel'] == 'itemPrice') {
            final socketItem = SocketItemModel.fromJson(data);
            Get.snackbar('تغییر قیمت', 'قیمت ${socketItem.name} تغییر کرد.',
              titleText: Text('تغییر قیمت',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
              messageText: Text(
                'قیمت ${socketItem.name} تغییر کرد.', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor),),
            );
          }else if(data['channel'] == 'order'){
          final socketOrder = SocketOrderModel.fromJson(data);
          Get.snackbar('سفارش جدید', 'یک سفارش جدید ثبت شد.',
            titleText: Text('سفارش جدید',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
              'یک سفارش جدید ثبت شد.', textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
          );
          }else{
            print(data['channel']);
          }*/
        } catch (e) {
          Get.log('Error processing socket message in ProductController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in ProductController: $error');
    });
  }


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

  Future<Map<String , dynamic>?> changePassword() async{

    if(passwordController.text==retypePasswordController.text){
      try{
        EasyLoading.show(status: 'لطفا منتظر بمانید');
        var fetch=await authRepository.changePassword(box.read("mobile"),passwordController.text,passwordOldController.text,box.read("id")as int);
        print(fetch["infos"][0]["title"]);
        Get.back();
        Get.snackbar(fetch["infos"][0]["title"], fetch["infos"][0]["description"]);
      }
      catch(e){
        print("خطا در تغییر رمز عبور: $e");
        Get.snackbar("خطا", "خطا در تغییر رمز عبور: $e");
        //  state.value=PageState.err;
      }finally{
        EasyLoading.dismiss();
      }
    }else{
      Get.snackbar("رمز عبور", "عدم تطابق رمز عبور و تکرار آن");
    }
    return null;

  }

  void clearChangePasswordForm() {
    passwordController.clear();
    passwordOldController.clear();
    retypePasswordController.clear();
  }

}