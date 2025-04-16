

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_update.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';

class WithdrawUpdateView extends StatefulWidget {
  const WithdrawUpdateView({super.key});

  @override
  State<WithdrawUpdateView> createState() => _WithdrawUpdateViewState();
}

class _WithdrawUpdateViewState extends State<WithdrawUpdateView> {

  WithdrawUpdateController withdrawUpdateController=Get.find<WithdrawUpdateController>();
  final WithdrawModel withdraw= Get.arguments as WithdrawModel;
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar:isDesktop ? AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
          onPressed: () => Get.back(), // Default behavior if onBackTap is null
        ),
      ) : CustomAppBar(title: 'ویرایش درخواست برداشت',
        onBackTap: () {
        Get.back();
        withdrawUpdateController.clearList();
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
                              ' ویرایش ',
                              style: AppTextStyle.smallTitleText,
                            ),
                          ),

                          Expanded(
                            child: GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child:Padding(
                                  padding: const EdgeInsets.only(right: 60),
                                  child: Row(mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('لیست درخواست برداشت',style: AppTextStyle.smallTitleText,),
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
                            ' ویرایش ',
                            style: AppTextStyle.smallTitleText,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 200,left: 50),
                                child: SvgPicture.asset('assets/svg/list.svg',
                                  alignment: Alignment.centerLeft,
                                  width: 18,
                                  height: 23,
                                  colorFilter: ColorFilter.mode(AppColor.textColor,
                                      BlendMode.srcIn),),
                              ),
                            ),
                          ),
                          //SizedBox(height: 3,),
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
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // کاربر
                              Container(
                                padding: EdgeInsets.only(bottom: 3, top: 5),
                                child: Text(
                                  'کاربر',
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              // کاربر
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                CustomDropdownWidget(

                                  dropdownSearchData: DropdownSearchData<String>(
                                    searchController: withdrawUpdateController
                                        .searchController,
                                    searchInnerWidgetHeight: 50,
                                    searchInnerWidget: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        right: 15,
                                        left: 15,
                                      ),
                                      child: TextFormField(style: AppTextStyle.bodyText,
                                        controller: withdrawUpdateController
                                            .searchController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'جستجوی کاربر...',
                                          hintStyle: AppTextStyle.labelText,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  value: withdrawUpdateController.selectedAccount.value?.name,
                                  showSearchBox: true,
                                  items:
                                    withdrawUpdateController.searchedAccounts.map((account) => account.name ?? "").toList(),
                                  selectedValue: withdrawUpdateController.selectedAccount.value?.name,
                                  onChanged: (String? newValue){
                                      var selectedAccount = withdrawUpdateController.searchedAccounts
                                          .firstWhere((account) => account.name == newValue);
                                      withdrawUpdateController.changeSelectedAccount(selectedAccount);
                                  },
                                  backgroundColor: AppColor.textFieldColor,
                                  borderRadius: 7,
                                  borderColor: AppColor.secondaryColor,
                                  hideUnderline: true,
                                ),
                              ),
                              // بانک اکانت
                              Container(
                                padding: EdgeInsets.only(bottom: 3, top: 5),
                                child: Text(
                                  'حساب بانک',
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
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
                                  withdrawUpdateController.bankAccountList.map((bankAccount){
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
                                  value: withdrawUpdateController.selectedBankAccount.value,
                                  onChanged: (newValue){
                                    if(newValue!=null) {
                                      withdrawUpdateController.changeSelectedBankAccount(newValue);
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
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
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
                                  withdrawUpdateController.bankList.map((bank){
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
                                  value: withdrawUpdateController.selectedIndex,
                                  onChanged: (newValue){
                                    setState(() {
                                      withdrawUpdateController.changeSelectedBank(newValue!);
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
                                  controller: withdrawUpdateController.bankNameController,
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
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              // نام صاحب حساب
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                TextFormField(
                                  controller: withdrawUpdateController.ownerNameController,
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
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              // مبلغ
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                TextFormField(
                                  controller: withdrawUpdateController.amountController,
                                  style: AppTextStyle.labelText,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // حذف کاماهای قبلی و فرمت جدید
                                    String cleanedValue = value.replaceAll(',', '');
                                    if (cleanedValue.isNotEmpty) {
                                      withdrawUpdateController.amountController.text =
                                          cleanedValue.toPersianDigit().seRagham();
                                      withdrawUpdateController.amountController.selection =
                                          TextSelection.collapsed(
                                              offset: withdrawUpdateController.amountController.text.length);
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
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              // شماره کارت
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                TextFormField(
                                  controller: withdrawUpdateController.numberController,
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
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              //شماره حساب
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                TextFormField(
                                  controller: withdrawUpdateController.cardNumberController,
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
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              //شماره شبا
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                TextFormField(
                                  controller: withdrawUpdateController.shebaController,
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
                                  'تاریخ درخواست',
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              // تاریخ
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  controller: withdrawUpdateController.dateController,
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

                                    DateTime date=DateTime.now();

                                    if(pickedDate!=null){
                                      withdrawUpdateController.dateController.text =
                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";

                                    }
                                  },
                                ),
                              ),
                              // توضیحات
                              Container(
                                padding: EdgeInsets.only(bottom: 3,top: 5),
                                child: Text(
                                  'توضیحات',
                                  style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                ),
                              ),
                              // توضیحات
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child:
                                TextFormField(
                                  controller: withdrawUpdateController.descriptionController,
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

                              // دکمه ویرایش درخواست
                              SizedBox(height: 20,),

                              SizedBox(width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(
                                          Size(Get.width * .77, 40)),
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 7)),
                                      elevation: WidgetStatePropertyAll(5),
                                      backgroundColor:
                                      WidgetStatePropertyAll(AppColor.primaryColor),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)))),
                                  onPressed: () async{
                                    await withdrawUpdateController.updateWithdraw();

                                  },
                                  child:withdrawUpdateController.isLoading.value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                  ) :
                                  Text(
                                    'ویرایش درخواست',
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
          )
      ),
    );
  }
}
