import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit_create.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/custom_appbar.widget.dart';

class DepositCreateView extends StatefulWidget {
  const DepositCreateView({super.key});

  @override
  State<DepositCreateView> createState() => _DepositCreateViewState();
}

class _DepositCreateViewState extends State<DepositCreateView> {

  final DepositCreateController depositCreateController = Get.find<
      DepositCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ثبت واریزی',
        onBackTap: () => Get.offNamed('/withdrawsList'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'ثبت واریزی',
                          style: AppTextStyle.smallTitleText,
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
                      child:
                      Obx(() {
                        return Form(
                          //key: withdrawCreateController.formKey,
                          child: Column(crossAxisAlignment: CrossAxisAlignment
                              .start,
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
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.only(bottom: 5),
                                  child:
                                  TextFormField(
                                    controller: depositCreateController
                                        .accountController,
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
                                          style: AppTextStyle.labelText
                                              .copyWith(
                                            fontSize: 14,
                                            color: AppColor.textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items:
                                  depositCreateController.bankAccountList.map((
                                      bankAccount) {
                                    return DropdownMenuItem(
                                        value: bankAccount,
                                        child: Row(
                                          children: [
                                            Image.network('${BaseUrl
                                                .baseUrl}Attachment/downloadAsync?fileName=${bankAccount
                                                .bank?.icon}', width: 22,
                                              height: 22,),
                                            SizedBox(width: 10,),
                                            Text(bankAccount.bank!.name ?? "",
                                              style: AppTextStyle.bodyText,),
                                          ],
                                        ));
                                  }).toList(),
                                  value: depositCreateController
                                      .selectedBankAccount.value,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      depositCreateController
                                          .changeSelectedBankAccount(newValue);
                                    }
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: AppColor.textFieldColor,
                                      border: Border.all(
                                          color: AppColor.backGroundColor,
                                          width: 1),
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
                                      thumbVisibility: WidgetStateProperty.all(
                                          true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                ),
                              ),
                              // نام بانک
                              Container(
                                padding: EdgeInsets.only(bottom: 3, top: 5),
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
                                          style: AppTextStyle.labelText
                                              .copyWith(
                                            fontSize: 14,
                                            color: AppColor.textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items:
                                  depositCreateController.bankList.map((bank) {
                                    return DropdownMenuItem(
                                        value: bank.id.toString(),
                                        child: Row(
                                          children: [
                                            Image.network('${BaseUrl
                                                .baseUrl}Attachment/downloadAsync?fileName=${bank
                                                .icon}', width: 22,
                                              height: 22,),
                                            SizedBox(width: 10,),
                                            Text(bank.name ?? "",
                                              style: AppTextStyle.bodyText,),
                                          ],
                                        ));
                                  }).toList(),
                                  value: depositCreateController.selectedIndex,
                                  onChanged: (newValue) {
                                    setState(() {
                                      depositCreateController
                                          .changeSelectedBank(newValue!);
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: AppColor.textFieldColor,
                                      border: Border.all(
                                          color: AppColor.backGroundColor,
                                          width: 1),
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
                                      thumbVisibility: WidgetStateProperty.all(
                                          true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                ),
                              ),
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
                                  controller: depositCreateController.ownerNameController,
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
                                padding: EdgeInsets.only(bottom: 3, top: 5),
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
                                  controller: depositCreateController
                                      .amountController,
                                  style: AppTextStyle.labelText,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // حذف کاماهای قبلی و فرمت جدید
                                    String cleanedValue = value.replaceAll(',', '');
                                    if (cleanedValue.isNotEmpty) {
                                      depositCreateController.amountController.text =
                                          cleanedValue.toPersianDigit().seRagham();
                                      depositCreateController.amountController.selection =
                                          TextSelection.collapsed(
                                              offset: depositCreateController.amountController.text.length);
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
                                padding: EdgeInsets.only(bottom: 3, top: 5),
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
                                  controller: depositCreateController
                                      .numberController,
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
                                padding: EdgeInsets.only(bottom: 3, top: 5),
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
                                  controller: depositCreateController
                                      .cardNumberController,
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
                                padding: EdgeInsets.only(bottom: 3, top: 5),
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
                                  controller: depositCreateController
                                      .shebaController,
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
                                //height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child: IntrinsicHeight(
                                  child: TextFormField(
                                    validator: (value){
                                      if(value==null || value.isEmpty){
                                        return 'لطفا تاریخ را انتخاب کنید';
                                      }
                                      return null;
                                    },
                                    controller: depositCreateController.dateController,
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
                                        context: context,
                                        initialDate: Jalali.now(),
                                        firstDate: Jalali(1400,1,1),
                                        lastDate: Jalali(1450,12,29),
                                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                                        initialDatePickerMode: PersianDatePickerMode.day,
                                        locale: Locale("fa","IR"),
                                      );

                                      if(pickedDate!=null){
                                        depositCreateController.dateController.text =
                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                      }
                                    },
                                  ),
                                ),
                              ),


                              // دکمه ایجاد درخواست
                              SizedBox(height: 20,),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        fixedSize: WidgetStatePropertyAll(
                                            Size(Get.width * .77, 40)),
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 7)),
                                        elevation: WidgetStatePropertyAll(5),
                                        backgroundColor:
                                        WidgetStatePropertyAll(
                                            AppColor.primaryColor),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(10)))),
                                    onPressed: () async {
                                      await depositCreateController.insertDeposit();
                                      depositCreateController.clearList();
                                    },
                                    child:depositCreateController.isLoading.value
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
                )
            ),
          )
      ),
    );
  }
}
