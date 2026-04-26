
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hanigold_admin/src/domain/deposit/model/socket_deposit.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/socket_inventory.model.dart';
import 'package:hanigold_admin/src/domain/notification/model/notification.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/socket_remittanceRequest.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/socket_withdraw.model.dart';
import '../../../config/const/audio.service.dart';
import '../../../config/const/socket.service.dart';
import '../../../config/const/toast.service.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/auth.repository.dart';
import '../../auth/model/user_login.model.dart';
import '../../chat/controller/chat.controller.dart';
import '../../chat/model/socket_chat.model.dart';
import '../../order/model/socket_order.model.dart';
import '../../product/model/socket_item.model.dart';

// Import controllers for data refresh
import '../../product/controller/product.controller.dart';
import '../../order/controller/order.controller.dart';
import '../../deposit/controller/deposit.controller.dart';
import '../../withdraw/controller/withdraw.controller.dart';
import '../../inventory/controller/inventory.controller.dart';
import '../../remittance/controller/remittance.controller.dart';
import '../../remittance/controller/remittance_pending.controller.dart';
import '../../notification/controller/notification.controller.dart';

class HomeController extends GetxController{
  /*final List<Map<String,dynamic>> homeListView=[
    {'text':'سفارشات','route':'/orderList'},
    {'text':'محصولات','route':'/product'},
    {'text':'کاربران','route':'/inventory'},
    {'text':'تنظیمات','route':'/tools'},
  ];*/

  SocketService socketService = Get.find<SocketService>();
  StreamSubscription? _socketSubscription;
  final AudioService _audioService = AudioService();
  final toastService = ToastService();

  final AuthRepository authRepository=AuthRepository();
  final AccountRepository accountRepository = AccountRepository();
  final TextEditingController passwordOldController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController retypePasswordController=TextEditingController();

  final Rxn<UserLoginModel> accountModel=Rxn<UserLoginModel>();
  var activeSubMenu = ''.obs; //
  final box = GetStorage();
  var bottomNavIndex = 0.obs;
  var isSocketConnected = false.obs;
  RxBool showPasswordOld = true.obs;
  RxBool showPasswordNew = true.obs;

  @override
  void onInit() {
    /*_connectToSocket();
    listenToSocket();*/
    //listenToSocket();
    super.onInit();
  }

  Future<void> connectToSocket() async {
    if (!isSocketConnected.value) {
      await _connectToSocket();
      listenToSocket();
      isSocketConnected.value = true;
    }
  }


  // Add method to disconnect socket
  Future<void> disconnectSocket() async {
    if (isSocketConnected.value) {
      _socketSubscription?.cancel();
      //await socketService.disconnect();
      isSocketConnected.value = false;
    }
  }

  Future<void> playNotificationSound() async {
    await _audioService.playNotificationSound();
  }
  Future<void> playNotificationSoundCoin() async {
    await _audioService.playNotificationSoundCoin();
  }
  Future<void> playNotificationSoundAll() async {
    await _audioService.playNotificationSoundAll();
  }
  // Helper method to refresh data based on channel
  void _refreshDataForChannel(String channel) {
    try {
      switch (channel) {
        case 'itemPrice':
        // Refresh product data if controller exists
          if (Get.isRegistered<ProductController>()) {
            Get.find<ProductController>().fetchActiveItemList();
            Get.find<ProductController>().fetchInactiveItemList();
            Get.find<ProductController>().refreshItemListsSilently();
          }
          break;
        case 'order':
        // Refresh orders data if controller exists
          if (Get.isRegistered<OrderController>()) {
            Get.find<OrderController>().getOrderListPager();
          }
          break;
        case 'deposit':
        // Refresh deposits data if controller exists
          if (Get.isRegistered<DepositController>()) {
            Get.find<DepositController>().getDepositListPager();
          }
          break;
        case 'withdrawRequest':
        // Refresh withdraw requests data if controller exists
          if (Get.isRegistered<WithdrawController>()) {
            Get.find<WithdrawController>().getWithdrawListPager();
          }
          break;
        case 'inventory':
        // Refresh inventory data if controller exists
          if (Get.isRegistered<InventoryController>()) {
            Get.find<InventoryController>().getInventoryListPager();
          }
          break;
        case 'remittance':
        // Refresh remittance data if controller exists
          if (Get.isRegistered<RemittanceController>()) {
            Get.find<RemittanceController>().getRemittanceListPager();
          }
          break;
        case 'remittanceRequest':
        // Refresh remittance requests data if controller exists
          if (Get.isRegistered<RemittancePendingController>()) {
            Get.find<RemittancePendingController>().getRemittanceListStatusPager();
          }
          break;
        case 'notification':
        // Refresh notifications data if controller exists
          if (Get.isRegistered<NotificationController>()) {
            Get.find<NotificationController>().getNotificationListPager();
          }
          break;
        case 'message':
        // Refresh chat data if controller exists
          if (Get.isRegistered<ChatController>()) {
            Get.find<ChatController>().loadChatAccountList(refresh: true);
          }
          break;
      }
    } catch (e) {
      Get.log('Error refreshing data for channel $channel: $e');
    }
  }

