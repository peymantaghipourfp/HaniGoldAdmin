import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/deposit.controller.dart';

class DepositFilterDialog extends StatelessWidget {
  final DepositController depositController;
  final bool isDesktop;

  const DepositFilterDialog({
    super.key,
    required this.depositController,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.backGroundColor,
          ),
          width: isDesktop ? Get.width * 0.25 : Get.width * 0.6,
          height: Get.height * 0.70,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildHeader(),
                  Container(
                    color: AppColor.textColor,
                    height: 0.2,
                  ),
                  _buildFilterFields(),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
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
                depositController.currentPage.value=1;
                depositController.itemsPerPage.value=25;
                depositController.clearFilter();
                depositController.getDepositListPager();
                Get.back();
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
    );
  }

  Widget _buildFilterFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 8),
          _buildNameField(),
          SizedBox(height: 8),
          _buildRequestField(),
          SizedBox(height: 8),
          _buildAmountField(),
          SizedBox(height: 8),
          _buildTrackingNumberField(),
          SizedBox(height: 8),
          _buildStartDateField(),
          SizedBox(height: 8),
          _buildEndDateField(),
          SizedBox(height: 8),
          _buildExtraDepositFilter(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نام',
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
            controller: depositController.nameDepositFilterController,
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

  Widget _buildRequestField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بابت',
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
            controller: depositController.nameRequestFilterController,
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

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مبلغ',
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
            controller: depositController.amountFilterController,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^[\d٠-٩۰-۹,]*\.?[\d٠-٩۰-۹]*$'),
              ),
              TextInputFormatter.withFunction((oldValue, newValue) {
                // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                String newText = newValue.text
                    .replaceAll('٠', '0')
                    .replaceAll('١', '1')
                    .replaceAll('٢', '2')
                    .replaceAll('٣', '3')
                    .replaceAll('٤', '4')
                    .replaceAll('٥', '5')
                    .replaceAll('٦', '6')
                    .replaceAll('٧', '7')
                    .replaceAll('٨', '8')
                    .replaceAll('٩', '9');

                // حذف کاماهای موجود برای پردازش
                String cleanText = newText.replaceAll(',', '');

                // اضافه کردن کاما به عنوان جداکننده هزارگان
                String formattedText = _formatNumberWithCommas(cleanText);

                return newValue.copyWith(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: formattedText.length),
                );
              }),
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

  Widget _buildTrackingNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'شماره پیگیری',
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
            controller: depositController.trackingNumberFilterController,
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

  Widget _buildStartDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'از تاریخ',
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
              controller: depositController.dateStartController,
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
              onTap: () async {
                Jalali? pickedDate = await showPersianDatePicker(
                  context: Get.context!,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1400, 1, 1),
                  lastDate: Jalali(1450, 12, 29),
                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                  initialDatePickerMode: PersianDatePickerMode.day,
                  locale: Locale("fa", "IR"),
                );
                if (pickedDate != null) {
                  Gregorian gregorian = pickedDate.toGregorian();
                  depositController.startDateFilter.value =
                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                  depositController.dateStartController.text =
                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تا تاریخ',
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
              controller: depositController.dateEndController,
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
              onTap: () async {
                Jalali? pickedDate = await showPersianDatePicker(
                  context: Get.context!,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1400, 1, 1),
                  lastDate: Jalali(1450, 12, 29),
                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                  initialDatePickerMode: PersianDatePickerMode.day,
                  locale: Locale("fa", "IR"),
                );
                if (pickedDate != null) {
                  Gregorian gregorian = pickedDate.toGregorian();
                  depositController.endDateFilter.value =
                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                  depositController.dateEndController.text =
                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExtraDepositFilter() {
    return Obx(() => Row(
      children: [
        Checkbox(
          value: depositController.showOnlyExtraDeposits.value,
          onChanged: (value) {
            depositController.showOnlyExtraDeposits.value = value ?? false;
          },
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'نمایش اضافه واریزی ها',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: AppColor.textColor,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 23, vertical: 19),
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
          depositController.currentPage.value=1;
          depositController.itemsPerPage.value=25;
          depositController.getDepositListPager();
          Get.back();
        },
        child: Obx(() => depositController.isLoading.value
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
    );
  }

  String _formatNumberWithCommas(String text) {
    if (text.isEmpty) return text;

    // حذف تمام کاراکترهای غیر عددی به جز نقطه
    String cleanText = text.replaceAll(RegExp(r'[^\d.]'), '');

    // اگر متن خالی است، برگردان
    if (cleanText.isEmpty) return '';

    // تقسیم به قسمت اعشار و عدد صحیح
    List<String> parts = cleanText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // اضافه کردن کاما به عدد صحیح
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    return formattedInteger + decimalPart;
  }
}
