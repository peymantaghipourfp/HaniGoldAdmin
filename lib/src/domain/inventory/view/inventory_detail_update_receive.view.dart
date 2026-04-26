import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_update_receive.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../../users/widgets/balance.widget.dart';

class InventoryDetailUpdateReceiveView extends StatefulWidget {
  const InventoryDetailUpdateReceiveView({super.key});

  @override
  State<InventoryDetailUpdateReceiveView> createState() =>
      _InventoryDetailUpdateReceiveViewState();
}

class _InventoryDetailUpdateReceiveViewState
    extends State<InventoryDetailUpdateReceiveView>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  InventoryUpdateReceiveController inventoryUpdateReceiveController = Get.find<
      InventoryUpdateReceiveController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    return Obx(() {
      return Scaffold(
        appBar:
        CustomAppbar1(title: 'ویرایش دریافتی', onBackTap: () => Get.back(),),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ResponsiveRowColumn(
                    layout: isDesktop
                        ? ResponsiveRowColumnType.ROW
                        : ResponsiveRowColumnType.COLUMN,
                    columnSpacing: 16,
                    rowSpacing: 16,
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isMobile)
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child:
                          inventoryUpdateReceiveController.balanceList
                              .isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryUpdateReceiveController
                                .balanceList,
                            size: 400,),
                        ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 2 : isTablet ? 16 : 40,
                              vertical: isMobile ? 12 : isTablet ? 20 : 30
                          ),
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
                            width: double.infinity,
                            height: isDesktop ? Get.height : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                                          'ویرایش دریافتی',
                                          style: AppTextStyle.smallTitleText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ResponsiveRowColumnItem(
                                  child: isDesktop
                                      ? SizedBox(
                                    width: 480,
                                    child: Divider(
                                      height: 1,
                                      color: AppColor.appBarColor,
                                    ),
                                  )
                                      : Divider(
                                    height: 1,
                                    color: AppColor.appBarColor,
                                  ),
                                ),
                                ResponsiveRowColumnItem(
                                    rowFlex: isDesktop ? 1 : null,
                                    child: SingleChildScrollView(
                                      physics: isDesktop ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                                      child: Container(
                                        constraints: isDesktop ? BoxConstraints(
                                            maxWidth: 500) : BoxConstraints(
                                            maxWidth: 400),
                                        padding: isDesktop
                                            ? const EdgeInsets.symmetric(
                                            horizontal: 40)
                                            : const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child:
                                        Form(
                                          key: formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              // ولت اکانت
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'حساب wallet',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // ولت اکانت
                                                Container(
                                                  //height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  Obx(() => TextFormField(
                                                    readOnly: true,
                                                    controller: TextEditingController(
                                                      text: inventoryUpdateReceiveController.selectedWalletAccount.value != null
                                                          ? "${inventoryUpdateReceiveController.selectedWalletAccount.value!.item?.name ?? ''} - ${inventoryUpdateReceiveController.selectedWalletAccount.value!.account?.name ?? ''}"
                                                          : 'انتخاب کنید',
                                                    ),
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
                                                      suffixIcon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: AppColor.textColor,
                                                      ),
                                                    ),
                                                  )),
                                                ),
                                              inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==1 ?
                                              // آزمایشگاه
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'آزمایشگاه',
                                                      style: AppTextStyle.labelText
                                                          .copyWith(
                                                          fontSize: isDesktop
                                                              ? 12
                                                              : 10),
                                                    ),
                                                  ),
                                                  // آزمایشگاه
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    CustomDropdownWidget(

                                                      dropdownSearchData: DropdownSearchData<
                                                          String>(
                                                        searchController: inventoryUpdateReceiveController
                                                            .searchLaboratoryController,
                                                        searchInnerWidgetHeight: 50,
                                                        searchInnerWidget: Container(
                                                          height: 50,
                                                          padding: const EdgeInsets
                                                              .only(
                                                            top: 8,
                                                            right: 15,
                                                            left: 15,
                                                          ),
                                                          child: TextFormField(
                                                            style: AppTextStyle
                                                                .bodyText,
                                                            controller: inventoryUpdateReceiveController
                                                                .searchLaboratoryController,
                                                            decoration: InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 10,
                                                                vertical: 8,
                                                              ),
                                                              hintText: 'جستجوی آزمایشگاه...',
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
                                                      value: inventoryUpdateReceiveController
                                                          .selectedLaboratory.value,
                                                      /*validator: (value) {
                                                                                        if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                                                                          return 'کاربر را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },*/
                                                      showSearchBox: true,
                                                      items: [
                                                        'انتخاب کنید',
                                                        ...inventoryUpdateReceiveController
                                                            .searchedLaboratories
                                                            .map((laboratory) =>
                                                        laboratory.name ?? "")
                                                      ].toList(),
                                                      selectedValue: inventoryUpdateReceiveController
                                                          .selectedLaboratory.value
                                                          ?.name,
                                                      onChanged: (
                                                          String? newValue) {
                                                        if (newValue ==
                                                            'انتخاب کنید') {
                                                          inventoryUpdateReceiveController
                                                              .changeSelectedLaboratory(
                                                              null);
                                                        } else {
                                                          var selectedLaboratory = inventoryUpdateReceiveController
                                                              .searchedLaboratories
                                                              .firstWhere((
                                                              laboratory) =>
                                                          laboratory.name ==
                                                              newValue);
                                                          inventoryUpdateReceiveController
                                                              .changeSelectedLaboratory(
                                                              selectedLaboratory);
                                                        }
                                                      },
                                                      onMenuStateChange: (isOpen) {
                                                        if (!isOpen) {
                                                          inventoryUpdateReceiveController
                                                              .resetLaboratorySearch();
                                                        }
                                                      },
                                                      backgroundColor: AppColor
                                                          .textFieldColor,
                                                      borderRadius: 7,
                                                      borderColor: AppColor
                                                          .secondaryColor,
                                                      hideUnderline: true,
                                                    ),
                                                  ),
                                                ],
                                              ):
                                              SizedBox.shrink(),

                                              inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==1 ?
                                              // شماره قبض
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // شماره قبض
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'شماره قبض',
                                                      style: AppTextStyle.labelText
                                                          .copyWith(
                                                          fontSize: isDesktop
                                                              ? 12
                                                              : 10),
                                                    ),
                                                  ),
                                                  // شماره قبض
                                                  Container(
                                                    //height: 40,
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'لطفا شماره قبض را وارد کنید';
                                                        }
                                                        return null;
                                                      },
                                                      controller: inventoryUpdateReceiveController
                                                          .receiptNumberController,
                                                      style: AppTextStyle.labelText,
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
                                                ],
                                              ):
                                              SizedBox.shrink(),
                                              // مقدار
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'مقدار',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // مقدار
                                              Container(
                                                //height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                IntrinsicHeight(
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'لطفا مقدار را وارد کنید';
                                                      }
                                                      return null;
                                                    },
                                                    autovalidateMode: AutovalidateMode
                                                        .onUserInteraction,
                                                    controller: inventoryUpdateReceiveController
                                                        .quantityController,
                                                    style: AppTextStyle
                                                        .labelText,
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
                                                      isDense: true,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                      errorMaxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // تعداد
                                              SizedBox(height: 3),
                                              inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id == 10 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id == 13 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id == 15 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id == 16
                                                  ?
                                              Row(
                                                children: [
                                                  Text(
                                                    ' تعداد: ',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(color: AppColor.textColor.withOpacity(0.5)),),
                                                  Text(inventoryUpdateReceiveController.itemCountTemp.value,
                                                    style: AppTextStyle.bodyText
                                                        .copyWith(color: AppColor
                                                        .primaryColor.withOpacity(0.8)),)
                                                ],
                                              ) :
                                              SizedBox(),

                                              inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==1 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==16 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==14 ?
                                              // عیار
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'عیار',
                                                      style: AppTextStyle.labelText
                                                          .copyWith(
                                                          fontSize: isDesktop
                                                              ? 12
                                                              : 10),
                                                    ),
                                                  ),
                                                  // عیار
                                                  Container(
                                                    //height: 50,
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    IntrinsicHeight(
                                                      child: TextFormField(
                                                        onChanged: (value) {
                                                          inventoryUpdateReceiveController.updateW750();
                                                        },
                                                        /*readOnly: inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                                                            inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                                                            inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                                                            inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==16 ? true :false ,*/
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'لطفا عیار را وارد کنید';
                                                          }
                                                          return null;
                                                        },
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryUpdateReceiveController
                                                            .caratController,
                                                        style: AppTextStyle
                                                            .labelText,
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
                                                          isDense: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                          ),
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .textFieldColor,
                                                          errorMaxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ):
                                              SizedBox.shrink(),

                                              inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==1 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==16 ||
                                                  inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==14 ?
                                              // وزن 750
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'وزن 750',
                                                      style: AppTextStyle.labelText
                                                          .copyWith(
                                                          fontSize: isDesktop
                                                              ? 12
                                                              : 10),
                                                    ),
                                                  ),
                                                  // وزن 750
                                                  Container(
                                                    //height: 50,
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    IntrinsicHeight(
                                                      child: TextFormField(
                                                        readOnly: inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                                                            inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                                                            inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                                                            inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==16 ? true :false ,
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryUpdateReceiveController
                                                            .weight750Controller,
                                                        style: AppTextStyle
                                                            .labelText,
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
                                                          isDense: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                          ),
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .textFieldColor,
                                                          errorMaxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ):
                                              SizedBox.shrink(),

                                              inventoryUpdateReceiveController.selectedWalletAccount.value?.item?.id==1 ?
                                              // ناخالصی
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'ناخالصی',
                                                      style: AppTextStyle.labelText
                                                          .copyWith(
                                                          fontSize: isDesktop
                                                              ? 12
                                                              : 10),
                                                    ),
                                                  ),
                                                  // ناخالصی
                                                  Container(
                                                    //height: 50,
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    IntrinsicHeight(
                                                      child: TextFormField(
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryUpdateReceiveController
                                                            .impurityController,
                                                        style: AppTextStyle
                                                            .labelText,
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
                                                          isDense: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                          ),
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .textFieldColor,
                                                          errorMaxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ):
                                              SizedBox.shrink(),

                                              // تاریخ
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'تاریخ سفارش',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
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
                                                    controller: inventoryUpdateReceiveController
                                                        .dateController,
                                                    readOnly: true,
                                                    style: AppTextStyle
                                                        .labelText,
                                                    decoration: InputDecoration(
                                                      suffixIcon: Icon(
                                                          Icons.calendar_month,
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
                                                      if (pickedDate != null) {
                                                        inventoryUpdateReceiveController
                                                            .dateController
                                                            .text =
                                                        "${pickedDate
                                                            .year}/${pickedDate
                                                            .month.toString()
                                                            .padLeft(2,
                                                            '0')}/${pickedDate
                                                            .day.toString()
                                                            .padLeft(
                                                            2, '0')} ${date.hour
                                                            .toString().padLeft(
                                                            2, '0')}:${date
                                                            .minute.toString()
                                                            .padLeft(
                                                            2, '0')}:${date
                                                            .second.toString()
                                                            .padLeft(2, '0')}";
                                                      }
                                                    },
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
                                                TextFormField(
                                                  controller: inventoryUpdateReceiveController
                                                      .descriptionController,
                                                  maxLines: 4,
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
                                              // نمایش عکس های قبلی
                                              Container(
                                                padding: EdgeInsets.only(bottom: 5),
                                                        //width: Get.width * 0.5,
                                                        height: 90,
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Row(
                                                            children: inventoryUpdateReceiveController.imageList.map((e)=>
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
                                                                                    margin: EdgeInsets.all(isMobile ? 20 : 10),
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        border: Border.all(color: AppColor.textColor),
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),
                                                                                          fit: BoxFit.cover,
                                                                                        )
                                                                                    ),
                                                                                    height: isMobile ? Get.height * 0.6 : Get.height * 0.8,
                                                                                    width: isMobile ? Get.width * 0.8 : Get.width * 0.4,
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
                                                                        inventoryUpdateReceiveController.deleteImage(e);
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
                                                          if (isMobile) {
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
                                                                            inventoryUpdateReceiveController
                                                                                .pickImageMobile(ImageSource.gallery);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          leading: Icon(Icons.camera_alt,color: AppColor.textColor,),
                                                                          title: Text('دوربین',style: AppTextStyle.bodyText.copyWith(fontSize: 16,fontWeight: FontWeight.w700),),
                                                                          onTap: () {
                                                                            Get.back();
                                                                            inventoryUpdateReceiveController
                                                                                .pickImageMobile(ImageSource.camera);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            inventoryUpdateReceiveController.pickImageDesktop();
                                                          }
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.all(10),
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
                                                        if (inventoryUpdateReceiveController
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
                                                          //width: isMobile ? Get.width * 0.60 : Get.width * 0.45,
                                                          child:  Row(
                                                              children: inventoryUpdateReceiveController.selectedImagesDesktop.map((e){
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
                                                                                          image:e.path.startsWith('http') || kIsWeb ?
                                                                                          NetworkImage(e.path,)
                                                                                              : FileImage(File(e.path)) as ImageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        )
                                                                                    ),
                                                                                    height: isMobile ? Get.height * 0.6 : Get.height * 0.8,
                                                                                    width: isMobile ? Get.width * 0.8 : Get.width * 0.4,
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
                                                                   /* Container(
                                                                      margin: EdgeInsets.all(isMobile ? 20 : 10),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          border: Border.all(color: AppColor.textColor),
                                                                          image: DecorationImage(
                                                                            image:e!.path.startsWith('http') ?
                                                                            NetworkImage(e.path,)
                                                                                : FileImage(File(e.path)) as ImageProvider,
                                                                            fit: BoxFit.cover,
                                                                          )
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
                                                                        inventoryUpdateReceiveController.selectedImagesDesktop.remove(e);
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
                                              //  دکمه ثبت نهایی
                                              SizedBox(height: 20,),
                                              SizedBox(width: double.infinity,
                                                height: 40,
                                                // دکمه ثبت نهایی
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      fixedSize: WidgetStatePropertyAll(
                                                          Size(Get.width * .77,
                                                              40)),
                                                      padding: WidgetStatePropertyAll(
                                                        EdgeInsets.symmetric(
                                                            horizontal: isDesktop
                                                                ? 20
                                                                : 7
                                                        ),),
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
                                                    if(formKey.currentState!.validate()){
                                                      inventoryUpdateReceiveController.uploadImagesDesktopUpdate( "image", "InventoryDetail");
                                                    }
                                                  },
                                                  child: inventoryUpdateReceiveController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'ویرایش دریافتی',
                                                    style: AppTextStyle
                                                        .bodyText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )


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
                          inventoryUpdateReceiveController.balanceList
                              .isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryUpdateReceiveController
                                .balanceList,
                            size: 400,),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: isMobile ? SizedBox.shrink() : FloatingActionButton(
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
