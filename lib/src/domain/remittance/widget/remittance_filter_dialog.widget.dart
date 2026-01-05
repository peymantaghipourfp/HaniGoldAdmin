import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../product/model/item.model.dart';
import '../controller/remittance.controller.dart';

class RemittanceFilterDialog extends StatelessWidget {
  final RemittanceController controller;

  const RemittanceFilterDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.backGroundColor,
          ),
          width: isDesktop ? Get.width * 0.3 : Get.width * 0.7,
          height: isDesktop ? Get.height * 0.75 : Get.height * 0.75,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 20,vertical: 8),
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
                        height:  27,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              AppColor.accentColor.withAlpha(130),
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
                              controller.clearFilter();
                              controller.getRemittanceListPager();
                              Get.back();
                            }else{
                              controller.currentPage.value=1;
                              controller.itemsPerPage.value=25;
                              controller.clearFilter();
                              controller.getRemittanceListPager();
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      // نام بدهکار
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نام بدهکار',
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
                              controller: controller.namePayerController,
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
                      ),
                      SizedBox(height: 8),
                      // نام بستانکار
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نام بستانکار',
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
                              controller: controller.nameRecieptController,
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
                      ),
                      SizedBox(height: 8),
                      // از تاریخ
                      Column(
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
                                controller: controller.dateStartController,
                                readOnly: true,
                                style: AppTextStyle.labelText,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: AppColor.textColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
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
                                  Gregorian gregorian = pickedDate!.toGregorian();
                                  controller.startDateFilter.value =
                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                  controller.dateStartController.text =
                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // تا تاریخ
                      Column(
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
                                controller: controller.dateEndController,
                                readOnly: true,
                                style: AppTextStyle.labelText,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: AppColor.textColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
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
                                  Gregorian gregorian = pickedDate!.toGregorian();
                                  controller.endDateFilter.value =
                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                  controller.dateEndController.text =
                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // مقدار (Quantity) Filter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مقدار',
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
                              controller: controller.quantityFilterController,
                              style: AppTextStyle.labelText.copyWith(fontSize: 15),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
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
                      ),
                      SizedBox(height: 8),
                      // محصول (Product/Item) Filter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'محصول',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: AppColor.textColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Obx(() => DropdownButtonFormField<ItemModel>(
                            value: controller.selectedItemFilter.value,
                            dropdownColor: AppColor.backGroundColor1,
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
                            hint: Text(
                              'انتخاب محصول',
                              style: AppTextStyle.labelText.copyWith(fontSize: 15),
                            ),
                            items: controller.itemList.map((ItemModel item) {
                              return DropdownMenuItem<ItemModel>(
                                value: item,
                                child: Text(
                                  item.name ?? '',
                                  style: AppTextStyle.labelText.copyWith(fontSize: 15,),
                                ),
                              );
                            }).toList(),
                            onChanged: (ItemModel? newValue) {
                              controller.changeSelectedItemFilter(newValue);
                            },
                          )),
                        ],
                      ),
                      SizedBox(height: 8),
                      // شرح (Description) Filter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شرح',
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
                              controller: controller.descriptionFilterController,
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
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 23, vertical:isDesktop ? 19 : 5),
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
                        controller.getRemittanceListPager();
                        Get.back();
                      }else{
                        controller.currentPage.value=1;
                        controller.itemsPerPage.value=25;
                        controller.getRemittanceListPager();
                        Get.back();
                      }
                    },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                    )
                        : Text(
                      'فیلتر',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: isDesktop ? 12 : 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
