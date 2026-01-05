import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../product/model/item.model.dart';

class OrderFilterWidget extends StatelessWidget {
  final OrderController orderController;

  const OrderFilterWidget({
    super.key,
    required this.orderController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'فیلتر ادمین',
                style: AppTextStyle.labelText.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: AppColor.textColor),
              ),
              SizedBox(height: 10),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio<int?>(
                        value: 1,
                        groupValue: orderController.byAdmin.value,
                        onChanged: (value) {
                          orderController.checkByAdmin(value);
                        },
                        activeColor: AppColor.primaryColor,
                      ),
                      Text(
                        'ادمین',
                        style: AppTextStyle.labelText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int?>(
                        value: 0,
                        groupValue: orderController.byAdmin.value,
                        onChanged: (value) {
                          orderController.checkByAdmin(value);
                        },
                        activeColor: AppColor.primaryColor,
                      ),
                      Text(
                        'غیر ادمین',
                        style: AppTextStyle.labelText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int?>(
                        value: null,
                        groupValue: orderController.byAdmin.value,
                        onChanged: (value) {
                          orderController.checkByAdmin(value);
                        },
                        activeColor: AppColor.primaryColor,
                      ),
                      Text(
                        'همه',
                        style: AppTextStyle.labelText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نوع سفارش',
                style: AppTextStyle.labelText.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: AppColor.textColor),
              ),
              SizedBox(height: 10),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio<int?>(
                        value: 1,
                        groupValue: orderController.type.value,
                        onChanged: (value) {
                          orderController.checkType(value);
                        },
                        activeColor: AppColor.primaryColor,
                      ),
                      Text(
                        'خرید',
                        style: AppTextStyle.labelText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int?>(
                        value: 0,
                        groupValue: orderController.type.value,
                        onChanged: (value) {
                          orderController.checkType(value);
                        },
                        activeColor: AppColor.primaryColor,
                      ),
                      Text(
                        'فروش',
                        style: AppTextStyle.labelText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int?>(
                        value: null,
                        groupValue: orderController.type.value,
                        onChanged: (value) {
                          orderController.checkType(value);
                        },
                        activeColor: AppColor.primaryColor,
                      ),
                      Text(
                        'همه',
                        style: AppTextStyle.labelText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نام',
                style: AppTextStyle.labelText.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: AppColor.textColor),
              ),
              SizedBox(height: 10),
              IntrinsicHeight(
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    selectionColor: Colors.white.withOpacity(0.4),
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: orderController.nameFilterController,
                    style: AppTextStyle.labelText.copyWith(fontSize: 15),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 15),
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
                value: orderController.selectedItemFilter.value,
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
                items: orderController.itemList.map((ItemModel item) {
                  return DropdownMenuItem<ItemModel>(
                    value: item,
                    child: Text(
                      item.name ?? '',
                      style: AppTextStyle.labelText.copyWith(fontSize: 15,),
                    ),
                  );
                }).toList(),
                onChanged: (ItemModel? newValue) {
                  orderController.changeSelectedItemFilter(newValue);
                },
              )),
            ],
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'از تاریخ',
                style: AppTextStyle.labelText.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: AppColor.textColor),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: IntrinsicHeight(
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      selectionColor: Colors.white.withOpacity(0.4),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا تاریخ را انتخاب کنید';
                        }
                        return null;
                      },
                      controller: orderController.dateStartController,
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
                          initialEntryMode: PersianDatePickerEntryMode.calendar,
                          initialDatePickerMode: PersianDatePickerMode.day,
                          locale: Locale("fa", "IR"),
                        );
                        Gregorian gregorian = pickedDate!.toGregorian();
                        orderController.startDateFilter.value =
                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                        orderController.dateStartController.text =
                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                      },
                    ),
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
                style: AppTextStyle.labelText.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: AppColor.textColor),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: IntrinsicHeight(
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      selectionColor: Colors.white.withOpacity(0.4),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا تاریخ را انتخاب کنید';
                        }
                        return null;
                      },
                      controller: orderController.dateEndController,
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
                          initialEntryMode: PersianDatePickerEntryMode.calendar,
                          initialDatePickerMode: PersianDatePickerMode.day,
                          locale: Locale("fa", "IR"),
                        );
                        Gregorian gregorian = pickedDate!.toGregorian();
                        orderController.endDateFilter.value =
                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                        orderController.dateEndController.text =
                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
      /*Column(
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
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: TextField(
              controller: orderController.amountFilterController,
              onChanged: (value) {
                orderController.amountFilter.value = value;
              },
              keyboardType: TextInputType.number,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: AppColor.textColor,
              ),
              decoration: InputDecoration(
                hintText: 'جستجو در مقادیر ...',
                hintStyle: AppTextStyle.bodyText.copyWith(
                  fontSize: 11,
                  color: AppColor.textColor.withOpacity(0.5),
                ),
                filled: true,
                fillColor: AppColor.textFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),*/
        ],
      ),
    );
  }
}
