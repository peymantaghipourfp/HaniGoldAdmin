import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_create.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';

class WithdrawCreateView extends StatefulWidget {
  WithdrawCreateView({super.key});

  @override
  State<WithdrawCreateView> createState() => _WithdrawCreateState();
}

class _WithdrawCreateState extends State<WithdrawCreateView> {
  final formKey = GlobalKey<FormState>();
  WithdrawCreateController withdrawCreateController = Get.find<WithdrawCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ایجاد درخواست برداشت',
        onBackTap: () => Get.back(),
      ),
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
                        'ایجاد درخواست برداشت جدید',
                        style: AppTextStyle.smallTitleText,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed('/withdrawsList');
                            withdrawCreateController.clearList();
                          },
                          child: SvgPicture.asset('assets/svg/list.svg',
                            alignment: Alignment.centerLeft,
                            width: 18,
                            height: 23,
                            colorFilter: ColorFilter.mode(AppColor.textColor,
                                BlendMode.srcIn),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Divider(
                    height: 1,
                    color: AppColor.appBarColor,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Obx(() {
                      return Form(
                        key: formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // کاربر
                            Container(
                              padding: EdgeInsets.only(bottom: 3, top: 5),
                              child: Text(
                                'کاربر',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            // کاربر
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: DropdownButtonFormField2(
                            validator: (value) {
                              if (value == null) {
                                return 'کاربر را انتخاب کنید';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero, // افزایش padding عمودی
                                  border: InputBorder.none,
                                ),

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
                                items: withdrawCreateController.accountList.map((account){
                                  return DropdownMenuItem(
                                    value: account,
                                      child: Text(account.name ?? "",style: AppTextStyle.bodyText,));
                                }).toList(),
                                value: withdrawCreateController.selectedAccount.value,
                                onChanged: (newValue){
                                  if(newValue!=null) {
                                withdrawCreateController.changeSelectedAccount(newValue);
                              }
                             },
                                buttonStyleData: ButtonStyleData(height: 43,
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: AppColor.textFieldColor,
                                    border: Border.all(color: AppColor.backGroundColor, width: 1),
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
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                            // بانک اکانت
                            Container(
                              padding: EdgeInsets.only(bottom: 3, top: 5),
                              child: Text(
                                'حساب بانک',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            // بانک اکانت
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
                                items:
                                withdrawCreateController.bankAccountList.map((bankAccount){
                                  return DropdownMenuItem(
                                      value: bankAccount,
                                      child: Row(
                                        children: [
                                          Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${bankAccount.bank?.icon}',width: 22,height: 22,),
                                          SizedBox(width: 10,),
                                          Text("${bankAccount.bank!.name} , " ?? "",style: AppTextStyle.bodyText,),
                                          Text(bankAccount.ownerName ?? "",style: AppTextStyle.bodyText,),

                                        ],
                                      ));
                                }).toList(),
                                value: withdrawCreateController.selectedBankAccount.value,
                                onChanged: (newValue){
                                  if(newValue!=null) {
                                    withdrawCreateController.changeSelectedBankAccount(newValue);
                                  }
                                },
                                buttonStyleData: ButtonStyleData(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: AppColor.textFieldColor,
                                    border: Border.all(color: AppColor.backGroundColor, width: 1),
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
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                            // نام بانک
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'نام بانک',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            // نام بانک
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
                                items:
                                withdrawCreateController.bankList.map((bank){
                                  return DropdownMenuItem(
                                      value: bank.id.toString(),
                                      child: Row(
                                        children: [
                                          Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${bank.icon}',width: 22,height: 22,),
                                          SizedBox(width: 10,),
                                          Text(bank.name ?? "",style: AppTextStyle.bodyText,),
                                        ],
                                      ));
                                }).toList(),
                                value: withdrawCreateController.selectedIndex,
                                onChanged: (newValue){
                                  setState(() {
                                    withdrawCreateController.changeSelectedBank(newValue!);
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: AppColor.textFieldColor,
                                    border: Border.all(color: AppColor.backGroundColor, width: 1),
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
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                            /*Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              TextFormField(
                                controller: withdrawCreateController.bankNameController,
                                style: AppTextStyle.bodyText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
                              ),
                            ),*/
                            // نام صاحب حساب
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'نام صاحب حساب',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            // نام صاحب حساب
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              TextFormField(
                                controller: withdrawCreateController.ownerNameController,
                                style: AppTextStyle.bodyText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
                              ),
                            ),
                            // مبلغ
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'مبلغ (ریال)',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            // مبلغ
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              TextFormField(
                                controller: withdrawCreateController.amountController,
                                style: AppTextStyle.labelText,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // حذف کاماهای قبلی و فرمت جدید
                                  String cleanedValue = value.replaceAll(',', '');
                                  if (cleanedValue.isNotEmpty) {
                                    withdrawCreateController.amountController.text =
                                        cleanedValue.toPersianDigit().seRagham();
                                    withdrawCreateController.amountController.selection =
                                        TextSelection.collapsed(
                                            offset: withdrawCreateController.amountController.text.length);
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
                            //شماره کارت
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'شماره کارت',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            // شماره کارت
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              TextFormField(
                                controller: withdrawCreateController.numberController,
                                style: AppTextStyle.bodyText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
                              ),
                            ),
                            //شماره حساب
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'شماره حساب',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            //شماره حساب
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              TextFormField(
                                controller: withdrawCreateController.cardNumberController,
                                style: AppTextStyle.bodyText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
                              ),
                            ),
                            //شماره شبا
                            Container(
                              padding: EdgeInsets.only(bottom: 3,top: 5),
                              child: Text(
                                'شماره شبا',
                                style: AppTextStyle.labelText,
                              ),
                            ),
                            //شماره شبا
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              TextFormField(
                                controller: withdrawCreateController.shebaController,
                                style: AppTextStyle.bodyText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                ),
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
                                controller: withdrawCreateController.descriptionController,
                                maxLines: 3,
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

                            // دکمه ایجاد درخواست
                            SizedBox(height: 20,),
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*.77,40)),
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 7)),
                                      elevation: WidgetStatePropertyAll(5),
                                      backgroundColor:
                                      WidgetStatePropertyAll(AppColor.primaryColor),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)))),
                                  onPressed: () async{if(formKey.currentState!.validate()){
                                    await withdrawCreateController.insertWithdraw();
                                    }
                                    withdrawCreateController.clearList();
                                  },
                                  child:withdrawCreateController.isLoading.value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                  ) :
                                  Text(
                                    'ایجاد درخواست',
                                    style: AppTextStyle.labelText,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
