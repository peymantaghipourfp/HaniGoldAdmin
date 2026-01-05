import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_update_receive.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/pager_widget1.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/inventory_detail_insert_payment.controller.dart';
import '../controller/inventory_detail_insert_receive.controller.dart';
import '../controller/inventory_update_payment.controller.dart';

class InventoryDetailUpdatePaymentView extends StatefulWidget {
  const InventoryDetailUpdatePaymentView({super.key});

  @override
  State<InventoryDetailUpdatePaymentView> createState() =>
      _InventoryDetailUpdatePaymentViewState();
}

class _InventoryDetailUpdatePaymentViewState
    extends State<InventoryDetailUpdatePaymentView>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final ScrollController _forPaymentScrollController = ScrollController();
  InventoryDetailUpdatePaymentController inventoryDetailUpdatePaymentController = Get
      .find<InventoryDetailUpdatePaymentController>();

  void _scrollToMatchingItem() {
    // Find the index of the matching item
    final visibleList = inventoryDetailUpdatePaymentController.forPaymentList;
    final matchingIndex = visibleList
        .indexWhere((item) => item.id == inventoryDetailUpdatePaymentController.inputItemId.value);

    if (matchingIndex != -1 && _forPaymentScrollController.hasClients) {
      // Calculate the scroll position (assuming each item is roughly 120 pixels tall)
      final scrollPosition = matchingIndex * 120.0;
      _forPaymentScrollController.animateTo(
        scrollPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Also automatically select the matching item
      final matchingItem = visibleList[matchingIndex];
      if (matchingItem.id != null) {
        inventoryDetailUpdatePaymentController.selectedForPaymentId.add(matchingItem.id!);
      }
    }
  }

  @override
  void dispose() {
    _forPaymentScrollController.dispose();
    super.dispose();
  }

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
        CustomAppbar1(title: 'ویرایش پرداختی', onBackTap: () => Get.back(),),
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
                          inventoryDetailUpdatePaymentController.balanceList
                              .isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryDetailUpdatePaymentController
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
                                          'ویرایش پرداختی',
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
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: Container(
                                                  height: 50,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:
                                                  Obx(() => TextFormField(
                                                    readOnly: true,
                                                    controller: TextEditingController(
                                                      text: inventoryDetailUpdatePaymentController.selectedWalletAccount.value != null
                                                          ? "${inventoryDetailUpdatePaymentController.selectedWalletAccount.value!.item?.name ?? ''} - ${inventoryDetailUpdatePaymentController.selectedWalletAccount.value!.account?.name ?? ''}"
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
                                              ),
                                              // لیست دریافتی ها
                                              inventoryDetailUpdatePaymentController
                                                  .selectedWalletAccount.value
                                                  ?.item?.id == 1 ?
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    fixedSize: WidgetStatePropertyAll(
                                                      Size(
                                                          isDesktop
                                                              ? Get.width * 0.10
                                                              : Get.width * 0.3,
                                                          isDesktop ? 40 : 30
                                                      ),
                                                    ),
                                                    padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(
                                                          horizontal: isDesktop
                                                              ? 12
                                                              : 5
                                                      ),),
                                                    elevation: WidgetStatePropertyAll(
                                                        5),
                                                    backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        AppColor.buttonColor),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                10)))),
                                                onPressed: () async {
                                                  await inventoryDetailUpdatePaymentController.getForPaymentListPager();
                                                  showForPaymentModal();
                                                  // Scroll to matching item after a short delay to ensure the list is rendered
                                                  Future.delayed(Duration(milliseconds: 300), () {
                                                    _scrollToMatchingItem();
                                                  });
                                                  print(
                                                      'idIttttem ${inventoryDetailUpdatePaymentController
                                                          .selectedWalletAccount
                                                          .value?.item?.id}');
                                                  print(
                                                      'idIttttemUnnnnitId ${inventoryDetailUpdatePaymentController
                                                          .selectedWalletAccount
                                                          .value?.item?.itemUnit
                                                          ?.id}');
                                                },
                                                child: inventoryDetailUpdatePaymentController
                                                    .isLoading.value
                                                    ?
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<
                                                      Color>(
                                                      AppColor.textColor),
                                                ) :
                                                Text(
                                                  'لیست دریافتی ها',
                                                  style: AppTextStyle.bodyText,
                                                ),
                                              )
                                                  : SizedBox.shrink(),
                                              inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==1 ?
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
                                                        searchController: inventoryDetailUpdatePaymentController
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
                                                            controller: inventoryDetailUpdatePaymentController
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
                                                      value: inventoryDetailUpdatePaymentController
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
                                                        ...inventoryDetailUpdatePaymentController
                                                            .searchedLaboratories
                                                            .map((laboratory) =>
                                                        laboratory.name ?? "")
                                                      ].toList(),
                                                      selectedValue: inventoryDetailUpdatePaymentController
                                                          .selectedLaboratory.value
                                                          ?.name,
                                                      onChanged: (
                                                          String? newValue) {
                                                        if (newValue ==
                                                            'انتخاب کنید') {
                                                          inventoryDetailUpdatePaymentController
                                                              .changeSelectedLaboratory(
                                                              null);
                                                        } else {
                                                          var selectedLaboratory = inventoryDetailUpdatePaymentController
                                                              .searchedLaboratories
                                                              .firstWhere((
                                                              laboratory) =>
                                                          laboratory.name ==
                                                              newValue);
                                                          inventoryDetailUpdatePaymentController
                                                              .changeSelectedLaboratory(
                                                              selectedLaboratory);
                                                        }
                                                      },
                                                      onMenuStateChange: (isOpen) {
                                                        if (!isOpen) {
                                                          inventoryDetailUpdatePaymentController
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
                                              inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==1 ?
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
                                                      controller: inventoryDetailUpdatePaymentController
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
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'مقدار',
                                                      style: AppTextStyle
                                                          .labelText,
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
                                                        controller: inventoryDetailUpdatePaymentController
                                                            .quantityController,
                                                        style: AppTextStyle
                                                            .labelText,
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(
                                                              RegExp(
                                                                  r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                          TextInputFormatter
                                                              .withFunction((
                                                              oldValue,
                                                              newValue) {
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
                                              ),
                                              // تعداد
                                              SizedBox(height: 3),
                                              inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id == 10 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id == 13 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id == 15 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id == 16
                                                  ?
                                              Row(
                                                children: [
                                                  Text(
                                                    ' تعداد: ',
                                                    style: AppTextStyle
                                                        .labelText.copyWith(color: AppColor.textColor.withOpacity(0.5)),),
                                                  Text(inventoryDetailUpdatePaymentController.itemCountTemp.value,
                                                    style: AppTextStyle.bodyText
                                                        .copyWith(color: AppColor
                                                        .primaryColor.withOpacity(0.8)),)
                                                ],
                                              ) :
                                              SizedBox(),
                                              inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==1 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==16 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==14 ?
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
                                                          inventoryDetailUpdatePaymentController.updateW750();
                                                        },
                                                        /*readOnly: inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                                                            inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                                                            inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                                                            inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==16 ? true :false ,*/
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'لطفا عیار را وارد کنید';
                                                          }
                                                          return null;
                                                        },
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryDetailUpdatePaymentController
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
                                              inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==1 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==16 ||
                                                  inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==14 ?
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
                                                        readOnly: inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                                                            inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                                                            inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                                                            inventoryDetailUpdatePaymentController.selectedWalletAccount.value?.item?.id==16 ? true :false ,
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryDetailUpdatePaymentController
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
                                                    controller: inventoryDetailUpdatePaymentController
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
                                                        inventoryDetailUpdatePaymentController
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
                                                  controller: inventoryDetailUpdatePaymentController
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
                                              SizedBox(
                                                width: Get.width * 0.7,
                                                height: 100,
                                                child: Row(
                                                  children: inventoryDetailUpdatePaymentController.imageList.map((e)=>
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
                                                              inventoryDetailUpdatePaymentController.deleteImage(e);
                                                            },
                                                          )
                                                        ],
                                                      ),).toList(),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Obx(() {
                                                    if (inventoryDetailUpdatePaymentController
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
                                                          children: inventoryDetailUpdatePaymentController.selectedImagesDesktop.map((e){
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
                                                                    inventoryDetailUpdatePaymentController.selectedImagesDesktop.remove(e);
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
                                                        inventoryDetailUpdatePaymentController.pickImageDesktop(),
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
                                                      if(inventoryDetailUpdatePaymentController.selectedWalletAccount.value!=null){
                                                        inventoryDetailUpdatePaymentController.uploadImagesDesktopUpdate( "image", "InventoryDetail");
                                                      }
                                                    }
                                                  },
                                                  child: inventoryDetailUpdatePaymentController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'ویرایش پرداختی',
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
                          inventoryDetailUpdatePaymentController.balanceList
                              .isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryDetailUpdatePaymentController
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

  void showForPaymentModal() {
    Get.dialog(
      SingleChildScrollView(
        child: Dialog(
          backgroundColor: AppColor.backGroundColor,
          insetPadding: EdgeInsets.all(20),
          child: Builder(builder: (context) {
            final isMobile = ResponsiveBreakpoints.of(context).isMobile;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? Get.width * 0.95 : 600,
                maxHeight: isMobile ? Get.height * 0.9 : Get.height * 0.8,
              ),
              child: Column(
                children: [
                  buildForPaymentDetail(),
                  Obx(() {
                    final isMobileLocal = ResponsiveBreakpoints.of(context).isMobile;
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          inventoryDetailUpdatePaymentController.paginated.value != null
                              ? Container(
                              height: isMobileLocal ? 56 : 70,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isMobileLocal ? 8 : 70, vertical: isMobileLocal ? 2 : 10),
                              padding: EdgeInsets.symmetric(horizontal: isMobileLocal ? 8 : 20,),
                              color: AppColor.appBarColor.withOpacity(0.5),
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                child: PagerWidget1(
                                  countPage: inventoryDetailUpdatePaymentController
                                      .paginated.value?.totalCount ?? 0,
                                  callBack: (int index) {
                                    inventoryDetailUpdatePaymentController.isChangePage(
                                        index);
                                  },
                                ),
                              ))
                              : SizedBox(),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildForPaymentDetail() {
    return Obx(() {
      return
        inventoryDetailUpdatePaymentController.isLoading.value ?
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<
              Color>(
              AppColor.textColor),
        ) :
        // لیست ForPayment مربوط به هر ولت
        SizedBox(
          height: ResponsiveBreakpoints.of(context).isMobile ? Get.height * 0.8 : Get.height * 0.65, // تعیین ارتفاع ثابت
          width: ResponsiveBreakpoints.of(context).isMobile ? Get.width * 0.95 : Get.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('لیست دریافتی ها', style: AppTextStyle.smallTitleText),
                      IconButton(
                          onPressed: Get.back,
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
                // Show which item is being edited
                if (inventoryDetailUpdatePaymentController.inputItemId.value > 0)
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
                        Icon(
                          Icons.edit,
                          color: AppColor.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'در حال ویرایش آیتم با شناسه: ${inventoryDetailUpdatePaymentController.inputItemId.value}',
                            style: AppTextStyle.labelText.copyWith(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 41,
                        child: TextFormField(
                          controller: inventoryDetailUpdatePaymentController
                              .searchLaboratoryController,
                          style: AppTextStyle.labelText,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              await inventoryDetailUpdatePaymentController
                                  .searchLaboratory(value);
                              showSearchResults(context);
                            } else {
                              inventoryDetailUpdatePaymentController
                                  .clearSearch();
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                            hintText: "جستجو ... ",
                            hintStyle: AppTextStyle.labelText,
                            prefixIcon: IconButton(
                                onPressed: () async {
                                  if (inventoryDetailUpdatePaymentController
                                      .searchLaboratoryController
                                      .text.isNotEmpty) {
                                    await inventoryDetailUpdatePaymentController
                                        .searchLaboratory(
                                        inventoryDetailUpdatePaymentController
                                            .searchLaboratoryController.text
                                    );
                                    showSearchResults(context);
                                  } else {
                                    inventoryDetailUpdatePaymentController
                                        .clearSearch();
                                  }
                                },
                                icon: Icon(
                                  Icons.search, color: AppColor.textColor,
                                  size: 30,)
                            ),
                            suffixIcon: inventoryDetailUpdatePaymentController
                                .selectedLaboratoryId.value > 0
                                ? IconButton(
                              onPressed: inventoryDetailUpdatePaymentController
                                  .clearSearch,
                              icon: Icon(
                                  Icons.close, color: AppColor.textColor),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                inventoryDetailUpdatePaymentController.forPaymentList.isNotEmpty ?
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:ResponsiveBreakpoints.of(context).isMobile ? Get.height * 0.6 : Get.height * 0.65,
                  ),
                  child: ListView.builder(
                    controller: _forPaymentScrollController,
                    shrinkWrap: true,
                    itemCount: inventoryDetailUpdatePaymentController
                        .forPaymentList.length,
                    itemBuilder: (context,
                        index) {
                      final forPayment = inventoryDetailUpdatePaymentController
                          .forPaymentList[index];
                      return ListTile(
                        onTap: () {
                          Get.back();
                          if (forPayment.id != null) {
                            inventoryDetailUpdatePaymentController
                                .selectedForPaymentId.add(forPayment.id!);
                          }
                          inventoryDetailUpdatePaymentController.selectInputItem(forPayment);
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Card(
                          color: (forPayment.id != null &&
                              forPayment.id == inventoryDetailUpdatePaymentController.inputItemId.value)
                              ? AppColor.primaryColor.withOpacity(0.1)
                              : inventoryDetailUpdatePaymentController
                              .selectedForPaymentId.contains(forPayment.id)
                              ? AppColor.textFieldColor
                              : AppColor.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: (forPayment.id != null &&
                                  forPayment.id == inventoryDetailUpdatePaymentController.inputItemId.value)
                                  ? AppColor.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets
                                .only(
                                top: 8,
                                left: 12,
                                right: 12,
                                bottom: 8),
                            child: Column(
                              children: [
                                // آزمایشگاه
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' آزمایشگاه: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            forPayment.laboratory?.name ?? '',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    if (forPayment.id != null &&
                                        forPayment.id == inventoryDetailUpdatePaymentController.inputItemId.value)
                                      Container(
                                        margin: EdgeInsets.only(right: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'در حال ویرایش',
                                          style: AppTextStyle.labelText.copyWith(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    Row(
                                      children: [
                                        Text(
                                            ' شناسه دریافتی: ',
                                            style: AppTextStyle
                                                .labelText.copyWith(color: AppColor.dividerColor,fontSize: 12)),
                                        Text(
                                            forPayment.id.toString() ?? '',
                                            style: AppTextStyle
                                                .bodyText.copyWith(color: AppColor.dividerColor,fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Divider(
                                  height: 1, color: AppColor.dividerColor,),
                                SizedBox(height: 5,),
                                // عیار-وزن 750
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' عیار: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.carat ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن 750: ',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                        Text(
                                            '${forPayment.weight750 ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                // باقیمانده
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' باقیمانده: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.quantityRemainded ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,),
                              ],
                            ),
                          ),
                        ),

                      );
                    },
                  ),
                ) :
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
    });
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(backgroundColor: AppColor.backGroundColor,
            title: Text('انتخاب کنید', style: AppTextStyle.smallTitleText,),
            content: SizedBox(
              width: Get.width * 0.5,
              height: Get.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inventoryDetailUpdatePaymentController
                    .searchedLaboratories.length,
                itemBuilder: (context, index) {
                  final laboratory = inventoryDetailUpdatePaymentController
                      .searchedLaboratories[index];
                  return ListTile(
                      title: Text(laboratory.name ?? '',
                        style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                      onTap: () {
                        inventoryDetailUpdatePaymentController.selectLaboratory(
                            laboratory);
                      }
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('بستن', style: AppTextStyle.bodyText,),
              ),
            ],
          ),
    );
  }
}
