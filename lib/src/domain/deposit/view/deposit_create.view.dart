
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit_create.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../widget/image_drop_zone.widget.dart';

class DepositCreateView extends StatefulWidget {
  const DepositCreateView({super.key});

  @override
  State<DepositCreateView> createState() => _DepositCreateViewState();
}

class _DepositCreateViewState extends State<DepositCreateView> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey _balanceKey = GlobalKey();
  final DepositCreateController depositCreateController = Get.find<DepositCreateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(() {
      return Scaffold(
        appBar:
        CustomAppbar1(title: 'ثبت واریزی', onBackTap: () => Get.back(),),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal:isMobile ? 10 : 40, vertical: 20),
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
                          if(isMobile)
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child:
                              depositCreateController.isLoadingBalance.value ==
                                  false ?
                              Center(child: CircularProgressIndicator(),)
                                  :
                              BalanceWidget(
                                title: "${depositCreateController.accountController.text} ${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                listBalance: depositCreateController
                                    .balanceList,
                                size: 400,),
                            ),
                          ResponsiveRowColumnItem(
                            rowFlex: 2,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 700),
                              padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ?40: 2, vertical: 20),
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
                                width:isMobile ? Get.width * 0.95 : Get.width * 0.9,
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
                                            child: Row(
                                              children: [
                                                Text(
                                                  'ثبت واریزی',
                                                  style: AppTextStyle
                                                      .smallTitleText,
                                                ),
                                                SizedBox(width: 10,),
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: AppColor.primaryColor.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: AppColor.primaryColor.withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/svg/sticker-smile.svg',
                                                        height: 30,
                                                        colorFilter: ColorFilter.mode(
                                                          AppColor.accentColor,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                          depositCreateController.ownerNameController.text,
                                                          style: AppTextStyle.labelText.copyWith(
                                                              color: AppColor.primaryColor,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14
                                                          ),
                                                        ),

                                                    ],
                                                  ),
                                                ),
                                              ],
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
                                          constraints: isDesktop
                                              ? BoxConstraints(maxWidth: 500)
                                              : BoxConstraints(maxWidth: 400),
                                          padding: isDesktop
                                              ? const EdgeInsets.symmetric(
                                              horizontal: 40)
                                              : const EdgeInsets.symmetric(
                                              horizontal: 24),
                                          child:
                                          Form(
                                            key:formKey,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                // کاربر
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'کاربر',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                                // کاربر
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Container(
                                                    height: 50,
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    TextFormField(
                                                      controller: depositCreateController
                                                          .accountController,
                                                      style: AppTextStyle
                                                          .bodyText,
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
                                                // بانک اکانت
                                                /*Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'حساب بانک',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
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
                                                    depositCreateController
                                                        .bankAccountList.map((
                                                        bankAccount) {
                                                      return DropdownMenuItem(
                                                          value: bankAccount,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${bankAccount
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
                                                    value: depositCreateController
                                                        .selectedBankAccount
                                                        .value,
                                                    onChanged: (newValue) {
                                                      if (newValue != null) {
                                                        depositCreateController
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
                                                      offset: const Offset(
                                                          0, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(7),
                                                        thickness: WidgetStateProperty
                                                            .all(6),
                                                        thumbVisibility: WidgetStateProperty
                                                            .all(
                                                            true),
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
                                                /*Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'نام بانک',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),*/
                                                // نام بانک
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
                                                    depositCreateController
                                                        .bankList.map((bank) {
                                                      return DropdownMenuItem(
                                                          value: bank.id
                                                              .toString(),
                                                          child: Row(
                                                            children: [
                                                              bank.icon != null
                                                                  ?
                                                              Image.network(
                                                                '${BaseUrl
                                                                    .baseUrl}Attachment/downloadResource?fileName=${bank
                                                                    .icon}',
                                                                width: 22,
                                                                height: 22,)
                                                                  : SvgPicture
                                                                  .asset(
                                                                'assets/svg/bank.svg',
                                                                width: 22,
                                                                height: 22,),
                                                              SizedBox(
                                                                width: 10,),
                                                              Text(
                                                                bank.name ?? "",
                                                                style: AppTextStyle
                                                                    .bodyText,),
                                                            ],
                                                          ));
                                                    }).toList(),
                                                    value: depositCreateController
                                                        .selectedIndex,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        depositCreateController
                                                            .changeSelectedBank(
                                                            newValue!);
                                                      });
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
                                                      offset: const Offset(
                                                          0, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(7),
                                                        thickness: WidgetStateProperty
                                                            .all(6),
                                                        thumbVisibility: WidgetStateProperty
                                                            .all(
                                                            true),
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
                                                // نام صاحب حساب
                                                /*Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'نام صاحب حساب',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),*/
                                                // نام صاحب حساب
                                                /*Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  TextFormField(
                                                    controller: depositCreateController
                                                        .ownerNameController,
                                                    style: AppTextStyle
                                                        .bodyText,
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
                                                ),*/
                                                // مبلغ
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'مبلغ (ریال)',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
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
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا مبلغ را وارد کنید';
                                                        }
                                                        return null;
                                                      },
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: depositCreateController
                                                          .amountController,
                                                      style: AppTextStyle
                                                          .labelText,
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
                                                          depositCreateController
                                                              .amountController
                                                              .text =
                                                              cleanedValue
                                                                  .toPersianDigit()
                                                                  .seRagham();
                                                          depositCreateController
                                                              .amountController
                                                              .selection =
                                                              TextSelection
                                                                  .collapsed(
                                                                  offset: depositCreateController
                                                                      .amountController
                                                                      .text
                                                                      .length);
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
                                                //کد رهگیری
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'کد رهگیری',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                                // کد رهگیری
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  TextFormField(
                                                    controller: depositCreateController.trackingNumberController,
                                                    style: AppTextStyle
                                                        .bodyText,
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
                                                //شماره کارت
                                                /*Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'شماره کارت',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),*/
                                                // شماره کارت
                                                /*Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  TextFormField(
                                                    controller: depositCreateController
                                                        .numberController,
                                                    style: AppTextStyle
                                                        .bodyText,
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
                                                ),*/
                                                //شماره حساب
                                                /*Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'شماره حساب',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),*/
                                                //شماره حساب
                                                /*Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  TextFormField(
                                                    controller: depositCreateController
                                                        .cardNumberController,
                                                    style: AppTextStyle
                                                        .bodyText,
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
                                                ),*/
                                                //شماره شبا
                                                /*Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'شماره شبا',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),*/
                                                //شماره شبا
                                                /*Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  TextFormField(
                                                    controller: depositCreateController
                                                        .shebaController,
                                                    style: AppTextStyle
                                                        .bodyText,
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
                                                ),*/
                                                // تاریخ
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'تاریخ سفارش',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                                // تاریخ
                                                Container(
                                                  //height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: IntrinsicHeight(
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                        }
                                                        return null;
                                                      },
                                                      controller: depositCreateController
                                                          .dateController,
                                                      readOnly: true,
                                                      style: AppTextStyle
                                                          .labelText,
                                                      decoration: InputDecoration(
                                                        suffixIcon: Icon(Icons
                                                            .calendar_month,
                                                            color: AppColor
                                                                .textColor),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(10),
                                                        ),
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .textFieldColor,
                                                        errorMaxLines: 1,
                                                      ),
                                                      onTap: () async {
                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                          context: context,
                                                          initialDate: Jalali
                                                              .now(),
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

                                                        if (pickedDate !=
                                                            null) {
                                                          depositCreateController
                                                              .dateController
                                                              .text =
                                                          "${pickedDate
                                                              .year}/${pickedDate
                                                              .month.toString()
                                                              .padLeft(2,
                                                              '0')}/${pickedDate
                                                              .day.toString()
                                                              .padLeft(
                                                              2, '0')} ${date
                                                              .hour.toString()
                                                              .padLeft(
                                                              2, '0')}:${date
                                                              .minute.toString()
                                                              .padLeft(
                                                              2, '0')}:${date
                                                              .second.toString()
                                                              .padLeft(
                                                              2, '0')}";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                // اضافه واریزی
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'اضافه واریزی (ریال)',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                                // اضافه واریزی
                                                Container(
                                                  height: 60,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: TextFormField(
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    controller: depositCreateController
                                                        .extraAmountController,
                                                    style: AppTextStyle
                                                        .labelText,
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
                                                        depositCreateController
                                                            .extraAmountController
                                                            .text =
                                                            cleanedValue
                                                                .toPersianDigit()
                                                                .seRagham();
                                                        depositCreateController
                                                            .extraAmountController
                                                            .selection =
                                                            TextSelection
                                                                .collapsed(
                                                                offset: depositCreateController
                                                                    .extraAmountController
                                                                    .text
                                                                    .length);
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
                                                // بارگذاری عکس
                                                /*Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Obx(() {
                                                      if (depositCreateController
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
                                                            children: depositCreateController.selectedImagesDesktop.map((e){
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
                                                                      depositCreateController.selectedImagesDesktop.remove(e);
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
                                                          depositCreateController.pickImageDesktop(),
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
                                                    isMobile ?
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
                                                                        depositCreateController
                                                                            .pickImageMobile(ImageSource.gallery);
                                                                      },
                                                                    ),
                                                                    ListTile(
                                                                      leading: Icon(Icons.camera_alt,color: AppColor.textColor,),
                                                                      title: Text('دوربین',style: AppTextStyle.bodyText.copyWith(fontSize: 16,fontWeight: FontWeight.w700),),
                                                                      onTap: () {
                                                                        Get.back();
                                                                        depositCreateController
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
                                                      child: ImageDropZone(
                                                        controller: depositCreateController,
                                                        isDesktop: isDesktop,
                                                      ),
                                                    ):
                                                    GestureDetector(
                                                      onTap: () => depositCreateController.pickImageDesktop(),
                                                      child: ImageDropZone(
                                                        controller: depositCreateController,
                                                        isDesktop: isDesktop,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    // Selected Images Preview
                                                    Obx(() {
                                                      if (depositCreateController.isUploadingDesktop.value) {
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

                                                      if (depositCreateController.selectedImagesDesktop.isEmpty) {
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
                                                            children: depositCreateController.selectedImagesDesktop.map((image) {
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
                                                                                    image: image.path.startsWith('http') || kIsWeb
                                                                                        ? NetworkImage(image.path)
                                                                                        : FileImage(File(image.path)) as ImageProvider,
                                                                                    fit: BoxFit.contain,
                                                                                  ),
                                                                                ),
                                                                                height:isMobile ? Get.height * 0.6 :  Get.height * 0.8,
                                                                                width:isMobile ? Get.width * 0.8 : Get.width * 0.4,
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
                                                                        depositCreateController.selectedImagesDesktop.remove(image);
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
                                                            Size(Get.width *
                                                                .77, 40)),
                                                        padding: WidgetStatePropertyAll(
                                                            EdgeInsets
                                                                .symmetric(
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
                                                      if (formKey.currentState!.validate()){
                                                        await depositCreateController.uploadImagesDesktop( "image", "Deposit");
                                                      }
                                                    },
                                                    child: depositCreateController
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
                              child:
                              depositCreateController.isLoadingBalance.value ==
                                  false ?
                              Center(child: CircularProgressIndicator(),)
                                  :
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/svg/camera.svg',
                                      height: 24,
                                      colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                                    ),
                                    tooltip: 'گرفتن اسکرین شات',
                                    onPressed: () => depositCreateController.captureBalanceScreenshot(context, _balanceKey),
                                  ),
                                  RepaintBoundary(
                                      key: _balanceKey,
                                      child: BalanceWidget(
                                        title: "${depositCreateController.accountController.text.length > 35
                                            ? '${depositCreateController.accountController.text.substring(0, 35)}...'
                                            : depositCreateController.accountController.text}${Jalali.now().year}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}",
                                        listBalance: depositCreateController
                                            .balanceList,
                                        size: 400,),
                                    ),

                                ],
                              ),
                            ),
                        ],
                      )
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
        ) : SizedBox.shrink(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
