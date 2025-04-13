import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/custom_appbar.widget.dart';

class OrderCreateView extends StatelessWidget {
  OrderCreateView({super.key});
  final formKey = GlobalKey<FormState>();

  OrderCreateController orderCreateController =
  Get.find<OrderCreateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Scaffold(
      appBar:isDesktop ? AppBar(
        iconTheme: IconThemeData(color: AppColor.textColor,),
      ) :
      CustomAppBar(
        title: 'ایجاد سفارش جدید',onBackTap: () {
        Get.back();
        orderCreateController.clearList();
      },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ResponsiveRowColumn(
              layout: ResponsiveRowColumnType.COLUMN,
              columnSpacing: 15,
              rowSpacing: 20,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(isDesktop)
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            'سفارش جدید',
                            style: AppTextStyle.smallTitleText,
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                              onTap: (){
                                Get.back();
                                orderCreateController.clearList();
                              },
                              child:Padding(
                                padding: const EdgeInsets.only(right: 200),
                                child: Row(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('لیست سفارشات',style: AppTextStyle.smallTitleText,),
                                    SizedBox(width: 4,),
                                    SvgPicture.asset('assets/svg/list.svg',alignment: Alignment.centerLeft,
                                      width: 21,
                                      height: 26,
                                      colorFilter: ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),),
                                  ],
                                ),
                              )

                          ),
                        ),
                      ],
                    ),
                  )else
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'سفارش جدید',
                          style: AppTextStyle.smallTitleText,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Get.back();
                              orderCreateController.clearList();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 150),
                              child: SvgPicture.asset('assets/svg/list.svg',
                                width: 18,
                                height: 23,
                                colorFilter: ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ResponsiveRowColumnItem(
                  child: isDesktop ? SizedBox( width: 480,
                    child: Divider(
                      height: 1,
                      color: AppColor.appBarColor,
                    ),
                  ) : SizedBox( width: 420,
                    child: Divider(
                      height: 1,
                      color: AppColor.appBarColor,
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Container(
                    constraints: isDesktop ? BoxConstraints(maxWidth: 500) : BoxConstraints(maxWidth: 400),
                    padding: isDesktop
                        ? const EdgeInsets.symmetric(horizontal: 40)
                        : const EdgeInsets.symmetric(horizontal: 24),
                    child: Obx(() {

                      return Form(
                        key:formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // کاربر
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'کاربر',
                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                              ),
                            ),
                            // کاربر
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: CustomDropdownWidget(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'کاربر را انتخاب کنید';
                                  }
                                  return null;
                                },
                                items: orderCreateController.accountList
                                    .map((account)=>account.name ?? "").toList(),
                                selectedValue: orderCreateController.selectedAccount.value?.name,
                                onChanged: (String? newValue){
                                  var selectedAccount=orderCreateController.accountList.firstWhere((account)=>account.name==newValue);
                                  orderCreateController.changeSelectedAccount(selectedAccount);
                                },
                                backgroundColor: AppColor.textFieldColor,
                                borderRadius: 7,
                                borderColor: AppColor.secondaryColor,
                                hideUnderline: true,
                              ),
                            ),
                            // دکمه ایجاد سفارش
                            SizedBox(height: 20,),
                            orderCreateController.selectedBuySell.value?.name=='خرید از کاربر'?
                            SizedBox(width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 7)),
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.primaryColor),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                                onPressed: () async{if(formKey.currentState!.validate()) {
                                  await orderCreateController.insertOrder();

                                }
                                },
                                child:orderCreateController.isLoading.value
                                    ?
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ) :
                                Text(
                                    'ایجاد سفارش خرید',
                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10)
                                ),
                              ),
                            ) :
                            SizedBox(width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 7)),
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.accentColor),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                                onPressed: () async {if(formKey.currentState!.validate()) {
                                  await orderCreateController.insertOrder();

                                }
                                },
                                child: orderCreateController.isLoading.value
                                    ?
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                ) :
                                Text(
                                  'ایجاد سفارش فروش',
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
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
