import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_update_receive.controller.dart';
import 'package:hanigold_admin/src/widget/background_image.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/inventory_detail_insert_receive.controller.dart';

class InventoryDetailInsertReceiveView extends StatefulWidget {
  const InventoryDetailInsertReceiveView({super.key});

  @override
  State<InventoryDetailInsertReceiveView> createState() =>
      _InventoryDetailInsertReceiveViewState();
}

class _InventoryDetailInsertReceiveViewState
    extends State<InventoryDetailInsertReceiveView>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  InventoryDetailInsertReceiveController inventoryDetailInsertReceiveController = Get
      .find<InventoryDetailInsertReceiveController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
    return Obx(() {
      return Scaffold(
        appBar:
        CustomAppbar1(title: 'ایجاد دریافتی جدید', onBackTap: () => Get.back(),),
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
                          inventoryDetailInsertReceiveController.balanceList.isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryDetailInsertReceiveController
                                .balanceList,
                            size: 400,),
                        ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
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
                                          'دریافتی جدید',
                                          style: AppTextStyle.smallTitleText,
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
                                                  inventoryDetailInsertReceiveController
                                                      .walletAccountList.map((
                                                      wallet) {
                                                    return DropdownMenuItem(
                                                        value: wallet,
                                                        child: Row(
                                                          children: [
                                                            Text("${wallet.item
                                                                ?.name}" ?? "",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                  value: inventoryDetailInsertReceiveController
                                                      .selectedWalletAccount
                                                      .value,
                                                  onChanged: (newValue) {
                                                    if (newValue != null) {
                                                      inventoryDetailInsertReceiveController
                                                          .changeSelectedWalletAccount(
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
                                              ),
                                              inventoryDetailInsertReceiveController.selectedWalletAccount.value?.item?.itemUnit?.id==2 ?
                                              // آزمایشگاه
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        searchController: inventoryDetailInsertReceiveController
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
                                                            controller: inventoryDetailInsertReceiveController
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
                                                      value: inventoryDetailInsertReceiveController
                                                          .selectedLaboratory.value,
                                                      showSearchBox: true,
                                                      items: [
                                                        'انتخاب کنید',
                                                        ...inventoryDetailInsertReceiveController
                                                            .searchedLaboratories
                                                            .map((laboratory) =>
                                                        laboratory.name ?? "")
                                                      ].toList(),
                                                      selectedValue: inventoryDetailInsertReceiveController
                                                          .selectedLaboratory.value
                                                          ?.name,
                                                      onChanged: (
                                                          String? newValue) {
                                                        if (newValue ==
                                                            'انتخاب کنید') {
                                                          inventoryDetailInsertReceiveController
                                                              .changeSelectedLaboratory(
                                                              null);
                                                        } else {
                                                          var selectedLaboratory = inventoryDetailInsertReceiveController
                                                              .searchedLaboratories
                                                              .firstWhere((
                                                              laboratory) =>
                                                          laboratory.name ==
                                                              newValue);
                                                          inventoryDetailInsertReceiveController
                                                              .changeSelectedLaboratory(
                                                              selectedLaboratory);
                                                        }
                                                      },
                                                      onMenuStateChange: (isOpen) {
                                                        if (!isOpen) {
                                                          inventoryDetailInsertReceiveController
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
                                                    controller: inventoryDetailInsertReceiveController
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

                                              inventoryDetailInsertReceiveController.selectedWalletAccount.value?.item?.itemUnit?.id==2 ?
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
                                                        controller: inventoryDetailInsertReceiveController
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

                                              inventoryDetailInsertReceiveController.selectedWalletAccount.value?.item?.itemUnit?.id==2 ?
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
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryDetailInsertReceiveController
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

                                              inventoryDetailInsertReceiveController.selectedWalletAccount.value?.item?.itemUnit?.id==2 ?
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
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryDetailInsertReceiveController
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
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextFormField(
                                                  controller: inventoryDetailInsertReceiveController
                                                      .receiptNumberController,
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
                                                    controller: inventoryDetailInsertReceiveController
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
                                                        inventoryDetailInsertReceiveController.dateController.text =
                                                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${
                                                            pickedDate.day.toString().padLeft(2, '0')} ${
                                                            date.hour.toString().padLeft(2, '0')}:${
                                                            date.minute.toString().padLeft(2, '0')}:${
                                                            date.second.toString().padLeft(2, '0')}";
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
                                                  controller: inventoryDetailInsertReceiveController
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Obx(() {
                                                    if (inventoryDetailInsertReceiveController
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
                                                          children: inventoryDetailInsertReceiveController.selectedImagesDesktop.map((e){
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
                                                                    inventoryDetailInsertReceiveController.selectedImagesDesktop.remove(e);
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
                                                        inventoryDetailInsertReceiveController.pickImageDesktop(),
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
                                                      await inventoryDetailInsertReceiveController.uploadImagesDesktop( "image", "InventoryDetail");
                                                    }
                                                  },
                                                  child: inventoryDetailInsertReceiveController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'درج جدید',
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
                          inventoryDetailInsertReceiveController.balanceList.isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryDetailInsertReceiveController
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
      );
    });
  }
}
