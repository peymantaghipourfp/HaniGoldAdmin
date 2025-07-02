import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/transaction/controller/transaction.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_dropdown.widget.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {

  final TransactionController controller = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() {
      return Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.backGroundColor
          ),
          width: isDesktop ? Get.width * 0.2 : Get.width * 0.5,
          height: isDesktop ? Get.height * 0.5 : Get.height * 0.7,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        width: 50, height: 27,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 1)),
                              // elevation: WidgetStatePropertyAll(5),
                              backgroundColor:
                              WidgetStatePropertyAll(
                                  AppColor.accentColor.withOpacity(0.5)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(side: BorderSide(
                                      color: AppColor.textColor),
                                      borderRadius: BorderRadius.circular(5)))),
                          onPressed: () async {
                            controller.clearFilter();
                            controller.fetchTransactionList();
                            Get.back();
                          },
                          child: Text(
                            'حذف فیلتر',
                            style: AppTextStyle.labelText.copyWith(
                                fontSize: isDesktop ? 9 : 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColor.textColor, height: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 8,),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نام کاربر',
                            style: AppTextStyle.labelText.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: AppColor.textColor),
                          ),
                          SizedBox(height: 8,),
                          IntrinsicHeight(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              controller: controller.nameFilterController,
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 15),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 15
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(6),
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
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نوع',
                            style: AppTextStyle.labelText.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: AppColor.textColor),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.only(
                                bottom: 5),
                            child: CustomDropdownWidget(
                              validator: (value) {
                                if (value == 'انتخاب کنید' ||
                                    value == null ||
                                    value.isEmpty) {
                                  return 'نوع را انتخاب کنید';
                                }
                                return null;
                              },
                              items: [
                                'انتخاب کنید',
                                ...controller.typeList.where((type) =>
                                type.type != null)
                                    .map((type) =>
                                type.name ?? '')
                              ].toList(),
                              selectedValue: controller.typeFilter ?? '',
                              onChanged: (String? newValue) {
                                controller.changeSelectedType(newValue!);
                                setState(() {

                                });
                              },
                              backgroundColor: AppColor
                                  .textFieldColor,
                              borderRadius: 7,
                              borderColor: AppColor
                                  .secondaryColor,
                              hideUnderline: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'از تاریخ',
                            style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: AppColor.textColor),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            //height: 50,
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
                                  suffixIcon: Icon(Icons.calendar_month,
                                      color: AppColor.textColor),
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
                                    initialEntryMode: PersianDatePickerEntryMode
                                        .calendar,
                                    initialDatePickerMode: PersianDatePickerMode
                                        .day,
                                    locale: Locale("fa", "IR"),
                                  );
                                  Gregorian gregorian = pickedDate!
                                      .toGregorian();
                                  controller.startDateFilter.value =
                                  "${gregorian.year}-${gregorian.month
                                      .toString().padLeft(2, '0')}-${gregorian
                                      .day.toString().padLeft(2, '0')}";

                                  controller.dateStartController.text =
                                  "${pickedDate.year}/${pickedDate.month
                                      .toString().padLeft(2, '0')}/${pickedDate
                                      .day.toString().padLeft(2, '0')}";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تا تاریخ',
                            style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: AppColor.textColor),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            //height: 50,
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
                                  suffixIcon: Icon(Icons.calendar_month,
                                      color: AppColor.textColor),
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
                                    initialEntryMode: PersianDatePickerEntryMode
                                        .calendar,
                                    initialDatePickerMode: PersianDatePickerMode
                                        .day,
                                    locale: Locale("fa", "IR"),
                                  );
                                  // DateTime date=DateTime.now();
                                  Gregorian gregorian = pickedDate!
                                      .toGregorian();
                                  controller.endDateFilter.value =
                                  "${gregorian.year}-${gregorian.month
                                      .toString().padLeft(2, '0')}-${gregorian
                                      .day.toString().padLeft(2, '0')}";

                                  controller.dateEndController.text =
                                  "${pickedDate.year}/${pickedDate.month
                                      .toString().padLeft(2, '0')}/${pickedDate
                                      .day.toString().padLeft(2, '0')}";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                //Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 23, vertical: 19)),
                        // elevation: WidgetStatePropertyAll(5),
                        backgroundColor:
                        WidgetStatePropertyAll(AppColor.appBarColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            side: BorderSide(color: AppColor.textColor),
                            borderRadius: BorderRadius.circular(5)))),
                    onPressed: () async {
                      controller.fetchTransactionList();
                      Get.back();
                    },
                    child: controller.isLoading.value ?
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor
                          .textColor),
                    ) :
                    Text(
                      'فیلتر',
                      style: AppTextStyle.labelText.copyWith(fontSize: isDesktop
                          ? 12
                          : 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
