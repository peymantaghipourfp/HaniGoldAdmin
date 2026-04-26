
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_update.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_dropdown1.widget.dart';
import '../../account/model/account.model.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../../order/widget/tooltip_total_balance.widget.dart';
import '../model/bank.model.dart';

class WithdrawUpdateView extends StatefulWidget {
  const WithdrawUpdateView({super.key});

  @override
  State<WithdrawUpdateView> createState() => _WithdrawUpdateViewState();
}

class _WithdrawUpdateViewState extends State<WithdrawUpdateView> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey _balanceKey = GlobalKey();
  WithdrawUpdateController withdrawUpdateController = Get.find<
      WithdrawUpdateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
    return Obx(() {
      return Scaffold(
        appBar: CustomAppbar1(title: 'ویرایش درخواست برداشت',
          onBackTap: () {
            Get.back();
            withdrawUpdateController.clearList();
          },
        ),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
                child: isMobile ?
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: ResponsiveRowColumn(
                      layout: ResponsiveRowColumnType.COLUMN,
                      columnSpacing: 10,
                      rowSpacing: 10,
                      rowCrossAxisAlignment: CrossAxisAlignment.start,
                      rowMainAxisAlignment: MainAxisAlignment.start,
                      columnCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child:
                            Obx(() {
                              if(withdrawUpdateController.selectedAccount.value==null){
                                return SizedBox.shrink();
                              }
                              if (withdrawUpdateController.isLoadingTooltipBalance.value || withdrawUpdateController.tooltipTotalBalanceModel.value == null) {
                                return Center(child: CircularProgressIndicator());
                              }
                              return TooltipTotalBalanceWidget(
                                tooltipTotalBalance: withdrawUpdateController.tooltipTotalBalanceModel.value!,
                                size: double.infinity,
                                title: withdrawUpdateController.selectedAccount.value?.name ?? "",
                              );
                            }),
                          ),
                        ResponsiveRowColumnItem(
                          rowFlex: 2,
                          child: Container(
                            /*constraints: BoxConstraints(maxWidth: double.infinity,
                              maxHeight: Get.height,),*/
                            padding: EdgeInsets.symmetric(
                                horizontal:12, vertical: 5),
                            /*decoration: BoxDecoration(
                              color: AppColor.backGroundColor1,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),*/

                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 40, bottom: 10),
                                          child: Text(
                                            'ویرایش',
                                            style: AppTextStyle.smallTitleText,
                                          ),
                                        ),

                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 50,bottom: 10),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    Text('لیست درخواست برداشت',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                    SizedBox(width: 4,),
                                                    SvgPicture.asset(
                                                      'assets/svg/list.svg',
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      width: 21,
                                                      height: 26,
                                                      colorFilter: ColorFilter
                                                          .mode(
                                                          AppColor.textColor,
                                                          BlendMode.srcIn),),
                                                  ],
                                                ),
                                              )

                                          ),
                                        ),
                                      ],
                                    ),

                                  SizedBox(width: 420,
                                      child: Divider(
                                        height: 1,
                                        color: AppColor.appBarColor,
                                      ),
                                    ),

                                  Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 400,),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              // کاربر
                                              withdrawUpdateController.accountList.isEmpty ?
                                              SizedBox.shrink():
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'کاربر',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // کاربر
                                              withdrawUpdateController.accountList.isEmpty ?
                                              Center(
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                      AppColor.textColor),
                                                ),
                                              ) :
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5,),
                                                child: CustomDropdown<AccountModel>(
                                                  items: withdrawUpdateController.accountList,
                                                  selectedItem: withdrawUpdateController.selectedAccount.value,
                                                  enableSearch: true,
                                                  errorText: withdrawUpdateController.dropdownError.value,
                                                  itemLabel: (account) =>
                                                  account.name ??
                                                      "",
                                                  /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                                                  onChanged: (account) {
                                                    setState(() {
                                                      withdrawUpdateController.selectedAccount.value = account;
                                                      withdrawUpdateController.dropdownError.value = "";

                                                      withdrawUpdateController.changeSelectedAccount(
                                                          account);
                                                    });
                                                    debugPrint(
                                                      "کاربر انتخاب شد: ${account?.name}",
                                                    );
                                                  },
                                                  isIcon: false,
                                                ),
                                              ),
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                CustomDropdownWidget(

                                                  dropdownSearchData: DropdownSearchData<
                                                      String>(
                                                    searchController: withdrawUpdateController
                                                        .searchController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget: Container(
                                                      height: 50,
                                                      padding: const EdgeInsets
                                                          .only(
                                                        top: 8,
                                                        right: 15,
                                                        left: 15,
                                                      ),
                                                      child: TextSelectionTheme(
                                                        data: TextSelectionThemeData(
                                                          selectionColor: Colors.white.withOpacity(0.4),
                                                        ),
                                                        child: TextFormField(
                                                          style: AppTextStyle
                                                              .bodyText,
                                                          controller: withdrawUpdateController
                                                              .searchController,
                                                          focusNode: withdrawUpdateController
                                                              .searchFocusNode,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 10,
                                                              vertical: 8,
                                                            ),
                                                            hintText: 'جستجوی کاربر...',
                                                            hintStyle: AppTextStyle
                                                                .labelText,
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  value: withdrawUpdateController
                                                      .selectedAccount.value
                                                      ?.name,
                                                  showSearchBox: true,
                                                  items:[
                                                  ...withdrawUpdateController
                                                      .searchedAccounts.map((
                                                      account) =>
                                                  '${account.id}:${account.name ?? ""}')
                                                    ].toList(),
                                                  selectedValue: withdrawUpdateController
                                                      .selectedAccount.value != null
                                                      ? '${withdrawUpdateController.selectedAccount.value!.id}:${withdrawUpdateController.selectedAccount.value!.name}'
                                                      : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue ==
                                                        'انتخاب کنید') {
                                                      withdrawUpdateController
                                                          .changeSelectedAccount(
                                                          null);
                                                    } else {
                                                      var accountId = int.tryParse(newValue!.split(':')[0]);
                                                      if (accountId != null) {
                                                        var selectedAccount = withdrawUpdateController
                                                            .searchedAccounts
                                                            .firstWhere((account) =>
                                                        account.id == accountId);
                                                        withdrawUpdateController
                                                            .changeSelectedAccount(
                                                            selectedAccount);
                                                      }
                                                    }
                                                  },
                                                  onMenuStateChange: withdrawUpdateController.onDropdownMenuStateChange,
                                                  backgroundColor: AppColor
                                                      .textFieldColor,
                                                  borderRadius: 7,
                                                  borderColor: AppColor
                                                      .secondaryColor,
                                                  hideUnderline: true,
                                                ),
                                              ),*/
                                              // بانک اکانت
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'حساب بانک',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),*/
                                              // بانک اکانت
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  hint: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "انتخاب کنید",
                                                          style: AppTextStyle
                                                              .labelText
                                                              .copyWith(
                                                            fontSize: 14,
                                                            color: AppColor
                                                                .textColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  items:
                                                  withdrawUpdateController
                                                      .bankAccountList.map((
                                                      bankAccount) {
                                                    return DropdownMenuItem(
                                                        value: bankAccount,
                                                        child: Row(
                                                          children: [
                                                            Text("${bankAccount
                                                                .bank!.name}" ??
                                                                "",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                            Text(bankAccount
                                                                .ownerName ??
                                                                "",
                                                              style: AppTextStyle
                                                                  .bodyText,),

                                                          ],
                                                        ));
                                                  }).toList(),
                                                  value: withdrawUpdateController
                                                      .selectedBankAccount
                                                      .value,
                                                  onChanged: (newValue) {
                                                    if (newValue != null) {
                                                      withdrawUpdateController
                                                          .changeSelectedBankAccount(
                                                          newValue);
                                                    }
                                                  },
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(7),
                                                      color: AppColor
                                                          .textFieldColor,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .backGroundColor,
                                                          width: 1),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  iconStyleData: IconStyleData(
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    iconSize: 23,
                                                    iconEnabledColor: AppColor
                                                        .textColor,
                                                    iconDisabledColor: Colors
                                                        .grey,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                    maxHeight: 200,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(7),
                                                      color: AppColor
                                                          .textFieldColor,
                                                    ),
                                                    offset: const Offset(0, 0),
                                                    scrollbarTheme: ScrollbarThemeData(
                                                      radius: const Radius
                                                          .circular(7),
                                                      thickness: WidgetStateProperty
                                                          .all(6),
                                                      thumbVisibility: WidgetStateProperty
                                                          .all(true),
                                                    ),
                                                  ),
                                                  menuItemStyleData: const MenuItemStyleData(
                                                    height: 40,
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                  ),
                                                ),
                                              ),*/
                                              // نام بانک
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'نام بانک',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // نام بانک
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: CustomDropdown<BankModel>(
                                                  items: withdrawUpdateController.bankList,
                                                  selectedItem: withdrawUpdateController.selectedBank.value,
                                                  enableSearch: true,
                                                  errorText: withdrawUpdateController.dropdownError.value,
                                                  itemLabel: (bank) =>
                                                  bank.name ??
                                                      "",
                                                  itemIcon: (bank) =>
                                                  bank.icon ??
                                                      "",
                                                  onChanged: (bank) {
                                                    setState(() {
                                                      withdrawUpdateController.selectedBank.value = bank;
                                                      withdrawUpdateController.dropdownError.value = "";

                                                      withdrawUpdateController.changeSelectedBank(bank);
                                                    });
                                                    debugPrint(
                                                      "بانک انتخاب شد: ${bank?.name}",
                                                    );
                                                  },
                                                  isIcon: true,
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
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'نام صاحب حساب',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // نام صاحب حساب
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .ownerNameController,
                                                    style: AppTextStyle.bodyText,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // مبلغ
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'مبلغ (ریال)',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // مبلغ
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .amountController,
                                                    style: AppTextStyle.labelText,
                                                    keyboardType: TextInputType
                                                        .number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                                                    ],
                                                    onChanged: (value) {
                                                      // حذف کاماهای قبلی و فرمت جدید
                                                      String cleanedValue = value
                                                          .replaceAll(',', '');
                                                      if (cleanedValue
                                                          .isNotEmpty) {
                                                        withdrawUpdateController
                                                            .amountController
                                                            .text =
                                                            cleanedValue
                                                                .toPersianDigit()
                                                                .seRagham();
                                                        withdrawUpdateController
                                                            .amountController
                                                            .selection =
                                                            TextSelection
                                                                .collapsed(
                                                                offset: withdrawUpdateController
                                                                    .amountController
                                                                    .text.length);
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //شماره کارت
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'شماره کارت',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // شماره کارت
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .cardNumberController,
                                                    style: AppTextStyle.bodyText,
                                                    keyboardType: TextInputType
                                                        .number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(r'[۰-۹0-9]')),
                                                      LengthLimitingTextInputFormatter(16),
                                                    ],
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'لطفا شماره کارت را وارد کنید';
                                                      }
                                                      if (value.length != 16) {
                                                        return 'شماره کارت باید دقیقاً 16 رقم باشد';
                                                      }
                                                      return null;
                                                    },
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //شماره حساب
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'شماره حساب',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              //شماره حساب
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .numberController,
                                                    style: AppTextStyle.bodyText,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                          r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                      TextInputFormatter
                                                          .withFunction((
                                                          oldValue, newValue) {
                                                        // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                        String newText = newValue
                                                            .text
                                                            .replaceAll(
                                                            '٠', '0')
                                                            .replaceAll(
                                                            '١', '1')
                                                            .replaceAll(
                                                            '٢', '2')
                                                            .replaceAll(
                                                            '٣', '3')
                                                            .replaceAll(
                                                            '٤', '4')
                                                            .replaceAll(
                                                            '٥', '5')
                                                            .replaceAll(
                                                            '٦', '6')
                                                            .replaceAll(
                                                            '٧', '7')
                                                            .replaceAll(
                                                            '٨', '8')
                                                            .replaceAll(
                                                            '٩', '9');

                                                        return newValue
                                                            .copyWith(
                                                            text: newText,
                                                            selection: TextSelection
                                                                .collapsed(
                                                                offset: newText
                                                                    .length));
                                                      }),
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //شماره شبا
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'شماره شبا',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              //شماره شبا
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .shebaController,
                                                    style: AppTextStyle.bodyText,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // تاریخ
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'تاریخ درخواست',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // تاریخ
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: TextFormField(
                                                  controller: withdrawUpdateController
                                                      .dateController,
                                                  readOnly: true,
                                                  style: AppTextStyle.labelText,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
                                                        Icons.calendar_month,
                                                        color: AppColor
                                                            .textColor),
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                    ),
                                                    filled: true,
                                                    fillColor: AppColor
                                                        .textFieldColor,
                                                  ),
                                                  onTap: () async {
                                                    Jalali? pickedDate = await showPersianDatePicker(
                                                      context: context,
                                                      initialDate: Jalali.now(),
                                                      firstDate: Jalali(
                                                          1400, 1, 1),
                                                      lastDate: Jalali(
                                                          1450, 12, 29),
                                                      initialEntryMode: PersianDatePickerEntryMode
                                                          .calendar,
                                                      initialDatePickerMode: PersianDatePickerMode
                                                          .day,
                                                      locale: Locale(
                                                          "fa", "IR"),
                                                    );

                                                    DateTime date = DateTime
                                                        .now();

                                                    if (pickedDate != null) {
                                                      withdrawUpdateController
                                                          .dateController.text =
                                                      "${pickedDate
                                                          .year}/${pickedDate
                                                          .month.toString()
                                                          .padLeft(
                                                          2, '0')}/${pickedDate
                                                          .day.toString()
                                                          .padLeft(
                                                          2, '0')} ${date.hour
                                                          .toString().padLeft(
                                                          2, '0')}:${date.minute
                                                          .toString().padLeft(
                                                          2, '0')}:${date.second
                                                          .toString().padLeft(
                                                          2, '0')}";
                                                    }
                                                  },
                                                ),
                                              ),
                                              // توضیحات
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'توضیحات',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // توضیحات
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .descriptionController,
                                                    maxLines: 3,
                                                    style: AppTextStyle.labelText,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // نمایش و بارگذاری تصویر
                                              Container(
                                                padding: EdgeInsets.only(bottom: 5),
                                                //width: Get.width,
                                               height: 90,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: withdrawUpdateController.imageList.map((e)=>
                                                        Stack(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                showGeneralDialog(
                                                                    context: context,
                                                                    barrierDismissible: true,
                                                                    barrierLabel: MaterialLocalizations.of(context)
                                                                        .modalBarrierDismissLabel,
                                                                    barrierColor: Colors.black45,
                                                                    transitionDuration: const Duration(milliseconds: 200),
                                                                    pageBuilder: (BuildContext buildContext,
                                                                        Animation animation,
                                                                        Animation secondaryAnimation) {
                                                                      return Center(
                                                                        child: Material(
                                                                          color: Colors.transparent,
                                                                          child: Container(
                                                                            margin: EdgeInsets.all(20),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                border: Border.all(color: AppColor.textColor),
                                                                                image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.fill,
                                                                                )
                                                                            ),
                                                                            height: Get.height * 0.6,width: Get.width * 0.8,
                                                                            // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(color: AppColor.textColor),
                                                                    image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.cover,
                                                                    )
                                                                ),
                                                                height: 60,width: 60,
                                                                // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              child: CircleAvatar(
                                                                backgroundColor: AppColor.accentColor,radius: 10,
                                                                child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                              ),
                                                              onTap: (){
                                                                withdrawUpdateController.deleteImage(e);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                    ).toList(),
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(bottom: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (_) {
                                                              return SafeArea(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color:AppColor.secondary200Color,
                                                                      borderRadius: BorderRadius.circular(15)
                                                                  ),
                                                                  child: Wrap(
                                                                    children: [
                                                                      ListTile(
                                                                        leading: Icon(Icons.photo_library,color: AppColor.textColor,),
                                                                        title: Text('گالری',style: AppTextStyle.bodyText.copyWith(fontSize: 16,fontWeight: FontWeight.w700),),
                                                                        onTap: () {
                                                                          Get.back();
                                                                          withdrawUpdateController
                                                                              .pickImageMobile(ImageSource.gallery);
                                                                        },
                                                                      ),
                                                                      ListTile(
                                                                        leading: Icon(Icons.camera_alt,color: AppColor.textColor,),
                                                                        title: Text('دوربین',style: AppTextStyle.bodyText.copyWith(fontSize: 16,fontWeight: FontWeight.w700),),
                                                                        onTap: () {
                                                                          Get.back();
                                                                          withdrawUpdateController
                                                                              .pickImageMobile(ImageSource.camera);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          constraints: BoxConstraints(maxWidth: 100),
                                                          child: SvgPicture
                                                              .asset(
                                                            'assets/svg/camera.svg',
                                                            width: 30,
                                                            height: 30,
                                                            colorFilter: ColorFilter
                                                                .mode(
                                                                AppColor
                                                                    .iconViewColor,
                                                                BlendMode
                                                                    .srcIn),),
                                                        ),

                                                      ),
                                                      Obx(() {
                                                        if (withdrawUpdateController
                                                            .isUploadingDesktop
                                                            .value) {
                                                          return Row(
                                                            children: [
                                                              Text(
                                                                'در حال بارگزاری عکس',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                                                    fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                              ),
                                                              SizedBox(width: 10,),
                                                              CircularProgressIndicator(),
                                                            ],
                                                          );
                                                        }
                                                        return Container(
                                                          padding: EdgeInsets.only(bottom: 5),
                                                          height: 80,
                                                          //width: Get.width * 0.50,
                                                          child: Row(
                                                              children: withdrawUpdateController.selectedImagesDesktop.map((e){
                                                                return  Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:(){
                                                                        showGeneralDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            barrierLabel: MaterialLocalizations.of(context)
                                                                                .modalBarrierDismissLabel,
                                                                            barrierColor: Colors.black45,
                                                                            transitionDuration: const Duration(milliseconds: 200),
                                                                            pageBuilder: (BuildContext buildContext,
                                                                                Animation animation,
                                                                                Animation secondaryAnimation) {
                                                                              return Center(
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.all(isMobile ? 20 : 10),
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        border: Border.all(color: AppColor.textColor),
                                                                                        image: DecorationImage(
                                                                                          image: FileImage(File(e.path)) as ImageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        )
                                                                                    ),
                                                                                    height:Get.height * 0.6,
                                                                                    width: Get.width * 0.8,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child: Container(
                                                                        margin: EdgeInsets.all(10),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            border: Border.all(color: AppColor.textColor),
                                                                            image: DecorationImage(
                                                                              image: FileImage(File(e!.path)) as ImageProvider,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                        ),
                                                                        height: 60,width: 60,
                                                                        // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      child: CircleAvatar(
                                                                        backgroundColor: AppColor.accentColor,radius: 10,
                                                                        child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                                      ),
                                                                      onTap: (){
                                                                        withdrawUpdateController.selectedImagesDesktop.remove(e);
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                              }).toList(),
                                                            ),
                                                        );
                                                      }),
                                                    ],
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
                                                          Size(Get.width * .77,
                                                              40)),
                                                      padding: WidgetStatePropertyAll(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 7)),
                                                      elevation: WidgetStatePropertyAll(
                                                          5),
                                                      backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          AppColor
                                                              .primaryColor),
                                                      shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10)))),
                                                  onPressed: () async {
                                                      if(withdrawUpdateController.cardNumberController.text.isNotEmpty ||
                                                          withdrawUpdateController.numberController.text.isNotEmpty ||
                                                          withdrawUpdateController.shebaController.text.isNotEmpty || withdrawUpdateController.imageList.isNotEmpty){
                                                        await withdrawUpdateController.uploadImagesDesktop( "image", "WithdrawRequest");
                                                      }else{
                                                        Get.snackbar("فیلدهای ضروری را پر کنید", "شماره کارت-یا شماره حساب-یا شماره شبا");
                                                      }
                                                  },
                                                  child: withdrawUpdateController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'ویرایش درخواست',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                ],
                              ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ) :
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: ResponsiveRowColumn(
                      layout: isDesktop
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                      columnSpacing: 30,
                      rowSpacing: 20,
                      rowCrossAxisAlignment: CrossAxisAlignment.start,
                      rowMainAxisAlignment: MainAxisAlignment.start,
                      columnCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveRowColumnItem(
                          rowFlex: 2,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 700),
                            padding: EdgeInsets.symmetric(
                                horizontal:isDesktop ? 40 : 2, vertical: 20),
                            /*decoration: BoxDecoration(
                              color: AppColor.backGroundColor1,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),*/
                            child: SizedBox(
                              width: Get.width * 0.9,
                              height: Get.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveRowColumnItem(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 40, bottom: 10),
                                          child: Text(
                                            'ویرایش',
                                            style: AppTextStyle.smallTitleText,
                                          ),
                                        ),

                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: isDesktop ? 200 : 50,bottom: 10),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    Text('لیست درخواست برداشت',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                    SizedBox(width: 4,),
                                                    SvgPicture.asset(
                                                      'assets/svg/list.svg',
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      width: 21,
                                                      height: 26,
                                                      colorFilter: ColorFilter
                                                          .mode(
                                                          AppColor.textColor,
                                                          BlendMode.srcIn),),
                                                  ],
                                                ),
                                              )

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ResponsiveRowColumnItem(
                                    child: isDesktop ? SizedBox(width: 480,
                                      child: Divider(
                                        height: 1,
                                        color: AppColor.appBarColor,
                                      ),
                                    ) : SizedBox(width: 420,
                                      child: Divider(
                                        height: 1,
                                        color: AppColor.appBarColor,
                                      ),
                                    ),
                                  ),
                                  ResponsiveRowColumnItem(
                                    rowFlex: 1,
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 400),
                                        padding: isDesktop
                                            ? const EdgeInsets.symmetric(
                                            horizontal: 40)
                                            : const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              // کاربر
                                              withdrawUpdateController.accountList.isEmpty ?
                                              SizedBox.shrink():
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'کاربر',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // کاربر
                                              withdrawUpdateController.accountList.isEmpty ?
                                              Center(
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                      AppColor.textColor),
                                                ),
                                              ) :
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: CustomDropdown<AccountModel>(
                                                  items: withdrawUpdateController.accountList,
                                                  selectedItem: withdrawUpdateController.selectedAccount.value,
                                                  enableSearch: true,
                                                  errorText: withdrawUpdateController.dropdownError.value,
                                                  itemLabel: (account) =>
                                                  account.name ??
                                                      "",
                                                  /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                                                  onChanged: (account) {
                                                    setState(() {
                                                      withdrawUpdateController.selectedAccount.value = account;
                                                      withdrawUpdateController.dropdownError.value = "";

                                                      withdrawUpdateController.changeSelectedAccount(
                                                          account);
                                                    });
                                                    debugPrint(
                                                      "کاربر انتخاب شد: ${account?.name}",
                                                    );
                                                  },
                                                  isIcon: false,
                                                ),
                                              ),
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                CustomDropdownWidget(

                                                  dropdownSearchData: DropdownSearchData<
                                                      String>(
                                                    searchController: withdrawUpdateController
                                                        .searchController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget: Container(
                                                      height: 50,
                                                      padding: const EdgeInsets
                                                          .only(
                                                        top: 8,
                                                        right: 15,
                                                        left: 15,
                                                      ),
                                                      child: TextSelectionTheme(
                                                        data: TextSelectionThemeData(
                                                          selectionColor: Colors.white.withOpacity(0.4),
                                                        ),
                                                        child: TextFormField(
                                                          style: AppTextStyle
                                                              .bodyText,
                                                          controller: withdrawUpdateController
                                                              .searchController,
                                                          focusNode: withdrawUpdateController
                                                              .searchFocusNode,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 10,
                                                              vertical: 8,
                                                            ),
                                                            hintText: 'جستجوی کاربر...',
                                                            hintStyle: AppTextStyle
                                                                .labelText,
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  value: withdrawUpdateController
                                                      .selectedAccount.value
                                                      ?.name,
                                                  showSearchBox: true,
                                                  items:[
                                                  ...withdrawUpdateController
                                                      .searchedAccounts.map((
                                                      account) =>
                                                  '${account.id}:${account.name ?? ""}')
                                                    ].toList(),
                                                  selectedValue: withdrawUpdateController
                                                      .selectedAccount.value != null
                                                      ? '${withdrawUpdateController.selectedAccount.value!.id}:${withdrawUpdateController.selectedAccount.value!.name}'
                                                      : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue ==
                                                        'انتخاب کنید') {
                                                      withdrawUpdateController
                                                          .changeSelectedAccount(
                                                          null);
                                                    } else {
                                                      var accountId = int.tryParse(newValue!.split(':')[0]);
                                                      if (accountId != null) {
                                                        var selectedAccount = withdrawUpdateController
                                                            .searchedAccounts
                                                            .firstWhere((account) =>
                                                        account.id == accountId);
                                                        withdrawUpdateController
                                                            .changeSelectedAccount(
                                                            selectedAccount);
                                                      }
                                                    }
                                                  },
                                                  onMenuStateChange: withdrawUpdateController.onDropdownMenuStateChange,
                                                  backgroundColor: AppColor
                                                      .textFieldColor,
                                                  borderRadius: 7,
                                                  borderColor: AppColor
                                                      .secondaryColor,
                                                  hideUnderline: true,
                                                ),
                                              ),*/
                                              // بانک اکانت
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'حساب بانک',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),*/
                                              // بانک اکانت
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  hint: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "انتخاب کنید",
                                                          style: AppTextStyle
                                                              .labelText
                                                              .copyWith(
                                                            fontSize: 14,
                                                            color: AppColor
                                                                .textColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  items:
                                                  withdrawUpdateController
                                                      .bankAccountList.map((
                                                      bankAccount) {
                                                    return DropdownMenuItem(
                                                        value: bankAccount,
                                                        child: Row(
                                                          children: [
                                                            Text("${bankAccount
                                                                .bank!.name}" ??
                                                                "",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                            Text(bankAccount
                                                                .ownerName ??
                                                                "",
                                                              style: AppTextStyle
                                                                  .bodyText,),

                                                          ],
                                                        ));
                                                  }).toList(),
                                                  value: withdrawUpdateController
                                                      .selectedBankAccount
                                                      .value,
                                                  onChanged: (newValue) {
                                                    if (newValue != null) {
                                                      withdrawUpdateController
                                                          .changeSelectedBankAccount(
                                                          newValue);
                                                    }
                                                  },
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(7),
                                                      color: AppColor
                                                          .textFieldColor,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .backGroundColor,
                                                          width: 1),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  iconStyleData: IconStyleData(
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    iconSize: 23,
                                                    iconEnabledColor: AppColor
                                                        .textColor,
                                                    iconDisabledColor: Colors
                                                        .grey,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                    maxHeight: 200,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(7),
                                                      color: AppColor
                                                          .textFieldColor,
                                                    ),
                                                    offset: const Offset(0, 0),
                                                    scrollbarTheme: ScrollbarThemeData(
                                                      radius: const Radius
                                                          .circular(7),
                                                      thickness: WidgetStateProperty
                                                          .all(6),
                                                      thumbVisibility: WidgetStateProperty
                                                          .all(true),
                                                    ),
                                                  ),
                                                  menuItemStyleData: const MenuItemStyleData(
                                                    height: 40,
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                  ),
                                                ),
                                              ),*/
                                              // نام بانک
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'نام بانک',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // نام بانک
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: CustomDropdown<BankModel>(
                                                  items: withdrawUpdateController.bankList,
                                                  selectedItem: withdrawUpdateController.selectedBank.value,
                                                  enableSearch: true,
                                                  errorText: withdrawUpdateController.dropdownError.value,
                                                  itemLabel: (bank) =>
                                                  bank.name ??
                                                      "",
                                                  itemIcon: (bank) =>
                                                  bank.icon ??
                                                      "",
                                                  onChanged: (bank) {
                                                    setState(() {
                                                      withdrawUpdateController.selectedBank.value = bank;
                                                      withdrawUpdateController.dropdownError.value = "";

                                                      withdrawUpdateController.changeSelectedBank(bank);
                                                    });
                                                    debugPrint(
                                                      "بانک انتخاب شد: ${bank?.name}",
                                                    );
                                                  },
                                                  isIcon: true,
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
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'نام صاحب حساب',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // نام صاحب حساب
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .ownerNameController,
                                                    style: AppTextStyle.bodyText,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // مبلغ
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'مبلغ (ریال)',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // مبلغ
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .amountController,
                                                    style: AppTextStyle.labelText,
                                                    keyboardType: TextInputType
                                                        .number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                                                    ],
                                                    onChanged: (value) {
                                                      // حذف کاماهای قبلی و فرمت جدید
                                                      String cleanedValue = value
                                                          .replaceAll(',', '');
                                                      if (cleanedValue
                                                          .isNotEmpty) {
                                                        withdrawUpdateController
                                                            .amountController
                                                            .text =
                                                            cleanedValue
                                                                .toPersianDigit()
                                                                .seRagham();
                                                        withdrawUpdateController
                                                            .amountController
                                                            .selection =
                                                            TextSelection
                                                                .collapsed(
                                                                offset: withdrawUpdateController
                                                                    .amountController
                                                                    .text.length);
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //شماره کارت
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'شماره کارت',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // شماره کارت
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .cardNumberController,
                                                    style: AppTextStyle.bodyText,
                                                    keyboardType: TextInputType
                                                        .number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(r'[۰-۹0-9]')),
                                                      LengthLimitingTextInputFormatter(16),
                                                    ],
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'لطفا شماره کارت را وارد کنید';
                                                      }
                                                      if (value.length != 16) {
                                                        return 'شماره کارت باید دقیقاً 16 رقم باشد';
                                                      }
                                                      return null;
                                                    },
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //شماره حساب
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'شماره حساب',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              //شماره حساب
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .numberController,
                                                    style: AppTextStyle.bodyText,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                          r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                      TextInputFormatter
                                                          .withFunction((
                                                          oldValue, newValue) {
                                                        // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                        String newText = newValue
                                                            .text
                                                            .replaceAll(
                                                            '٠', '0')
                                                            .replaceAll(
                                                            '١', '1')
                                                            .replaceAll(
                                                            '٢', '2')
                                                            .replaceAll(
                                                            '٣', '3')
                                                            .replaceAll(
                                                            '٤', '4')
                                                            .replaceAll(
                                                            '٥', '5')
                                                            .replaceAll(
                                                            '٦', '6')
                                                            .replaceAll(
                                                            '٧', '7')
                                                            .replaceAll(
                                                            '٨', '8')
                                                            .replaceAll(
                                                            '٩', '9');

                                                        return newValue
                                                            .copyWith(
                                                            text: newText,
                                                            selection: TextSelection
                                                                .collapsed(
                                                                offset: newText
                                                                    .length));
                                                      }),
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //شماره شبا
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'شماره شبا',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              //شماره شبا
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .shebaController,
                                                    style: AppTextStyle.bodyText,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // تاریخ
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'تاریخ درخواست',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // تاریخ
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: TextFormField(
                                                  controller: withdrawUpdateController
                                                      .dateController,
                                                  readOnly: true,
                                                  style: AppTextStyle.labelText,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
                                                        Icons.calendar_month,
                                                        color: AppColor
                                                            .textColor),
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                    ),
                                                    filled: true,
                                                    fillColor: AppColor
                                                        .textFieldColor,
                                                  ),
                                                  onTap: () async {
                                                    Jalali? pickedDate = await showPersianDatePicker(
                                                      context: context,
                                                      initialDate: Jalali.now(),
                                                      firstDate: Jalali(
                                                          1400, 1, 1),
                                                      lastDate: Jalali(
                                                          1450, 12, 29),
                                                      initialEntryMode: PersianDatePickerEntryMode
                                                          .calendar,
                                                      initialDatePickerMode: PersianDatePickerMode
                                                          .day,
                                                      locale: Locale(
                                                          "fa", "IR"),
                                                    );

                                                    DateTime date = DateTime
                                                        .now();

                                                    if (pickedDate != null) {
                                                      withdrawUpdateController
                                                          .dateController.text =
                                                      "${pickedDate
                                                          .year}/${pickedDate
                                                          .month.toString()
                                                          .padLeft(
                                                          2, '0')}/${pickedDate
                                                          .day.toString()
                                                          .padLeft(
                                                          2, '0')} ${date.hour
                                                          .toString().padLeft(
                                                          2, '0')}:${date.minute
                                                          .toString().padLeft(
                                                          2, '0')}:${date.second
                                                          .toString().padLeft(
                                                          2, '0')}";
                                                    }
                                                  },
                                                ),
                                              ),
                                              // توضیحات
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'توضیحات',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // توضیحات
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawUpdateController
                                                        .descriptionController,
                                                    maxLines: 3,
                                                    style: AppTextStyle.labelText,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // نمایش و بارگذاری تصویر
                                              Container(
                                                //width: Get.width * 0.7,
                                                height: 90,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: withdrawUpdateController.imageList.map((e)=>
                                                        Stack(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                showGeneralDialog(
                                                                    context: context,
                                                                    barrierDismissible: true,
                                                                    barrierLabel: MaterialLocalizations.of(context)
                                                                        .modalBarrierDismissLabel,
                                                                    barrierColor: Colors.black45,
                                                                    transitionDuration: const Duration(milliseconds: 200),
                                                                    pageBuilder: (BuildContext buildContext,
                                                                        Animation animation,
                                                                        Animation secondaryAnimation) {
                                                                      return Center(
                                                                        child: Material(
                                                                          color: Colors.transparent,
                                                                          child: Container(
                                                                            margin: EdgeInsets.all(10),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                border: Border.all(color: AppColor.textColor),
                                                                                image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.fill,
                                                                                )
                                                                            ),
                                                                            height: Get.height * 0.8,width: Get.width * 0.4,
                                                                            // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(color: AppColor.textColor),
                                                                    image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.cover,
                                                                    )
                                                                ),
                                                                height: 60,width: 60,
                                                                // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              child: CircleAvatar(
                                                                backgroundColor: AppColor.accentColor,radius: 10,
                                                                child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                              ),
                                                              onTap: (){
                                                                withdrawUpdateController.deleteImage(e);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                    ).toList(),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(bottom: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            withdrawUpdateController.pickImageDesktop(),
                                                        child: Container(
                                                          constraints: BoxConstraints(maxWidth: 100),
                                                          child: SvgPicture
                                                              .asset(
                                                            'assets/svg/camera.svg',
                                                            width: 30,
                                                            height: 30,
                                                            colorFilter: ColorFilter
                                                                .mode(
                                                                AppColor
                                                                    .iconViewColor,
                                                                BlendMode
                                                                    .srcIn),),
                                                        ),

                                                      ),
                                                      Obx(() {
                                                        if (withdrawUpdateController
                                                            .isUploadingDesktop
                                                            .value) {
                                                          return Row(
                                                            children: [
                                                              Text(
                                                                'در حال بارگزاری عکس',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                                                    fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                              ),
                                                              SizedBox(width: 10,),
                                                              CircularProgressIndicator(),
                                                            ],
                                                          );
                                                        }
                                                        return Container(
                                                          height: 80,
                                                          //width: Get.width * 0.15,
                                                          child:  Row(
                                                              children: withdrawUpdateController.selectedImagesDesktop.map((e){
                                                                return  Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:(){
                                                                        showGeneralDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            barrierLabel: MaterialLocalizations.of(context)
                                                                                .modalBarrierDismissLabel,
                                                                            barrierColor: Colors.black45,
                                                                            transitionDuration: const Duration(milliseconds: 200),
                                                                            pageBuilder: (BuildContext buildContext,
                                                                                Animation animation,
                                                                                Animation secondaryAnimation) {
                                                                              return Center(
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.all(10),
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        border: Border.all(color: AppColor.textColor),
                                                                                        image: DecorationImage(
                                                                                          image:e.path.startsWith('http') || kIsWeb ?
                                                                                          NetworkImage(e.path)
                                                                                              : FileImage(File(e.path)) as ImageProvider,
                                                                                          fit: BoxFit.fill,
                                                                                        )
                                                                                    ),
                                                                                    height: Get.height * 0.8,width: Get.width * 0.4,
                                                                                    // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child: Container(
                                                                        margin: EdgeInsets.all(10),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            border: Border.all(color: AppColor.textColor),
                                                                            image: DecorationImage(
                                                                              image:e!.path.startsWith('http') || kIsWeb ?
                                                                              NetworkImage(e.path)
                                                                                  : FileImage(File(e.path)) as ImageProvider,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                        ),
                                                                        height: 60,width: 60,
                                                                        // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                      ),
                                                                    ),
                                                                    /*Container(
                                                                      margin: EdgeInsets.all(10),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          border: Border.all(color: AppColor.textColor),
                                                                          image: DecorationImage(image: NetworkImage(e!.path,),fit: BoxFit.cover,)
                                                                      ),
                                                                      height: 60,width: 60,
                                                                      // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                    ),*/
                                                                    GestureDetector(
                                                                      child: CircleAvatar(
                                                                        backgroundColor: AppColor.accentColor,radius: 10,
                                                                        child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                                      ),
                                                                      onTap: (){
                                                                        withdrawUpdateController.selectedImagesDesktop.remove(e);
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                              }).toList(),
                                                            ),
                                                        );
                                                      }),
                                                    ],
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
                                                          Size(Get.width * .77,
                                                              40)),
                                                      padding: WidgetStatePropertyAll(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 7)),
                                                      elevation: WidgetStatePropertyAll(
                                                          5),
                                                      backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          AppColor
                                                              .primaryColor),
                                                      shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10)))),
                                                  onPressed: () async {
                                                    if(withdrawUpdateController.cardNumberController.text.isNotEmpty ||
                                                        withdrawUpdateController.numberController.text.isNotEmpty ||
                                                        withdrawUpdateController.shebaController.text.isNotEmpty || withdrawUpdateController.imageList.isNotEmpty){
                                                      await withdrawUpdateController.uploadImagesDesktop( "image", "WithdrawRequest");
                                                    }else{
                                                      Get.snackbar("فیلدهای ضروری را پر کنید", "شماره کارت-یا شماره حساب-یا شماره شبا");
                                                    }

                                                  },
                                                  child: withdrawUpdateController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'ویرایش درخواست',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                              )

                                            ],
                                          ),
                                        ),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(isDesktop)
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child:
                            Obx(() {
                              if(withdrawUpdateController.selectedAccount.value==null){
                                return SizedBox.shrink();
                              }
                              if (withdrawUpdateController.isLoadingTooltipBalance.value || withdrawUpdateController.tooltipTotalBalanceModel.value == null) {
                                return Center(child: CircularProgressIndicator());
                              }
                              return Row(mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/svg/camera.svg',
                                      height: 24,
                                      colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                                    ),
                                    tooltip: 'گرفتن اسکرین شات',
                                    onPressed: () => withdrawUpdateController.captureBalanceScreenshot(context, _balanceKey),
                                  ),
                                  RepaintBoundary(
                                    key: _balanceKey,
                                    child: TooltipTotalBalanceWidget(
                                      tooltipTotalBalance: withdrawUpdateController.tooltipTotalBalanceModel.value!,
                                      size: 400,
                                      title: "${withdrawUpdateController.selectedAccount.value!=null && withdrawUpdateController.selectedAccount.value!.name!.length > 32
                                          ? '${withdrawUpdateController.selectedAccount.value?.name?.substring(0, 32) ?? ""}...'
                                          : withdrawUpdateController.selectedAccount.value?.name ?? ""}${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
        floatingActionButton: isDesktop ? FloatingActionButton(
          onPressed: () {
            Get.dialog(const ChatDialog());
          },
          backgroundColor: AppColor.primaryColor,
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ): SizedBox.shrink(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
