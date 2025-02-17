import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/custom_appbar.widget.dart';

class OrderCreateView extends StatelessWidget {
  OrderCreateView({super.key});

  OrderCreateController orderCreateController =
  Get.find<OrderCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ایجاد سفارش جدید'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'سفارش جدید',
                    style: AppTextStyle.smallTitleText,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(5),
                        backgroundColor:
                        WidgetStatePropertyAll(AppColor.buttonColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'لیست سفارشات',
                      style: AppTextStyle.labelText,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 1,
                color: AppColor.secondaryColor,
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Obx(() {
                  return Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خرید/فروش',
                          style: AppTextStyle.labelText,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        "انتخاب کنید",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                            fontSize: 14,
                                            color: AppColor.textColor),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            items: orderCreateController.orderTypeList
                                .map((String item) {
                              return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: AppTextStyle.bodyText,
                                  ));
                            }).toList(),
                            value: orderCreateController.selectedValue.value,
                            onChanged: (String? newValue) {
                              orderCreateController.changeSelectedValue(
                                  newValue);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: AppColor.textFieldColor,
                                  border: Border.all(
                                      color: AppColor.secondaryColor,
                                      width: 1)),
                              elevation: 0,
                            ),
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),
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
                              offset: const Offset(-0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(7),
                                thickness: WidgetStateProperty.all(6),
                                thumbVisibility: WidgetStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 10, right: 10),
                            ),
                          ),
                        ),
                        /*DropdownButtonFormField(
                            alignment: Alignment.bottomCenter,
                            menuMaxHeight: 200,
                            isExpanded: true,
                            hint: Text('انتخاب کنید',style: AppTextStyle.labelText.copyWith(color: Colors.grey),),
                              decoration: InputDecoration(filled: true,fillColor: AppColor.textFieldColor),
                              items: orderCreateController.options.map((String item){
                                return DropdownMenuItem(
                                  value: item,
                                    child: Text(item));
                              }).toList(),

                              iconEnabledColor: AppColor.textColor,
                              dropdownColor: AppColor.textFieldColor,
                              style: AppTextStyle.bodyText,
                              onChanged: (String? newValue){
                                orderCreateController.selectedValue=newValue;
                              },
                          ),*/
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
