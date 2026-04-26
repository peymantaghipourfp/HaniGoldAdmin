import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/transfer_wallet.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';

enum PageState{loading,err,empty,list}
class TransferAfterTomorrowChangeController extends GetxController {
  final TransferWalletRepository _transferWalletRepository = TransferWalletRepository();

  final TextEditingController dateController = TextEditingController();
  final RxBool isLoading = false.obs;
  final List<OrderModel> orderAfterNotChangeList=<OrderModel>[].obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);

  @override
  void onInit() {
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    getAfterNotChange();
    super.onInit();
  }



  Future<List< dynamic>?> submitTransfer() async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    isLoading.value = true;
    try {
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      if (Get.isDialogOpen!) Get.back();
      var response = await _transferWalletRepository.changeTransferAfterTomorrow(gregorianDate);
      if(response.isNotEmpty) {
        final info = response.first;
        Get.snackbar(info['title'],
            info["description"],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info["description"],
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
      }
      getAfterNotChange();
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      throw ErrorException('خطا در انتقال: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }


  // لیست سفارش های انتقال داده نشده
  Future<void> getAfterNotChange() async {
    orderAfterNotChangeList.clear();
    isLoading.value=true;
    try {
      state.value=PageState.loading;
      var response = await _transferWalletRepository.getAfterNotChange();
      isLoading.value=false;
      orderAfterNotChangeList.assignAll(response);
      state.value = response.isEmpty ? PageState.empty : PageState.list;
      update();
    }
    catch (e) {
      state.value = PageState.err;
    } finally {}
  }

}