  Future<void> _connectToSocket() async {
    final userId = box.read('id');
    if (userId != null) {
      await socketService.ensureConnected(clientId: userId.toString());
    } else {
      await socketService.ensureConnected();
    }
  }

  void listenToSocket() {
    _socketSubscription?.cancel();
    _socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'itemPrice') {
            final socketItem = SocketItemModel.fromJson(data);
            toastService.show('قیمت ${socketItem.name} تغییر کرد');
            /*Fluttertoast.showToast(
              msg: ' قیمت ${socketItem.name} تغییر کرد',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
              webPosition: "center"
            );*/
            // Refresh product data
            _refreshDataForChannel('itemPrice');
          }else if(data['channel'] == 'order'){
            final socketOrder = SocketOrderModel.fromJson(data);
            if(socketOrder.itemName=="طلای آبشده"){
              playNotificationSound();
            }else if(socketOrder.itemName=="تمام سکه بانکی"){
              playNotificationSoundCoin();
            }
            toastService.show(' یک سفارش ${socketOrder.itemName} ثبت شد.');
            /*Fluttertoast.showToast(
              msg: ' یک سفارش ${socketOrder.itemName} ثبت شد.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }else if(data['channel'] == 'deposit'){
            final socketDeposit = SocketDepositModel.fromJson(data);
            //playNotificationSound();
            toastService.show(' یک واریزی برای ${socketDeposit.accountName} ثبت شد.');
            /*Fluttertoast.showToast(
              msg: ' یک واریزی برای ${socketDeposit.accountName} ثبت شد.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }else if(data['channel'] == 'withdrawRequest'){
            final socketWithdarw = SocketWithdrawModel.fromJson(data);
            //playNotificationSound();
            toastService.show(' یک درخواست برداشت برای ${socketWithdarw.accountName} ثبت شد.');
            /*Fluttertoast.showToast(
              msg: ' یک درخواست برداشت برای ${socketWithdarw.accountName} ثبت شد.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }else if(data['channel'] == 'inventory'){
            final socketInventory = SocketInventoryModel.fromJson(data);
            //playNotificationSound();
            toastService.show(' یک دریافت/پرداخت برای ${socketInventory.accountName} ثبت شد.');
            /*Fluttertoast.showToast(
              msg: ' یک دریافت/پرداخت برای ${socketInventory.accountName} ثبت شد.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }else if(data['channel'] == 'remittance'){
            //final socketRemittance = SocketRemittanceModel.fromJson(data);
            //playNotificationSound();
            toastService.show(' یک حواله ثبت شد.');
            /*Fluttertoast.showToast(
              msg: ' یک حواله ثبت شد.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }else if(data['channel'] == 'remittanceRequest'){
            final socketRemittanceRequest = SocketRemittanceRequestModel.fromJson(data);
            //playNotificationSound();
            toastService.show(' یک درخواست حواله برای ${socketRemittanceRequest.accountName} ثبت شد.');
            /*Fluttertoast.showToast(
              msg: ' یک درخواست حواله برای ${socketRemittanceRequest.accountName} ثبت شد.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }
          else if(data['channel'] == 'notification'){
            final socketNotification = NotificationModel.fromJson(data);
            playNotificationSoundAll();
            toastService.show(' اعلان جدید ${socketNotification.title} ');
            /*Fluttertoast.showToast(
              msg: ' اعلان جدید ${socketNotification.title} ',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }else if(data['channel'] == 'message'){
            final socketChat = SocketChatModel.fromJson(data);
            toastService.show(' پیام جدید از ${socketChat.userName} ');
            /*Fluttertoast.showToast(
              msg: ' پیام جدید از ${socketChat.userName} ',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColor.appBarColor,
              textColor: AppColor.textColor,
              fontSize: 15,
              webBgColor: "linear-gradient(to right, 0xff243748, 0xff4b749f)",
                webPosition: "center"
            );*/
          }
          else{
            print(data['channel']);
          }
          //_socketSubscription?.cancel();
        } catch (e) {
          Get.log('Error processing socket message in HomeController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in HomeController: $error');
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


  @override
  void onClose() {
    // Cleanup socket connection when controller is disposed
    disconnectSocket();
    _socketSubscription?.cancel();
    _audioService.dispose();
    super.onClose();
  }

}