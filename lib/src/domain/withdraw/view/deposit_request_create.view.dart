

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/withdraw.controller.dart';

class InsertDepositRequestWidget extends StatelessWidget {
  final int id; // شناسه‌ای که در BottomSheet نیاز دارید

  const InsertDepositRequestWidget({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // کنترلی که لازم دارید
    final withdrawController = Get.find<WithdrawController>();

    // برمی‌گردیم به همان ستونی که قبلاً در BottomSheet می‌ساختیم
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- سربرگ و دکمه بستن --
          Container(
            padding: EdgeInsets.only(right: 15, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ایجاد درخواست واریزی',
                  style: AppTextStyle.smallTitleText,
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                    withdrawController.clearList();// برای بستن BottomSheet
                  },
                  icon: Icon(Icons.close),
                  style: ButtonStyle(
                    iconColor: WidgetStatePropertyAll(AppColor.textColor),
                  ),
                )
              ],
            ),
          ),
          Divider(color: Colors.grey),

          // -- فرم اصلی --
          Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // کاربر
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'کاربر',
                      style: AppTextStyle.labelText,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Dropdown انتخاب کاربر
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "انتخاب کنید",
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: 14,
                                color: AppColor.textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: withdrawController.filterAccountList
                          .map(
                            (account) => DropdownMenuItem(
                          value: account,
                          child: Text(
                            account.name ?? "",
                            style: AppTextStyle.bodyText,
                          ),
                        ),
                      )
                          .toList(),
                      value: withdrawController.selectedAccount.value,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          withdrawController.changeSelectedAccount(newValue);
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: AppColor.textFieldColor,
                          border: Border.all(
                            color: AppColor.backGroundColor,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                      iconStyleData: IconStyleData(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 23,
                        iconEnabledColor: AppColor.textColor,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: AppColor.textFieldColor,
                        ),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(7),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // فیلد مبلغ
                  Container(
                    padding: EdgeInsets.only(bottom: 3, top: 5),
                    child: Text(
                      'مبلغ (ریال)',
                      style: AppTextStyle.labelText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(bottom: 5),
                    child: TextFormField(
                      controller:
                      withdrawController.requestAmountController,
                      style: AppTextStyle.labelText,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // حذف کاماهای قبلی و فرمت جدید
                        String cleanedValue = value.replaceAll(',', '');
                        if (cleanedValue.isNotEmpty) {
                          withdrawController.requestAmountController.text =
                              cleanedValue
                                  .toPersianDigit()
                                  .seRagham();
                          withdrawController.requestAmountController
                              .selection = TextSelection.collapsed(
                            offset: withdrawController
                                .requestAmountController
                                .text
                                .length,
                          );
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -- دکمه ایجاد در انتهای BottomSheet --
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(Get.width * .77, 40),
                  ),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 7),
                  ),
                  elevation: WidgetStatePropertyAll(5),
                  backgroundColor:
                  WidgetStatePropertyAll(AppColor.buttonColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  // فراخوانی متد درج درخواست
                  await withdrawController.insertDepositRequest(id);
                },
                child: withdrawController.isLoading.value
                    ? CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColor.textColor),
                )
                    : Text(
                  'ایجاد درخواست',
                  style: AppTextStyle.bodyText,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
