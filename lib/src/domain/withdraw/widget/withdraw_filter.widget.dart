import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../config/const/app_color.dart';

class WithdrawFilterWidget extends StatelessWidget {
  final WithdrawController withdrawController;
  final bool isDesktop;

  const WithdrawFilterWidget({
    Key? key,
    required this.withdrawController,
    required this.isDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.backGroundColor,
      ),
      width: isDesktop ? Get.width * 0.2 : Get.height * 0.5,
      height: isDesktop ? Get.height * 0.6 : Get.height * 0.7,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header with title and clear filter button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'فیلتر',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 27,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColor.accentColor.withOpacity(0.5),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            side: BorderSide(color: AppColor.textColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if(isDesktop){
                          withdrawController.clearFilter();
                          withdrawController.getWithdrawListPager();
                          Get.back();
                        }else{
                          withdrawController.currentPage.value=1;
                          withdrawController.itemsPerPage.value=25;
                          withdrawController.clearFilter();
                          withdrawController.getWithdrawListPager();
                          Get.back();
                        }
                      },
                      child: Text(
                        'حذف فیلتر',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: isDesktop ? 9 : 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColor.textColor,
              height: 0.2,
            ),
            // Filter form fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  // Name field
                  _buildTextField(
                    label: 'نام',
                    controller: withdrawController.nameFilterController,
                  ),
                  SizedBox(height: 8),
                  // Owner name field
                  _buildTextField(
                    label: 'نام دارنده حساب',
                    controller: withdrawController.ownerNameFilterController,
                  ),
                  SizedBox(height: 8),
                  // Amount field
                  _buildAmountField(
                    label: 'مبلغ',
                    controller: withdrawController.amountFilterController,
                  ),
                  SizedBox(height: 8),
                  // Start date field
                  _buildDateField(
                    label: 'از تاریخ',
                    controller: withdrawController.dateStartController,
                    onTap: () async {
                      Jalali? pickedDate = await showPersianDatePicker(
                        context: context,
                        initialDate: Jalali.now(),
                        firstDate: Jalali(1400, 1, 1),
                        lastDate: Jalali(1450, 12, 29),
                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                        initialDatePickerMode: PersianDatePickerMode.day,
                        locale: Locale("fa", "IR"),
                      );
                      if (pickedDate != null) {
                        Gregorian gregorian = pickedDate.toGregorian();
                        withdrawController.startDateFilter.value =
                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                        withdrawController.dateStartController.text =
                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  // End date field
                  _buildDateField(
                    label: 'تا تاریخ',
                    controller: withdrawController.dateEndController,
                    onTap: () async {
                      Jalali? pickedDate = await showPersianDatePicker(
                        context: context,
                        initialDate: Jalali.now(),
                        firstDate: Jalali(1400, 1, 1),
                        lastDate: Jalali(1450, 12, 29),
                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                        initialDatePickerMode: PersianDatePickerMode.day,
                        locale: Locale("fa", "IR"),
                      );
                      if (pickedDate != null) {
                        Gregorian gregorian = pickedDate.toGregorian();
                        withdrawController.endDateFilter.value =
                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                        withdrawController.dateEndController.text =
                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                ],
              ),
            ),
            // Filter button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 23),
                  ),
                  backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      side: BorderSide(color: AppColor.textColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () async {
                  if(isDesktop){
                    withdrawController.getWithdrawListPager();
                    Get.back();
                  }else{
                    withdrawController.currentPage.value=1;
                    withdrawController.itemsPerPage.value=25;
                    withdrawController.getWithdrawListPager();
                    Get.back();
                  }
                },
                child: Obx(() => withdrawController.isLoading.value
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                )
                    : Text(
                  'فیلتر',
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: isDesktop ? 12 : 10,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: AppColor.textColor,
          ),
        ),
        SizedBox(height: 10),
        IntrinsicHeight(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 11,
                horizontal: 15,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              errorMaxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: AppColor.textColor,
          ),
        ),
        SizedBox(height: 10),
        IntrinsicHeight(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsSeparatorInputFormatter(),
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 11,
                horizontal: 15,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              errorMaxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: AppColor.textColor,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          child: IntrinsicHeight(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لطفا تاریخ را انتخاب کنید';
                }
                return null;
              },
              controller: controller,
              readOnly: true,
              style: AppTextStyle.labelText,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: AppColor.textFieldColor,
                errorMaxLines: 1,
              ),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove all non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Add thousand separators
    String formattedText = _addThousandsSeparator(newText);

    // Calculate the new cursor position
    int cursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _addThousandsSeparator(String text) {
    if (text.isEmpty) return text;

    // Reverse the string to add separators from right to left
    String reversed = text.split('').reversed.join('');
    String formatted = '';

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formatted += ',';
      }
      formatted += reversed[i];
    }

    // Reverse back to get the correct order
    return formatted.split('').reversed.join('');
  }
}
