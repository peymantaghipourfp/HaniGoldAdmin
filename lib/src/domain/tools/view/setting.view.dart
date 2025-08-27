import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/tools/controller/setting.controller.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController settingController = Get.find<SettingController>();
    final isMobile = Get.width < 600;

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'تنظیمات',
        onBackTap: () => Get.toNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Obx(() {
        if (settingController.setting.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgHaniGold.png'),
              fit: BoxFit.contain,
              opacity: 0.06,
            ),
          ),
          child: Center(
            child: Container(
              width: isMobile ? Get.width * 0.95 : Get.width * 0.55,
              padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildToggle(
                          'باز کردن کلی سایت', (val) => settingController.statusSwitch.value = val, settingController),
                      _buildToggle(
                          'باز کردن سفارش', (val) => settingController.orderStatusSwitch.value = val, settingController),
                      _buildTimeField(context, 'زمان شروع به کار سفارش',
                          settingController.startTimeController),
                      _buildTimeField(context, 'زمان اتمام کار سفارش',
                          settingController.endTimeController),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await settingController.updateSetting();
                          },
                          style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              elevation: WidgetStateProperty.all(5),
                              backgroundColor: WidgetStateProperty.all(
                                  AppColor.primaryColor),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10)))),
                          child: Text(
                            'ویرایش تنظیمات',
                            style: AppTextStyle.bodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildTimeField(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        style: AppTextStyle.bodyText,
        onTap: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          if (controller.text.isNotEmpty) {
            try {
              final parts = controller.text.split(':');
              if (parts.length == 2) {
                initialTime = TimeOfDay(
                  hour: int.parse(parts[0]),
                  minute: int.parse(parts[1]),
                );
              }
            } catch (e) {
              // Ignore invalid format, use current time
            }
          }
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: initialTime,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );
          if (picked != null) {
            controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyle.labelText,
          filled: true,
          fillColor: AppColor.backGroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(Icons.access_time),
        ),
      ),
    );
  }

  Widget _buildToggle(
      String label, Function(bool) onChanged, SettingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.bodyText),
          const SizedBox(
            width: 5,
          ),
          Obx(() {
            return Switch(
              value: controller.getSwitchValue(label),
              onChanged: onChanged,
              activeColor: AppColor.buttonColor,
            );
          }),
        ],
      ),
    );
  }
}
