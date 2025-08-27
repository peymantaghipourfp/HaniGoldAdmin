import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_create.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../users/widgets/balance.widget.dart';

class WithdrawCreateView extends StatefulWidget {
  WithdrawCreateView({super.key});

  @override
  State<WithdrawCreateView> createState() => _WithdrawCreateState();
}

class _WithdrawCreateState extends State<WithdrawCreateView> {
  final formKey = GlobalKey<FormState>();
  WithdrawCreateController withdrawCreateController = Get.find<
      WithdrawCreateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
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
                child: SingleChildScrollView(
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
                        if(isMobile)
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child:
                            withdrawCreateController.isLoadingBalance.value==false ?
                            Center(child: CircularProgressIndicator(),)
                                :
                            BalanceWidget(
                              listBalance: withdrawCreateController.balanceList,
                              size: 400,),
                          ),
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
                                                    right: isDesktop ? 50 : 135,
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
                                              Container(
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
                                                  /*onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      withdrawCreateController
                                                          .resetAccountSearch();
                                                    }
                                                  },*/
                                                  onMenuStateChange: withdrawCreateController.onDropdownMenuStateChange,
                                                  backgroundColor: AppColor
                                                      .textFieldColor,
                                                  borderRadius: 7,
                                                  borderColor: AppColor
                                                      .secondaryColor,
                                                  hideUnderline: true,
                                                ),
                                              ),
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
                                                  withdrawCreateController.bankList.map((bank) {
                                                    return DropdownMenuItem(
                                                        value: bank.id
                                                            .toString(),
                                                        child: Row(
                                                          children: [
                                                            bank.icon != null ?
                                                            Image.network(
                                                              '${BaseUrl
                                                                  .baseUrl}Attachment/downloadResource?fileName=${bank
                                                                  .icon}',
                                                              width: 22,
                                                              height: 22,)
                                                                : SvgPicture.asset('assets/svg/bank.svg', width: 22, height: 22,),
                                                            SizedBox(
                                                              width: 10,),
                                                            Text(
                                                              bank.name ?? "",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                  value: withdrawCreateController
                                                      .selectedIndex,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      withdrawCreateController
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
                                                        .cardNumberController,
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
                                              Row(
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
                                                    if (formKey.currentState!.validate()) {
                                                    /*if(withdrawCreateController.selectedAccount.value?.id!=null &&
                                                        withdrawCreateController.selectedBank.value!=null){*/
                                                      if(withdrawCreateController.selectedAccount.value!=null || withdrawCreateController.cardNumberController.text.isNotEmpty ||
                                                          withdrawCreateController.numberController.text.isNotEmpty ||
                                                          withdrawCreateController.shebaController.text.isNotEmpty){
                                                        await withdrawCreateController.uploadImagesDesktop( "image", "WithdrawRequest");
                                                      }
                                                    //}
                                                    }
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
                            child:
                            withdrawCreateController.isLoadingBalance.value==false ?
                            Center(child: CircularProgressIndicator(),)
                                :
                            BalanceWidget(
                              listBalance: withdrawCreateController.balanceList,
                              size: 400,),
                          ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(const ChatDialog());
          },
          backgroundColor: AppColor.primaryColor,
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
