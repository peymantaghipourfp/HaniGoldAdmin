import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/setting.repository.dart';

import 'package:hanigold_admin/src/domain/tools/model/setting.model.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';

class SettingController extends GetxController {
  final SettingRepository settingRepository = SettingRepository();

  final Rx<SettingModel?> setting = Rx<SettingModel?>(null);

  final RxBool statusSwitch = false.obs;
  final RxBool orderStatusSwitch = false.obs;
  final RxBool adminStatusSwitch = false.obs;
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final Rxn<SettingModel> getOneSetting = Rxn<SettingModel>();
  var isLoading=false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSetting();
  }

  Future<void> fetchSetting() async {
    try {
      final data = await settingRepository.getOneSetting(1);
      setting.value = data;
      statusSwitch.value = setting.value?.status ?? false;
      orderStatusSwitch.value = setting.value?.orderStatus ?? false;
      adminStatusSwitch.value = setting.value?.adminStatus ?? false;
      startTimeController.text = setting.value?.startTime ?? '';
      endTimeController.text = setting.value?.endTime ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch settings');
    }
  }

  Future<SettingModel?> updateSetting() async {
    print("statusSwitch:::${statusSwitch.value}");
    print("orderStatusSwitch:::${orderStatusSwitch.value}");
    print("startTimeController:::${startTimeController.text}");
    print("endTimeController:::${endTimeController.text}");
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoading.value = true;

      var response = await settingRepository.updateSetting(
          settingId: 1,
          status: statusSwitch.value,
          orderStatus: orderStatusSwitch.value,
          startTime: startTimeController.text,
          endTime: endTimeController.text,
      );

      if(response!= null){
        SettingModel settingResponse=SettingModel.fromJson(response);
        Get.snackbar(settingResponse.infos!.first['title'], settingResponse.infos!.first["description"],
            titleText: Text(settingResponse.infos!.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(settingResponse.infos!.first["description"] , textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchSetting();

      }

    } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در به‌روزرسانی تنظیمات: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }
  bool getSwitchValue(String label) {
    switch (label) {
      case 'باز کردن کلی سایت':
        return statusSwitch.value;
      case 'باز کردن سفارش':
        return orderStatusSwitch.value;
      default:
        return false;
    }
  }
}