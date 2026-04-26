
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_create.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/widget/image_drop_zone_withdraw.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_dropdown1.widget.dart';
import '../../account/model/account.model.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../../order/widget/tooltip_total_balance.widget.dart';

class WithdrawCreateView extends StatefulWidget {
  WithdrawCreateView({super.key});

  @override
  State<WithdrawCreateView> createState() => _WithdrawCreateState();
}

class _WithdrawCreateState extends State<WithdrawCreateView> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey _balanceKey = GlobalKey();
  WithdrawCreateController withdrawCreateController = Get.find<
      WithdrawCreateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(() {
      return Scaffold(
        appBar:
        CustomAppbar1(
          title: 'ایجاد درخواست برداشت', onBackTap: () => Get.toNamed('/home'),),
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
                            child: Obx(() {
                              if(withdrawCreateController.selectedAccount.value==null){
                                return SizedBox.shrink();
                              }
                              if (withdrawCreateController.isLoadingTooltipBalance.value || withdrawCreateController.tooltipTotalBalanceModel.value == null) {
                                return Center(child: CircularProgressIndicator());
                              }
                              return TooltipTotalBalanceWidget(
                                tooltipTotalBalance: withdrawCreateController.tooltipTotalBalanceModel.value!,
                                size: double.infinity,
                                title: withdrawCreateController.selectedAccount.value?.name ?? "",
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
                                            'ایجاد درخواست برداشت جدید',
                                            style: AppTextStyle.smallTitleText,
                                          ),
                                        ),

                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed('/withdrawsList');
                                                withdrawCreateController
                                                    .clearList();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right:  50,
                                                    bottom: 10
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    /*Text('لیست',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                    SizedBox(width: 10,),*/
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
                                              withdrawCreateController.accountList.isEmpty ?
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
                                              withdrawCreateController.accountList.isEmpty ?
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
                                                  items: withdrawCreateController.accountList,
                                                  selectedItem: withdrawCreateController.selectedAccount.value,
                                                  enableSearch: true,
                                                  errorText: withdrawCreateController.dropdownError.value,
                                                  itemLabel: (account) =>
                                                  account.name ??
                                                      "",
                                                  /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                                                  onChanged: (account) {
                                                    setState(() {
                                                      withdrawCreateController.selectedAccount.value = account;
                                                      withdrawCreateController.dropdownError.value = "";

                                                      withdrawCreateController.changeSelectedAccount(
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
                                                    searchController: withdrawCreateController
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
                                                          controller: withdrawCreateController
                                                              .searchController,
                                                          focusNode: withdrawCreateController
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
                                                  value: withdrawCreateController
                                                      .selectedAccount.value,
                                                  validator: (value) {
                                                    if (value ==
                                                        'انتخاب کنید' ||
                                                        value == null ||
                                                        value.isEmpty) {
                                                      return 'کاربر را انتخاب کنید';
                                                    }
                                                    return null;
                                                  },
                                                  showSearchBox: true,
                                                  items: [
                                                    'انتخاب کنید',
                                                    ...withdrawCreateController
                                                        .searchedAccounts.map((
                                                        account) =>
                                                    '${account.id}:${account.name ?? ""}')
                                                  ].toList(),
                                                  selectedValue: withdrawCreateController
                                                      .selectedAccount.value != null
                                                      ? '${withdrawCreateController.selectedAccount.value!.id}:${withdrawCreateController.selectedAccount.value!.name}'
                                                      : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue ==
                                                        'انتخاب کنید') {
                                                      withdrawCreateController
                                                          .changeSelectedAccount(
                                                          null);
                                                    } else {
                                                      var accountId = int.tryParse(newValue!.split(':')[0]);
                                                      if (accountId != null) {
                                                        var selectedAccount = withdrawCreateController
                                                            .searchedAccounts
                                                            .firstWhere((account) =>
                                                        account.id == accountId);
                                                        withdrawCreateController
                                                            .changeSelectedAccount(
                                                            selectedAccount);
                                                      }
                                                    }
                                                  },
                                                  *//*onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      withdrawCreateController
                                                          .resetAccountSearch();
                                                    }
                                                  },*//*
                                                  onMenuStateChange: withdrawCreateController.onDropdownMenuStateChange,
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
                                                  withdrawCreateController
                                                      .bankAccountList.map((
                                                      bankAccount) {
                                                    return DropdownMenuItem(
                                                        value: bankAccount,
                                                        child: Row(
                                                          children: [
                                                            Text("${bankAccount
                                                                .bank!
                                                                .name} , " ??
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
                                                  value: withdrawCreateController
                                                      .selectedBankAccount
                                                      .value,
                                                  onChanged: (newValue) {
                                                    if (newValue != null) {
                                                      withdrawCreateController.changeSelectedBankAccount(newValue);
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
                                                  items: withdrawCreateController.bankList,
                                                  selectedItem: withdrawCreateController.selectedBank.value,
                                                  enableSearch: true,
                                                  errorText: withdrawCreateController.dropdownError.value,
                                                  itemLabel: (bank) =>
                                                  bank.name ??
                                                      "",
                                                  itemIcon: (bank) =>
                                                     bank.icon ??
                                                         "",
                                                  onChanged: (bank) {
                                                    setState(() {
                                                      withdrawCreateController.selectedBank.value = bank;
                                                      withdrawCreateController.dropdownError.value = "";

                                                      withdrawCreateController.changeSelectedBank(
                                                          bank);
                                                    });
                                                    debugPrint(
                                                      "بانک انتخاب شد: ${bank?.name}",
                                                    );
                                                  },
                                                  isIcon: true,
                                                ),
                                              ),
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: CustomDropdownWidget(
                                                  dropdownSearchData: DropdownSearchData<
                                                      String>(
                                                    searchController: withdrawCreateController
                                                        .searchBankController,
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
                                                          controller: withdrawCreateController
                                                              .searchBankController,
                                                          focusNode: withdrawCreateController
                                                              .searchFocusNodeBank,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 10,
                                                              vertical: 8,
                                                            ),
                                                            hintText: 'جستجوی بانک...',
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
                                                  value: withdrawCreateController
                                                      .selectedBank.value,
                                                  validator: (value) {
                                                    if (value ==
                                                        'انتخاب کنید' ||
                                                        value == null ||
                                                        value.isEmpty) {
                                                      return 'بانک را انتخاب کنید';
                                                    }
                                                    return null;
                                                  },
                                                  showSearchBox: true,
                                                  items: [
                                                    'انتخاب کنید',
                                                    ...withdrawCreateController
                                                        .searchedBanks.map((
                                                        bank) =>
                                                    '${bank.id}:${bank.name ?? ""}')
                                                  ].toList(),
                                                  selectedValue: withdrawCreateController
                                                      .selectedBank.value != null
                                                      ? '${withdrawCreateController.selectedBank.value!.id}:${withdrawCreateController.selectedBank.value!.name}'
                                                      : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue ==
                                                        'انتخاب کنید') {
                                                      withdrawCreateController
                                                          .changeSelectedBank(
                                                          null);
                                                    } else {
                                                      var bankId = int.tryParse(newValue!.split(':')[0]);
                                                      if (bankId != null) {
                                                        var selectedBank = withdrawCreateController
                                                            .searchedBanks
                                                            .firstWhere((bank) =>
                                                        bank.id == bankId);
                                                        withdrawCreateController
                                                            .changeSelectedBank(
                                                            selectedBank);
                                                      }
                                                    }
                                                  },
                                                  *//*onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      withdrawCreateController
                                                          .resetAccountSearch();
                                                    }
                                                  },*//*
                                                  onMenuStateChange: withdrawCreateController.onDropdownMenuStateChangeBank,
                                                  backgroundColor: AppColor
                                                      .textFieldColor,
                                                  borderRadius: 7,
                                                  borderColor: AppColor
                                                      .secondaryColor,
                                                  hideUnderline: true,
                                                  dataList: withdrawCreateController.searchedBanks,
                                                  getItemIcon: (bank) {
                                                    if (bank.icon != null) {
                                                      return '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${bank.icon}';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),*/
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
                                                height: 60,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                IntrinsicHeight(
                                                  child: TextSelectionTheme(
                                                    data: TextSelectionThemeData(
                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                    ),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا نام صاحب حساب را وارد کنید';
                                                        }
                                                        return null;
                                                      },
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: withdrawCreateController
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
                                                height: 60,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                IntrinsicHeight(
                                                  child: TextSelectionTheme(
                                                    data: TextSelectionThemeData(
                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                    ),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا مبلغ را وارد کنید';
                                                        }
                                                        return null;
                                                      },
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: withdrawCreateController
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
                                                          withdrawCreateController
                                                              .amountController
                                                              .text =
                                                              cleanedValue
                                                                  .toPersianDigit()
                                                                  .seRagham();
                                                          withdrawCreateController
                                                              .amountController
                                                              .selection =
                                                              TextSelection
                                                                  .collapsed(
                                                                  offset: withdrawCreateController
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
                                                //height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawCreateController
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
                                                    controller: withdrawCreateController
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
                                                    controller: withdrawCreateController
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
                                                    controller: withdrawCreateController
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
                                              // بارگذاری عکس
                                              /*Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Obx(() {
                                                    if (withdrawCreateController
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
                                                    return SizedBox(
                                                      height: 80,
                                                      width: Get.width * 0.17,
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: withdrawCreateController.selectedImagesDesktop.map((e){
                                                            return  Stack(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(color: AppColor.textColor),
                                                                      image: DecorationImage(image: NetworkImage(e!.path,),fit: BoxFit.cover,)
                                                                  ),
                                                                  height: 60,width: 60,
                                                                  // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                ),
                                                                GestureDetector(
                                                                  child: CircleAvatar(
                                                                    backgroundColor: AppColor.accentColor,radius: 10,
                                                                    child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                                  ),
                                                                  onTap: (){
                                                                    withdrawCreateController.selectedImagesDesktop.remove(e);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        withdrawCreateController.pickImageDesktop(),
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

                                                ],
                                              ),*/
                                              // بارگذاری عکس
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Drag and Drop Zone
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
                                                                      withdrawCreateController
                                                                          .pickImageMobile(ImageSource.gallery);
                                                                    },
                                                                  ),
                                                                  ListTile(
                                                                    leading: Icon(Icons.camera_alt,color: AppColor.textColor,),
                                                                    title: Text('دوربین',style: AppTextStyle.bodyText.copyWith(fontSize: 16,fontWeight: FontWeight.w700),),
                                                                    onTap: () {
                                                                      Get.back();
                                                                      withdrawCreateController
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
                                                    child: ImageDropZoneWithdraw(
                                                      controller: withdrawCreateController,
                                                      isDesktop: isDesktop,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Selected Images Preview
                                                  Obx(() {
                                                    if (withdrawCreateController.isUploadingDesktop.value) {
                                                      return Container(
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: AppColor.textFieldColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'در حال بارگزاری عکس',
                                                              style: AppTextStyle.labelText.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.normal,
                                                                color: AppColor.textColor,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            const CircularProgressIndicator(),
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (withdrawCreateController.selectedImagesDesktop.isEmpty) {
                                                      return const SizedBox.shrink();
                                                    }

                                                    return Container(
                                                      height: 80,
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: AppColor.textFieldColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(
                                                          color: AppColor.textColor.withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: withdrawCreateController.selectedImagesDesktop.map((image) {
                                                            return Stack(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
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
                                                                                image: DecorationImage(
                                                                                  image: FileImage(File(image.path)) as ImageProvider,
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ),
                                                                              height: Get.height * 0.6,
                                                                              width: Get.width * 0.8,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    margin: const EdgeInsets.all(4),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(color: AppColor.textColor),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.1),
                                                                          blurRadius: 4,
                                                                          offset: const Offset(0, 2),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    height: 60,
                                                                    width: 60,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child: Image.file(
                                                                        File(image!.path),
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return Container(
                                                                            color: AppColor.textColor.withOpacity(0.1),
                                                                            child: Icon(
                                                                              Icons.image,
                                                                              color: AppColor.textColor.withOpacity(0.5),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      withdrawCreateController.selectedImagesDesktop.remove(image);
                                                                    },
                                                                    child: CircleAvatar(
                                                                      backgroundColor: AppColor.accentColor,
                                                                      radius: 12,
                                                                      child: Icon(
                                                                        Icons.clear,
                                                                        color: AppColor.textColor,
                                                                        size: 16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                              // دکمه ایجاد درخواست
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
                                                    /*if(withdrawCreateController.selectedAccount.value?.id!=null &&
                                                        withdrawCreateController.selectedBank.value!=null){*/
                                                      if(withdrawCreateController.selectedAccount.value!=null || withdrawCreateController.cardNumberController.text.isNotEmpty ||
                                                          withdrawCreateController.numberController.text.isNotEmpty ||
                                                          withdrawCreateController.shebaController.text.isNotEmpty || withdrawCreateController.selectedImagesDesktop.isNotEmpty){
                                                        await withdrawCreateController.uploadImagesDesktop( "image", "WithdrawRequest");
                                                      }
                                                    //}

                                                  },
                                                  child: withdrawCreateController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'ایجاد درخواست',
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
                              width: Get.width * 0.8,
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
                                              right: 30, bottom: 10),
                                          child: Text(
                                            'ایجاد درخواست برداشت جدید',
                                            style: AppTextStyle.smallTitleText,
                                          ),
                                        ),

                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed('/withdrawsList');
                                                withdrawCreateController
                                                    .clearList();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: isDesktop ? 100 : 135,
                                                    bottom: 10
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    Text('لیست',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                    SizedBox(width: 10,),
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
                                    child: isDesktop ? SizedBox(width: 400,
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
                                            maxWidth: 450),
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
                                              withdrawCreateController.accountList.isEmpty ?
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
                                              withdrawCreateController.accountList.isEmpty ?
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
                                                  items: withdrawCreateController.accountList,
                                                  selectedItem: withdrawCreateController.selectedAccount.value,
                                                  enableSearch: true,
                                                  errorText: withdrawCreateController.dropdownError.value,
                                                  itemLabel: (account) =>
                                                  account.name ??
                                                      "",
                                                  /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                                                  onChanged: (account) {
                                                    setState(() {
                                                      withdrawCreateController.selectedAccount.value = account;
                                                      withdrawCreateController.dropdownError.value = "";

                                                      withdrawCreateController.changeSelectedAccount(
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
                                                    searchController: withdrawCreateController
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
                                                          controller: withdrawCreateController
                                                              .searchController,
                                                          focusNode: withdrawCreateController
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
                                                  value: withdrawCreateController
                                                      .selectedAccount.value,
                                                  validator: (value) {
                                                    if (value ==
                                                        'انتخاب کنید' ||
                                                        value == null ||
                                                        value.isEmpty) {
                                                      return 'کاربر را انتخاب کنید';
                                                    }
                                                    return null;
                                                  },
                                                  showSearchBox: true,
                                                  items: [
                                                    'انتخاب کنید',
                                                    ...withdrawCreateController
                                                        .searchedAccounts.map((
                                                        account) =>
                                                    '${account.id}:${account.name ?? ""}')
                                                  ].toList(),
                                                  selectedValue: withdrawCreateController
                                                      .selectedAccount.value != null
                                                      ? '${withdrawCreateController.selectedAccount.value!.id}:${withdrawCreateController.selectedAccount.value!.name}'
                                                      : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue ==
                                                        'انتخاب کنید') {
                                                      withdrawCreateController
                                                          .changeSelectedAccount(
                                                          null);
                                                    } else {
                                                      var accountId = int.tryParse(newValue!.split(':')[0]);
                                                      if (accountId != null) {
                                                        var selectedAccount = withdrawCreateController
                                                            .searchedAccounts
                                                            .firstWhere((account) =>
                                                        account.id == accountId);
                                                        withdrawCreateController
                                                            .changeSelectedAccount(
                                                            selectedAccount);
                                                      }
                                                    }
                                                  },
                                                  *//*onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      withdrawCreateController
                                                          .resetAccountSearch();
                                                    }
                                                  },*//*
                                                  onMenuStateChange: withdrawCreateController.onDropdownMenuStateChange,
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
                                                  withdrawCreateController
                                                      .bankAccountList.map((
                                                      bankAccount) {
                                                    return DropdownMenuItem(
                                                        value: bankAccount,
                                                        child: Row(
                                                          children: [
                                                            Text("${bankAccount
                                                                .bank!
                                                                .name} , " ??
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
                                                  value: withdrawCreateController
                                                      .selectedBankAccount
                                                      .value,
                                                  onChanged: (newValue) {
                                                    if (newValue != null) {
                                                      withdrawCreateController.changeSelectedBankAccount(newValue);
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
                                                  items: withdrawCreateController.bankList,
                                                  selectedItem: withdrawCreateController.selectedBank.value,
                                                  enableSearch: true,
                                                  errorText: withdrawCreateController.dropdownError.value,
                                                  itemLabel: (bank) =>
                                                  bank.name ??
                                                      "",
                                                  itemIcon: (bank) =>
                                                  bank.icon ??
                                                      "",
                                                  onChanged: (bank) {
                                                    setState(() {
                                                      withdrawCreateController.selectedBank.value = bank;
                                                      withdrawCreateController.dropdownError.value = "";

                                                      withdrawCreateController.changeSelectedBank(
                                                          bank);
                                                    });
                                                    debugPrint(
                                                      "بانک انتخاب شد: ${bank?.name}",
                                                    );
                                                  },
                                                  isIcon: true,
                                                ),
                                              ),
                                              /*Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: CustomDropdownWidget(
                                                  dropdownSearchData: DropdownSearchData<
                                                      String>(
                                                    searchController: withdrawCreateController
                                                        .searchBankController,
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
                                                          controller: withdrawCreateController
                                                              .searchBankController,
                                                          focusNode: withdrawCreateController
                                                              .searchFocusNodeBank,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 10,
                                                              vertical: 8,
                                                            ),
                                                            hintText: 'جستجوی بانک...',
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
                                                  value: withdrawCreateController
                                                      .selectedBank.value,
                                                  validator: (value) {
                                                    if (value ==
                                                        'انتخاب کنید' ||
                                                        value == null ||
                                                        value.isEmpty) {
                                                      return 'بانک را انتخاب کنید';
                                                    }
                                                    return null;
                                                  },
                                                  showSearchBox: true,
                                                  items: [
                                                    'انتخاب کنید',
                                                    ...withdrawCreateController
                                                        .searchedBanks.map((
                                                        bank) =>
                                                    '${bank.id}:${bank.name ?? ""}')
                                                  ].toList(),
                                                  selectedValue: withdrawCreateController
                                                      .selectedBank.value != null
                                                      ? '${withdrawCreateController.selectedBank.value!.id}:${withdrawCreateController.selectedBank.value!.name}'
                                                      : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue ==
                                                        'انتخاب کنید') {
                                                      withdrawCreateController
                                                          .changeSelectedBank(
                                                          null);
                                                    } else {
                                                      var bankId = int.tryParse(newValue!.split(':')[0]);
                                                      if (bankId != null) {
                                                        var selectedBank = withdrawCreateController
                                                            .searchedBanks
                                                            .firstWhere((bank) =>
                                                        bank.id == bankId);
                                                        withdrawCreateController
                                                            .changeSelectedBank(
                                                            selectedBank);
                                                      }
                                                    }
                                                  },
                                                  *//*onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      withdrawCreateController
                                                          .resetAccountSearch();
                                                    }
                                                  },*//*
                                                  onMenuStateChange: withdrawCreateController.onDropdownMenuStateChangeBank,
                                                  backgroundColor: AppColor
                                                      .textFieldColor,
                                                  borderRadius: 7,
                                                  borderColor: AppColor
                                                      .secondaryColor,
                                                  hideUnderline: true,
                                                  dataList: withdrawCreateController.searchedBanks,
                                                  getItemIcon: (bank) {
                                                    if (bank.icon != null) {
                                                      return '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${bank.icon}';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),*/
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
                                                height: 60,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                IntrinsicHeight(
                                                  child: TextSelectionTheme(
                                                    data: TextSelectionThemeData(
                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                    ),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا نام صاحب حساب را وارد کنید';
                                                        }
                                                        return null;
                                                      },
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: withdrawCreateController
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
                                                height: 60,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                IntrinsicHeight(
                                                  child: TextSelectionTheme(
                                                    data: TextSelectionThemeData(
                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                    ),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا مبلغ را وارد کنید';
                                                        }
                                                        return null;
                                                      },
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: withdrawCreateController
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
                                                          withdrawCreateController
                                                              .amountController
                                                              .text =
                                                              cleanedValue
                                                                  .toPersianDigit()
                                                                  .seRagham();
                                                          withdrawCreateController
                                                              .amountController
                                                              .selection =
                                                              TextSelection
                                                                  .collapsed(
                                                                  offset: withdrawCreateController
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
                                                //height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextSelectionTheme(
                                                  data: TextSelectionThemeData(
                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: TextFormField(
                                                    controller: withdrawCreateController
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
                                                    controller: withdrawCreateController
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
                                                    controller: withdrawCreateController
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
                                                    controller: withdrawCreateController
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
                                              // بارگذاری عکس
                                              /*Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Obx(() {
                                                    if (withdrawCreateController
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
                                                    return SizedBox(
                                                      height: 80,
                                                      width: Get.width * 0.17,
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: withdrawCreateController.selectedImagesDesktop.map((e){
                                                            return  Stack(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(color: AppColor.textColor),
                                                                      image: DecorationImage(image: NetworkImage(e!.path,),fit: BoxFit.cover,)
                                                                  ),
                                                                  height: 60,width: 60,
                                                                  // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                                ),
                                                                GestureDetector(
                                                                  child: CircleAvatar(
                                                                    backgroundColor: AppColor.accentColor,radius: 10,
                                                                    child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                                  ),
                                                                  onTap: (){
                                                                    withdrawCreateController.selectedImagesDesktop.remove(e);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        withdrawCreateController.pickImageDesktop(),
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

                                                ],
                                              ),*/
                                              // بارگذاری عکس
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Drag and Drop Zone
                                                  GestureDetector(
                                                    onTap: () => withdrawCreateController.pickImageDesktop(),
                                                    child: ImageDropZoneWithdraw(
                                                      controller: withdrawCreateController,
                                                      isDesktop: isDesktop,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  // Selected Images Preview
                                                  Obx(() {
                                                    if (withdrawCreateController.isUploadingDesktop.value) {
                                                      return Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                          color: AppColor.textFieldColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'در حال بارگزاری عکس',
                                                              style: AppTextStyle.labelText.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.normal,
                                                                color: AppColor.textColor,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            const CircularProgressIndicator(),
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (withdrawCreateController.selectedImagesDesktop.isEmpty) {
                                                      return const SizedBox.shrink();
                                                    }

                                                    return Container(
                                                      height: 100,
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: AppColor.textFieldColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(
                                                          color: AppColor.textColor.withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: withdrawCreateController.selectedImagesDesktop.map((image) {
                                                            return Stack(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
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
                                                                                  image:image.path.startsWith('http') || kIsWeb ?
                                                                                  NetworkImage(image.path)
                                                                                      : FileImage(File(image.path)) as ImageProvider,
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ),
                                                                              height: Get.height * 0.8,
                                                                              width: Get.width * 0.4,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    margin: const EdgeInsets.all(4),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(color: AppColor.textColor),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.1),
                                                                          blurRadius: 4,
                                                                          offset: const Offset(0, 2),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    height: 80,
                                                                    width: 80,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child:
                                                                      image!.path.startsWith('http') || kIsWeb ?
                                                                      Image.network(
                                                                        image.path,
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return Container(
                                                                            color: AppColor.textColor.withOpacity(0.1),
                                                                            child: Icon(
                                                                              Icons.image,
                                                                              color: AppColor.textColor.withOpacity(0.5),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ):
                                                                      Image.file(
                                                                        File(image.path),
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return Container(
                                                                            color: AppColor.textColor.withOpacity(0.1),
                                                                            child: Icon(
                                                                              Icons.image,
                                                                              color: AppColor.textColor.withOpacity(0.5),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      withdrawCreateController.selectedImagesDesktop.remove(image);
                                                                    },
                                                                    child: CircleAvatar(
                                                                      backgroundColor: AppColor.accentColor,
                                                                      radius: 12,
                                                                      child: Icon(
                                                                        Icons.clear,
                                                                        color: AppColor.textColor,
                                                                        size: 16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                              // دکمه ایجاد درخواست
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
                                                    /*if(withdrawCreateController.selectedAccount.value?.id!=null &&
                                                        withdrawCreateController.selectedBank.value!=null){*/
                                                    if(withdrawCreateController.selectedAccount.value!=null || withdrawCreateController.cardNumberController.text.isNotEmpty ||
                                                        withdrawCreateController.numberController.text.isNotEmpty ||
                                                        withdrawCreateController.shebaController.text.isNotEmpty || withdrawCreateController.selectedImagesDesktop.isNotEmpty){
                                                      await withdrawCreateController.uploadImagesDesktop( "image", "WithdrawRequest");
                                                    }
                                                    //}

                                                  },
                                                  child: withdrawCreateController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'ایجاد درخواست',
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
                            child: Obx(() {
                              if(withdrawCreateController.selectedAccount.value==null){
                                return SizedBox.shrink();
                              }
                              if (withdrawCreateController.isLoadingTooltipBalance.value || withdrawCreateController.tooltipTotalBalanceModel.value == null) {
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
                                    onPressed: () => withdrawCreateController.captureBalanceScreenshot(context, _balanceKey),
                                  ),
                                  RepaintBoundary(
                                    key: _balanceKey,
                                    child: TooltipTotalBalanceWidget(
                                      tooltipTotalBalance: withdrawCreateController.tooltipTotalBalanceModel.value!,
                                      size: 400,
                                      title: "${withdrawCreateController.selectedAccount.value!=null && withdrawCreateController.selectedAccount.value!.name!.length > 32
                                          ? '${withdrawCreateController.selectedAccount.value?.name?.substring(0, 32) ?? ""}...'
                                          : withdrawCreateController.selectedAccount.value?.name ?? ""}${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
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
        ):SizedBox.shrink(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
