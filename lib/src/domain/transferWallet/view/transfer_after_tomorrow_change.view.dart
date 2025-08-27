import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/transferWallet/controller/transfer_after_tomorrow_change.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';

class TransferAfterTomorrowChangeView extends StatelessWidget {
  const TransferAfterTomorrowChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TransferAfterTomorrowChangeController controller =
    Get.find<TransferAfterTomorrowChangeController>();
    final bool isMobile = Get.width < 600;

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'تغییر تاریخ انتقال',
        onBackTap: () => Get.toNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Container(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child:
                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'لطفا تاریخ را انتخاب کنید';
                          }
                          return null;
                        },
                        controller: controller
                            .dateController,
                        readOnly: true,
                        style: AppTextStyle.labelText,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                              Icons.calendar_month,
                              color: AppColor
                                  .textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor
                              .textFieldColor,
                          errorMaxLines: 1,
                        ),
                        onTap: () async {
                          Jalali? pickedDate = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(
                                1400, 1, 1),
                            lastDate: Jalali(
                                1450, 12, 29),
                            initialEntryMode: PersianDatePickerEntryMode
                                .calendar,
                            initialDatePickerMode: PersianDatePickerMode
                                .day,
                            locale: Locale(
                                "fa", "IR"),
                          );
                          DateTime date = DateTime
                              .now();

                          if (pickedDate != null) {
                            controller.dateController.text =
                            "${pickedDate
                                .year}/${pickedDate
                                .month.toString()
                                .padLeft(
                                2, '0')}/${pickedDate
                                .day.toString()
                                .padLeft(
                                2, '0')} ${date.hour
                                .toString().padLeft(
                                2, '0')}:${date.minute
                                .toString().padLeft(
                                2, '0')}:${date.second
                                .toString().padLeft(
                                2, '0')}";
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Obx(() {
                        final bool disabled = controller.isLoading.value;
                        return ElevatedButton(
                          onPressed: disabled
                              ? null
                              : () async {
                            await controller.submitTransfer();
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            elevation: WidgetStateProperty.all(5),
                            backgroundColor:
                            WidgetStateProperty.all(AppColor.primaryColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'انتقال',
                            style: AppTextStyle.bodyText,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
}


