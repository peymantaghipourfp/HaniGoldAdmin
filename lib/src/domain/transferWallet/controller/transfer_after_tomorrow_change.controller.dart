import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/transfer_wallet.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../transferWallet/model/transfer_wallet.model.dart';

class TransferAfterTomorrowChangeController extends GetxController {
  final TransferWalletRepository _transferWalletRepository = TransferWalletRepository();

  final TextEditingController dateController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    super.onInit();
  }

  Future<void> submitTransfer() async {

    EasyLoading.show(status: 'لطفا منتظر بمانید');
    isLoading.value = true;
    try {
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      final TransferWalletModel response = await _transferWalletRepository.changeTransferAfterTomorrow(gregorianDate);

      String title = 'موفق';
      String description = 'انتقال با موفقیت انجام شد';
      try {
        if (response.infos != null && response.infos!.isNotEmpty) {
          final info = response.infos!.first;
          if (info is Map) {
            title = (info['title'] ?? title).toString();
            description = (info['description'] ?? description).toString();
          }
        }
      } catch (_) {}
      if(response!=null){
        Get.snackbar(
          title,
          description,
          titleText: Text(title, textAlign: TextAlign.center, style: TextStyle(color: AppColor.textColor)),
          messageText:
          Text(description, textAlign: TextAlign.center, style: TextStyle(color: AppColor.textColor)),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      throw ErrorException('خطا در انتقال: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}


