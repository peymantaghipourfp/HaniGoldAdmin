import 'package:flutter_svg/flutter_svg.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/order_update.controller.dart';
import '../model/order.model.dart';

class OrderUpdateView extends StatelessWidget {
  OrderUpdateView({super.key});

  OrderUpdateController orderUpdateController =
  Get.find<OrderUpdateController>();
  final OrderModel order = Get.arguments as OrderModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ویرایش سفارش',onBackTap: () {
        Get.back();
        orderUpdateController.clearList();
      },),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ویرایش',
                      style: AppTextStyle.smallTitleText,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: SvgPicture.asset('assets/svg/list.svg',alignment: Alignment.centerLeft,
                          width: 18,
                          height: 23,
                          colorFilter: ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                  color: AppColor.appBarColor,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Obx(() {
                    /* List<String> uniqueItems = orderUpdateController.itemList
                        .map((item) => item.name ?? "")
                        .where((name) => name.isNotEmpty)
                        .toList();*/
                    return Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // خرید/فروش
                          Container(
                            padding: EdgeInsets.only(bottom: 3),
                            child: Text(
                              'خرید/فروش',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // خرید/فروش
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: CustomDropdownWidget(
                              items:  orderUpdateController.orderTypeList.map((type)=>type.name ?? '').toList(),
                              selectedValue: orderUpdateController.selectedBuySell.value?.name ?? '',
                              onChanged: (String? newValue){
                                var selectedBuySell=orderUpdateController.orderTypeList.firstWhere((type)=>type.name==newValue);
                                orderUpdateController.changeSelectedBuySell(selectedBuySell);
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 7,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            ),
                          ),
                          // محصول
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'محصول',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // محصول
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: CustomDropdownWidget(
                              items: orderUpdateController.itemList
                                  .map((item) => item.name ?? '').toList(),
                              selectedValue: orderUpdateController.selectedItem.value?.name,
                              onChanged: (String? newValue){
                                var selectedItem=orderUpdateController.itemList.firstWhere((item)=>item.name==newValue);
                                orderUpdateController.changeSelectedItem(selectedItem);
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 7,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            ),
                          ),
                          // کاربر
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'کاربر',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // کاربر
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: CustomDropdownWidget(
                              items: orderUpdateController.accountList
                                  .map((account)=>account.name ?? "").toList(),
                              selectedValue: orderUpdateController.selectedAccount.value?.name,
                              onChanged: (String? newValue){
                                var selectedAccount=orderUpdateController.accountList.firstWhere((account)=>account.name==newValue);
                                orderUpdateController.changeSelectedAccount(selectedAccount);
                              },
                              backgroundColor: AppColor.textFieldColor,
                              borderRadius: 7,
                              borderColor: AppColor.secondaryColor,
                              hideUnderline: true,
                            ),
                          ),
                          // قیمت
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'قیمت (ریال)',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // قیمت
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(bottom: 5),
                            child:
                            TextFormField(
                              controller: orderUpdateController.priceController,
                              style: AppTextStyle.labelText,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                // حذف کاماهای قبلی و فرمت جدید
                                String cleanedValue = value.replaceAll(',', '');
                                if (cleanedValue.isNotEmpty) {
                                  orderUpdateController.priceController.text =
                                      cleanedValue.toPersianDigit().seRagham();
                                  orderUpdateController.priceController.selection =
                                      TextSelection.collapsed(
                                          offset: orderUpdateController.priceController.text.length);
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
                          // گرم/عدد
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'گرم/عدد',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // گرم/عدد
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(bottom: 5),
                            child: TextFormField(
                                controller: orderUpdateController.amountController,
                                style: AppTextStyle.labelText,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
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

                                    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                                  }),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
                              ),
                          ),
                          // مبلغ کل
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'مبلغ کل (ریال)',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // مبلغ کل
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(bottom: 5),
                            child:
                            TextFormField(
                              controller: orderUpdateController.totalPriceController,
                              style: AppTextStyle.labelText,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                              ),
                            ),
                          ),
                          // تاریخ
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'تاریخ سفارش',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // تاریخ
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(bottom: 5),
                            child: TextFormField(
                                controller: orderUpdateController.dateController,
                                readOnly: true,
                                style: AppTextStyle.labelText,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
                                onTap: () async {
                                  Jalali? pickedDate = await showPersianDatePicker(
                                    context: context,
                                    initialDate: Jalali.now(),
                                    firstDate: Jalali(1400,1,1),
                                    lastDate: Jalali(1450,12,29),
                                    initialEntryMode: PersianDatePickerEntryMode.calendar,
                                    initialDatePickerMode: PersianDatePickerMode.day,
                                    locale: Locale("fa","IR"),
                                  );

                                  if(pickedDate!=null){
                                    orderUpdateController.dateController.text =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                  }
                                },
                              ),
                          ),
                          // توضیحات
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'توضیحات',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          // توضیحات
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child:
                            TextFormField(
                              controller: orderUpdateController.descriptionController,
                              maxLines: 5,
                              style: AppTextStyle.labelText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                              ),
                            ),
                          ),
                          // دکمه آپدیت سفارش
                          SizedBox(height: 20,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              orderUpdateController.selectedBuySell.value?.name=='خرید از کاربر'?
                              ElevatedButton(
                                style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*.77,40)),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 7)),
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.primaryColor),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                                onPressed: () async{
                                  await orderUpdateController.updateOrder();

                                },
                                child:orderUpdateController.isLoading.value
                                    ?
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ) :
                                Text(
                                  'ویرایش سفارش خرید',
                                  style: AppTextStyle.labelText,
                                ),
                              ) :
                              ElevatedButton(
                                style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*.77,40)),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 7)),
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.accentColor),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                                onPressed: () async {
                                  await orderUpdateController.updateOrder();

                                },
                                child:orderUpdateController.isLoading.value
                                    ?
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ) :
                                Text(
                                  'ویرایش سفارش فروش',
                                  style: AppTextStyle.labelText,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
