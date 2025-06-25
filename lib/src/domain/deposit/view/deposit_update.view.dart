import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit_create.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/deposit_update.controller.dart';

class DepositUpdateView extends StatefulWidget {
  const DepositUpdateView({super.key});

  @override
  State<DepositUpdateView> createState() => _DepositUpdateViewState();
}

class _DepositUpdateViewState extends State<DepositUpdateView> {

  final DepositUpdateController depositUpdateController = Get.find<DepositUpdateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
    return Obx(() {
      return Scaffold(
        appBar: CustomAppbar1(title: 'ویرایش واریزی',
          onBackTap: () {
            Get.back();
            depositUpdateController.clearList();
          },
        ),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
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
                              depositUpdateController.isLoadingBalance.value ==
                                  false ?
                              Center(child: CircularProgressIndicator(),)
                                  :
                              BalanceWidget(
                                listBalance: depositUpdateController
                                    .balanceList,
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
                                              'ویرایش واریزی',
                                              style: AppTextStyle
                                                  .smallTitleText,
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
                                            //key: withdrawCreateController.formKey,
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
                                                      controller: depositUpdateController
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
                                                    depositUpdateController
                                                        .bankAccountList.map((
                                                        bankAccount) {
                                                      return DropdownMenuItem(
                                                          value: bankAccount,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${bankAccount
                                                                    .bank
                                                                    ?.name}" ??
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
                                                    value: depositUpdateController
                                                        .selectedBankAccount
                                                        .value,
                                                    onChanged: (newValue) {
                                                      if (newValue != null) {
                                                        depositUpdateController
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
                                                    depositUpdateController
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
                                                    value: depositUpdateController
                                                        .bankList.isEmpty
                                                        ? null
                                                        : depositUpdateController
                                                        .selectedIndex,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        depositUpdateController
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
                                                    controller: depositUpdateController
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
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  TextFormField(
                                                    controller: depositUpdateController
                                                        .amountController,
                                                    style: AppTextStyle
                                                        .labelText,
                                                    keyboardType: TextInputType
                                                        .number,
                                                    onChanged: (value) {
                                                      // حذف کاماهای قبلی و فرمت جدید
                                                      String cleanedValue = value
                                                          .replaceAll(',', '');
                                                      if (cleanedValue
                                                          .isNotEmpty) {
                                                        depositUpdateController
                                                            .amountController
                                                            .text =
                                                            cleanedValue
                                                                .toPersianDigit()
                                                                .seRagham();
                                                        depositUpdateController
                                                            .amountController
                                                            .selection =
                                                            TextSelection
                                                                .collapsed(
                                                                offset: depositUpdateController
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
                                                    controller: depositUpdateController.trackingNumberController,
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
                                                    controller: depositUpdateController
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
                                                    controller: depositUpdateController
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
                                                    controller: depositUpdateController
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
                                                      controller: depositUpdateController
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
                                                          depositUpdateController
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

                                                SizedBox(
                                                  width: Get.width * 0.7,
                                                  height: 100,
                                                  child: Row(
                                                    children: depositUpdateController.imageList.map((e)=>
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
                                                                depositUpdateController.deleteImage(e);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                    ).toList(),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Obx(() {
                                                      if (depositUpdateController
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
                                                            children: depositUpdateController.selectedImagesDesktop.map((e){
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
                                                                      depositUpdateController.selectedImagesDesktop.remove(e);
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
                                                          depositUpdateController.pickImageDesktop(),
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
                                                // دکمه ویرایش درخواست
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
                                                      await depositUpdateController.uploadImagesDesktopUpdate( "image", "Deposit");
                                                    },
                                                    child: depositUpdateController
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
                              depositUpdateController.isLoadingBalance.value ==
                                  false ?
                              Center(child: CircularProgressIndicator(),)
                                  :
                              BalanceWidget(
                                listBalance: depositUpdateController
                                    .balanceList,
                                size: 400,),
                            ),
                        ],
                      )
                  ),
                )
            ),
          ],
        ),
      );
    });
  }
}
