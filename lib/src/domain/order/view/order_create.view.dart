import 'dart:async';
import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanigold_admin/src/widget/background_image.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/custom_dropdown1.widget.dart';
import '../../account/model/account.model.dart';
import '../../account/widget/account_level_get_one_item.widget.dart';
import '../../accountSalesGroup/widget/account_sales_group_get_one_item.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../product/model/item.model.dart';
import '../../users/widgets/balance.widget.dart';
import '../../users/widgets/user_create_dialog.widget.dart';

class OrderCreateView extends StatefulWidget {
  OrderCreateView({super.key});

  @override
  State<OrderCreateView> createState() => _OrderCreateViewState();
}

class _OrderCreateViewState extends State<OrderCreateView> {
  final formKey = GlobalKey<FormState>();

  OrderCreateController orderCreateController =
  Get.find<OrderCreateController>();

  // For quantity validation
  bool _isValidatingQuantity = false;
  Timer? _limitCheckDebounce;
  bool _isDialogShowing = false;

  /*@override
  void initState() {
    var now = Jalali.now();
    DateTime date=DateTime.now();
    orderCreateController.dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    super.initState();
  }*/

  bool _isPriceDifferent() {
    if (orderCreateController.socketPrice.value.isEmpty || orderCreateController.currentPrice.value.isEmpty) {
      return false;
    }

    String socketPriceClean = orderCreateController.socketPrice.value.replaceAll(',', '').toEnglishDigit();
    String textFieldPriceClean = orderCreateController.currentPrice.value.replaceAll(',', '').toEnglishDigit();

    // برای آیتم‌های گرم، باید قیمت را به مثقال تبدیل کنیم
    if (orderCreateController.selectedItem.value?.itemUnit?.name == 'گرم') {
      double textFieldPriceInMesghal = double.tryParse(textFieldPriceClean) ?? 0;
      double socketPriceInMesghal = double.tryParse(socketPriceClean) ?? 0;
      return textFieldPriceInMesghal != socketPriceInMesghal;
    } else {
      // برای آیتم‌های غیر گرم، مقایسه مستقیم
      return socketPriceClean != textFieldPriceClean;
    }
  }

  Color _getSocketPriceDisplayColor() {
    return _isPriceDifferent() ? Colors.red.withAlpha(25) : Colors.green.withAlpha(25);
  }

  Color _getSocketPriceBorderColor() {
    return _isPriceDifferent() ? Colors.red : Colors.green;
  }

  IconData _getSocketPriceIcon() {
    return _isPriceDifferent() ? Icons.warning : Icons.check_circle;
  }

  String _getSocketPriceValue() {
    return orderCreateController.socketPrice.value;
  }

  String _cleanNumber(String input) {
    return input.replaceAll(',', '').toEnglishDigit();
  }

  double? _priceDiffRatio() {
    final socketText = orderCreateController.socketPrice.value;
    if (socketText.isEmpty) return null;
    final inputText = orderCreateController.priceController.text;
    final socket = double.tryParse(_cleanNumber(socketText)) ?? 0;
    final input = double.tryParse(_cleanNumber(inputText)) ?? 0;
    if (socket <= 0) return null;
    return ((input - socket).abs()) / socket;
  }

  bool _isPriceOverOnePercent() {
    final diffRatio = _priceDiffRatio();
    if (diffRatio == null) return false;
    return diffRatio > 0.1;
  }

  @override
  void dispose() {
    _limitCheckDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(() {
      return Scaffold(
        appBar:CustomAppbar1(
            title: 'ایجاد سفارش جدید', onBackTap: () {
          Get.toNamed('/home');
          orderCreateController.clearList(); }),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:isDesktop ? 40 : 20, vertical: 20),
                  child: ResponsiveRowColumn(
                    layout: isDesktop
                        ? ResponsiveRowColumnType.ROW
                        : ResponsiveRowColumnType.COLUMN,
                    columnSpacing:isDesktop ? 30 : 10,
                    rowSpacing: 20,
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isMobile)
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          /*child:
                          orderCreateController.isLoadingBalance.value==false ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(title: orderCreateController.selectedAccount.value?.name,
                            listBalance: orderCreateController.balanceList,
                            size: 400,),*/
                          child: Column(
                            children: [
                              orderCreateController.isLoadingBalance.value==false ?
                              Center(child: CircularProgressIndicator(),)
                                  :
                              BalanceWidget(title: orderCreateController.selectedAccount.value?.name,
                                listBalance: orderCreateController.balanceList,
                                size: 400,),
                              // Error display widget for mobile
                              Obx(() => orderCreateController.hasError.value
                                  ? Container(
                                margin: EdgeInsets.only(top: 16),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(color: Colors.red.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade600,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orderCreateController.errorTitle.value,
                                            style: AppTextStyle.bodyText.copyWith(
                                              color: Colors.red.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            orderCreateController.errorMessage.value,
                                            style: AppTextStyle.bodyText.copyWith(
                                              color: Colors.red.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => orderCreateController.clearError(),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red.shade600,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : SizedBox.shrink()),
                              const SizedBox(height: 8),
                              Obx(() {
                                return AccountSalesGroupGetOneItemWidget(
                                  data: orderCreateController.selectedAccountSalesGroupItem.value,
                                  width: 400,
                                  title: orderCreateController
                                      .selectedAccount.value?.accountSalesGroup?.name,
                                  isLoading: orderCreateController.isLoadingAccountSalesGroupItem.value,
                                  selectedItemId: orderCreateController.selectedItem.value?.id,
                                  selectedBuySellId: orderCreateController.selectedBuySell.value?.id,
                                  onPriceSelected: (mesghlPrice) {
                                    orderCreateController.setPriceFromSalesGroup(mesghlPrice);
                                  },
                                );
                              }),
                              const SizedBox(height: 8),
                              Obx(() {
                                return AccountLevelGetOneItemWidget(
                                  data: orderCreateController.selectedAccountLevelItem.value,
                                  width: 400,
                                  title: orderCreateController
                                      .selectedAccount.value?.accountLevel?.name,
                                  isLoading: orderCreateController.isLoadingAccountLevelItem.value,
                                );
                              }),
                            ],
                          ),
                        ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          padding: EdgeInsets.symmetric(
                              horizontal:isDesktop ? 40 : 2, vertical: isDesktop ? 20 : 5),
                          /*decoration: BoxDecoration(
                            color: AppColor.backGroundColor1.withOpacity(0.1),
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
                            /*width: Get.width * 0.9,
                            height: Get.height,*/
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
                                          'سفارش جدید',
                                          style: AppTextStyle.smallTitleText,
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/orderList');
                                              orderCreateController.clearList();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(right: isDesktop ? 200 : 45, bottom: 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('لیست سفارشات',
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
                                  child:  Container(
                                      constraints: isDesktop ? BoxConstraints(
                                          maxWidth: 500) : BoxConstraints(
                                          maxWidth: 400),
                                      padding: isDesktop
                                          ? const EdgeInsets.symmetric(horizontal: 40)
                                          : const EdgeInsets.symmetric(horizontal: 24,vertical: 5),
                                      child:
                                      Form(
                                        key: formKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            // خرید/فروش
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 3, top: 10),
                                              child: Text(
                                                'خرید/فروش',
                                                style: AppTextStyle.labelText
                                                    .copyWith(
                                                    fontSize: isDesktop
                                                        ? 12
                                                        : 10),
                                              ),
                                            ),
                                            // خرید/فروش
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child: CustomDropdownWidget(
                                                validator: (value) {
                                                  if (value == 'انتخاب کنید' ||
                                                      value == null ||
                                                      value.isEmpty) {
                                                    return 'نوع سفارش را انتخاب کنید';
                                                  }
                                                  return null;
                                                },
                                                items: [
                                                  'انتخاب کنید',
                                                  ...orderCreateController
                                                      .orderTypeList
                                                      .where((type) =>
                                                  type.id != null)
                                                      .map((type) =>
                                                  type.name ?? '')
                                                ].toList(),
                                                selectedValue: orderCreateController
                                                    .selectedBuySell.value
                                                    ?.name ?? '',
                                                onChanged: (String? newValue) {
                                                  if (newValue ==
                                                      'انتخاب کنید') {
                                                    orderCreateController
                                                        .changeSelectedBuySell(
                                                        null);
                                                  } else {
                                                    var selectedBuySell = orderCreateController
                                                        .orderTypeList
                                                        .firstWhere((type) =>
                                                    type.name == newValue);
                                                    orderCreateController
                                                        .changeSelectedBuySell(
                                                        selectedBuySell);
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
                                            orderCreateController.accountList.isEmpty ?
                                            Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                    AppColor.textColor),
                                              ),
                                            ) :
                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: CustomDropdown<AccountModel>(
                                                      items: orderCreateController.accountList,
                                                      selectedItem: orderCreateController.selectedAccount.value,
                                                      enableSearch: true,
                                                      errorText: orderCreateController.dropdownError.value,
                                                      itemLabel: (account) =>
                                                      account.name ??
                                                          "",
                                                      /*itemIcon: (bank) =>
                                                         bank.icon ??
                                                             "",*/
                                                      onChanged: (account) async {
                                                        setState(() {
                                                          orderCreateController.selectedAccount.value = account;
                                                          orderCreateController.dropdownError.value = "";
                                                        });
                                                        await orderCreateController.changeSelectedAccount(
                                                            account);
                                                        debugPrint(
                                                          "کاربر انتخاب شد: ${account?.name}",
                                                        );
                                                      },
                                                      isIcon: false,

                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Tooltip(
                                                  message: "ایجاد کاربری جدید",
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await Get.dialog(const UserCreateDialogWidget());
                                                        await orderCreateController.fetchAccountList();
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/svg/add-plus.svg',
                                                        height: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // محصول
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3, top: 5),
                                                  child: Text(
                                                    'محصول',
                                                    style: AppTextStyle.labelText
                                                        .copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10),
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                                // Most-used products (itemId 1 and 2)
                                                Obx(() {
                                                  final hasAccountSelected = orderCreateController.selectedAccount.value != null;
                                                  final mostUsedProducts = _getMostUsedProducts();
                                                  return hasAccountSelected &&
                                                      !orderCreateController.isLoadingItems.value &&
                                                      mostUsedProducts.isNotEmpty
                                                      ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                                                        child: Row(
                                                          children: mostUsedProducts.asMap().entries.map((entry) {
                                                            final index = entry.key;
                                                            final item = entry.value;
                                                            final isSelected = orderCreateController.selectedItem.value?.id == item.id;
                                                            return Container(
                                                              margin: EdgeInsets.only(
                                                                left: 2,
                                                              ),
                                                              child: _buildMostUsedProductCard(item, isSelected, isDesktop),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                    ],
                                                  )
                                                      : SizedBox.shrink();
                                                }),
                                              ],
                                            ),
                                            // محصول
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child: Obx(() {
                                                final hasAccountSelected = orderCreateController.selectedAccount.value != null;
                                                if(orderCreateController.isLoadingItems.value){
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                          AppColor.textColor),
                                                    ),
                                                  );
                                                }
                                                return CustomDropdownWidget(
                                                  validator: (value) {
                                                    if(!hasAccountSelected){
                                                      return 'ابتدا کاربر را انتخاب کنید';
                                                    }
                                                    if (value == 'انتخاب کنید' ||
                                                        value == null ||
                                                        value.isEmpty) {
                                                      return 'محصول را انتخاب کنید';
                                                    }
                                                    return null;
                                                  },
                                                  items: hasAccountSelected
                                                      ? [
                                                    'انتخاب کنید',
                                                    ...orderCreateController.itemList.map((item) => item.name ?? '')
                                                  ].toList()
                                                      : ['ابتدا کاربر را انتخاب کنید'],
                                                  selectedValue: hasAccountSelected
                                                      ? orderCreateController.selectedItem.value?.name
                                                      : 'ابتدا کاربر را انتخاب کنید',
                                                  onChanged: hasAccountSelected ? (String? newValue) {
                                                    if (newValue == 'انتخاب کنید') {
                                                      orderCreateController.changeSelectedItem(null);
                                                    } else {
                                                      var selectedItem = orderCreateController
                                                          .itemList
                                                          .firstWhere((item) =>
                                                      item.name == newValue);
                                                      orderCreateController
                                                          .changeSelectedItem(
                                                          selectedItem);
                                                    }
                                                  } : null,
                                                  backgroundColor: AppColor
                                                      .textFieldColor,
                                                  borderRadius: 7,
                                                  borderColor: AppColor
                                                      .secondaryColor,
                                                  hideUnderline: true,
                                                );
                                              }),
                                            ),
                                            // کارتخوان
                                            orderCreateController.selectedBuySell.value?.id==0 && orderCreateController.selectedItem.value?.hasCard==true ?
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('کارتخوان', style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop ? 12 : 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColor.primaryColor
                                                  ),),
                                                  SizedBox(width: 3),
                                                  Checkbox(
                                                    hoverColor: AppColor.textFieldColor.withAlpha(200),
                                                    value: orderCreateController.isCardChecked.value,
                                                    onChanged: (value) async{
                                                      orderCreateController.isCardChecked.value = value!;
                                                      if(value){
                                                        orderCreateController.priceController.text=((orderCreateController.selectedItem.value!.mesghalPrice)!+(orderCreateController.selectedItem.value?.cardPrice)!.toDouble()).toString().seRagham(separator: ',');
                                                      }else{
                                                        orderCreateController.priceController.text=(orderCreateController.selectedItem.value!.mesghalPrice).toString().seRagham(separator: ',');
                                                      }
                                                      orderCreateController.updateTotalPrice();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ) :
                                            SizedBox.shrink(),
                                            // قیمت
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 3, top: 5),
                                              child: Text(
                                                'قیمت (ریال)',
                                                style: AppTextStyle.labelText
                                                    .copyWith(
                                                    fontSize: isDesktop
                                                        ? 12
                                                        : 10),
                                              ),
                                            ),
                                            // قیمت
                                            Container(
                                              height: 70,
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child:
                                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(fit: FlexFit.loose,
                                                    child: IntrinsicHeight(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'لطفا قیمت سفارش را وارد کنید';
                                                          }
                                                          return null;
                                                        },
                                                        //readOnly: !orderCreateController.manualPriceChecked.value,
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        controller: orderCreateController.priceController,
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
                                                          if (cleanedValue.isNotEmpty) {
                                                            orderCreateController.priceController.text = cleanedValue
                                                                .toPersianDigit()
                                                                .seRagham();
                                                            orderCreateController
                                                                .priceController
                                                                .selection =
                                                                TextSelection.collapsed(
                                                                    offset: orderCreateController
                                                                        .priceController
                                                                        .text.length);
                                                          }
                                                          orderCreateController.updateTotalPrice();
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
                                                  //SizedBox(width: 8),
                                                  /*ElevatedButton(
                                                    onPressed: () async {
                                                      // دریافت قیمت از socket
                                                      await orderCreateController.fetchPriceFromSocket();
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                                                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      )),
                                                    ),
                                                    child: Text(
                                                      'دریافت قیمت',
                                                      style: AppTextStyle.labelText.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),*/
                                                  /*SizedBox(width: 3),
                                                  Checkbox(
                                                    hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                    value: orderCreateController.manualPriceChecked.value,
                                                    onChanged: (value) async{
                                                      orderCreateController.manualPriceChecked.value = value!;
                                                      if(!value) {
                                                        orderCreateController.changeSelectedItem(orderCreateController.selectedItem.value);
                                                      }
                                                      },
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                            // نمایش قیمت سوکت
                                           // SizedBox(height: 8),
                                            Obx(() {
                                              // مشاهده هر دو متغیر برای به‌روزرسانی
                                              orderCreateController.socketPrice.value;
                                              orderCreateController.currentPrice.value;
                                              return orderCreateController.socketPrice
                                                  .value.isNotEmpty ?
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: _getSocketPriceDisplayColor(),
                                                  border: Border.all(
                                                    color: _getSocketPriceBorderColor(),
                                                    width: 1,
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(8),
                                                ),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          _getSocketPriceIcon(),
                                                          color: _getSocketPriceBorderColor(),
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'قیمت آیتم: ',
                                                          style: AppTextStyle
                                                              .labelText.copyWith(
                                                            color: AppColor
                                                                .textColor
                                                                .withAlpha(175),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          _getSocketPriceValue(),
                                                          style: AppTextStyle
                                                              .labelText.copyWith(
                                                            color: _getSocketPriceBorderColor(),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Tooltip(
                                                      message: "افزودن قیمت",
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await orderCreateController.fetchPriceFromSocket();
                                                        },
                                                        child: Transform.rotate(
                                                          angle: math.pi / 2,
                                                          child: SvgPicture.asset(
                                                            'assets/svg/add-price.svg',
                                                            height: 28,
                                                            colorFilter: ColorFilter.mode(
                                                              AppColor.primaryColor,
                                                              BlendMode.srcIn,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ) :
                                              SizedBox();
                                            }),
                                            // قیمت به گرم
                                            SizedBox(height: 3),
                                            orderCreateController.selectedItem.value?.itemUnit?.name == 'گرم' ?
                                            Row(
                                              children: [
                                                Text(
                                                  ' قیمت به گرم: ',
                                                  style: AppTextStyle
                                                      .labelText.copyWith(color: AppColor.textColor.withAlpha(130)),),
                                                Text(orderCreateController.priceTemp.value.seRagham(separator: ','),
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .primaryColor.withAlpha(130)),)
                                              ],
                                            ) :
                                            SizedBox(),
                                            // گرم/عدد
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 3, top: 5),
                                              child: Text(
                                                'گرم/عدد',
                                                style: AppTextStyle.labelText
                                                    .copyWith(
                                                    fontSize: isDesktop
                                                        ? 12
                                                        : 10),
                                              ),
                                            ),
                                            // گرم/عدد
                                            orderCreateController
                                                .selectedBuySell.value?.name ==
                                                'فروش به کاربر' ?
                                            SizedBox(
                                              height: 70,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Flexible(fit: FlexFit.loose,
                                                      child: IntrinsicHeight(
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'لطفا مقدار سفارش را وارد کنید';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            if (_isValidatingQuantity) return;

                                                            // Cancel previous debounce timer if active
                                                            _limitCheckDebounce?.cancel();
                                                            // Check limit if value is not empty
                                                            if (value.isNotEmpty) {
                                                              final enteredValue = double.tryParse(value.toEnglishDigit());
                                                              if (enteredValue != null) {
                                                                final limit = _getCurrentLimit();
                                                                if (limit != null && enteredValue > limit) {
                                                                  // Debounce: wait for user to stop typing before showing dialog
                                                                  _limitCheckDebounce = Timer(const Duration(milliseconds: 500), () async {
                                                                    if (!_isDialogShowing) {
                                                                      _isDialogShowing = true;
                                                                      final shouldContinue = await _showLimitExceededDialog();
                                                                      _isDialogShowing = false;

                                                                      if (!shouldContinue) {
                                                                        // Cancel: clear the field as per requirement
                                                                        _isValidatingQuantity = true;
                                                                        orderCreateController.quantityController.clear();
                                                                        _isValidatingQuantity = false;
                                                                        // Update total price with cleared value
                                                                        orderCreateController.updateTotalPrice();
                                                                      }
                                                                    }
                                                                  });
                                                                }
                                                              }
                                                            }
                                                            orderCreateController.updateTotalPrice();
                                                          },
                                                          autovalidateMode: AutovalidateMode
                                                              .onUserInteraction,
                                                          controller: orderCreateController
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
                                                    /*SizedBox(width: 3),
                                                    Checkbox(
                                                      hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                      value: orderCreateController.notLimitChecked.value,
                                                      onChanged: (value) async{
                                                        orderCreateController.notLimitChecked.value = value!;
                                                      },
                                                    ),*/
                                                  ],
                                                ),
                                              ),
                                            )
                                                : SizedBox(
                                              height: 70,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Flexible(fit: FlexFit.loose,
                                                      child: IntrinsicHeight(
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'لطفا مقدار سفارش را وارد کنید';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            if (_isValidatingQuantity) return;

                                                            // Cancel previous debounce timer if active
                                                            _limitCheckDebounce?.cancel();
                                                            // Check limit if value is not empty
                                                            if (value.isNotEmpty) {
                                                              final enteredValue = double.tryParse(value.toEnglishDigit());
                                                              if (enteredValue != null) {
                                                                final limit = _getCurrentLimit();
                                                                if (limit != null && enteredValue > limit) {
                                                                  // Debounce: wait for user to stop typing before showing dialog
                                                                  _limitCheckDebounce = Timer(const Duration(milliseconds: 500), () async {
                                                                    if (!_isDialogShowing) {
                                                                      _isDialogShowing = true;
                                                                      final shouldContinue = await _showLimitExceededDialog();
                                                                      _isDialogShowing = false;

                                                                      if (!shouldContinue) {
                                                                        // Cancel: clear the field as per requirement
                                                                        _isValidatingQuantity = true;
                                                                        orderCreateController.quantityController.clear();
                                                                        _isValidatingQuantity = false;
                                                                        // Update total price with cleared value
                                                                        orderCreateController.updateTotalPrice();
                                                                      }
                                                                    }
                                                                  });
                                                                }
                                                              }
                                                            }
                                                            orderCreateController.updateTotalPrice();
                                                          },
                                                          autovalidateMode: AutovalidateMode
                                                              .onUserInteraction,
                                                          controller: orderCreateController
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
                                                    /*SizedBox(width: 3),
                                                    Checkbox(
                                                      hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                      value: orderCreateController.notLimitChecked.value,
                                                      onChanged: (value) async{
                                                        orderCreateController.notLimitChecked.value = value!;
                                                      },
                                                    ),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            orderCreateController.selectedItem.value?.id==10 ||
                                                orderCreateController.selectedItem.value?.id==14 ||
                                                orderCreateController.selectedItem.value?.id==15 ||
                                                orderCreateController.selectedItem.value?.id==16 ||
                                                orderCreateController.selectedItem.value?.id==37 ||
                                                orderCreateController.selectedItem.value?.id==38 ||
                                                orderCreateController.selectedItem.value?.id==39  ?
                                            Row(
                                              children: [
                                                Text(
                                                  ' وزن: ',
                                                  style: AppTextStyle
                                                      .labelText.copyWith(color: AppColor.textColor.withAlpha(130)),),
                                                Text("${orderCreateController.selectedItem.value?.w750} گرم ",
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .primaryColor.withAlpha(130)),)
                                              ],
                                            ) :
                                            SizedBox(),
                                            /*orderCreateController
                                                .selectedBuySell.value?.name ==
                                                'فروش به کاربر' ?
                                            Row(
                                              children: [
                                                Checkbox(
                                                  hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                  value: orderCreateController.notLimitChecked.value,
                                                  onChanged: (value) async{
                                                    orderCreateController.notLimitChecked.value = value!;
                                                    if(value==false){
                                                      orderCreateController.quantityController.text = orderCreateController.maxItemSell.value.toString();
                                                    }
                                                    orderCreateController.updateTotalPrice();
                                                  },
                                                ),
                                                Text(
                                                  ' حداکثر مقدار فروش برای این محصول: ',
                                                  style: AppTextStyle
                                                      .labelText,),
                                                Text('${orderCreateController
                                                    .maxItemSell.value}',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .primaryColor),)
                                              ],
                                            )
                                                :
                                            Row(
                                              children: [
                                                Checkbox(
                                                  hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                  value: orderCreateController.notLimitChecked.value,
                                                  onChanged: (value) async{
                                                    orderCreateController.notLimitChecked.value = value!;
                                                    if(value==false){
                                                      orderCreateController.quantityController.text = orderCreateController.maxItemBuy.value.toString();
                                                    }
                                                    orderCreateController.updateTotalPrice();
                                                  },
                                                ),
                                                Text(
                                                  ' حداکثر مقدار خرید برای این محصول: ',
                                                  style: AppTextStyle
                                                      .labelText,),
                                                Text('${orderCreateController
                                                    .maxItemBuy.value}',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .primaryColor),)
                                              ],
                                            ),*/
                                            SizedBox(height: 5,),
                                            // مبلغ کل
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 3, top: 5),
                                              child: Text(
                                                'مبلغ کل (ریال)',
                                                style: AppTextStyle.labelText
                                                    .copyWith(
                                                    fontSize: isDesktop
                                                        ? 12
                                                        : 10),
                                              ),
                                            ),
                                            // مبلغ کل
                                            Container(
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child:
                                              TextFormField(
                                                controller: orderCreateController
                                                    .totalPriceController,
                                                style: AppTextStyle.labelText,
                                                keyboardType: TextInputType
                                                    .number,
                                                onChanged: (value) {
                                                  // حذف کاماهای قبلی و فرمت جدید
                                                  String cleanedValue = value
                                                      .replaceAll(',', '');
                                                  if (cleanedValue.isNotEmpty) {
                                                    orderCreateController
                                                        .totalPriceController
                                                        .text =
                                                        cleanedValue
                                                            .toPersianDigit()
                                                            .seRagham();
                                                    orderCreateController
                                                        .totalPriceController
                                                        .selection =
                                                        TextSelection.collapsed(
                                                            offset: orderCreateController
                                                                .totalPriceController
                                                                .text.length);
                                                  }
                                                  orderCreateController
                                                      .updateQuantity();
                                                },
                                                onTap: () {
                                                  orderCreateController.totalPriceController.selection = TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset: orderCreateController.totalPriceController.text.length,
                                                  );
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
                                                  controller: orderCreateController
                                                      .dateController,
                                                  readOnly: true,
                                                  style: AppTextStyle.labelText,
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
                                                      orderCreateController
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
                                              padding: EdgeInsets.only(bottom: 5),
                                              child:
                                              TextFormField(
                                                controller: orderCreateController
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
                                            // دکمه ایجاد سفارش
                                            SizedBox(height:isDesktop ? 20 : 10,),
                                            orderCreateController.selectedBuySell.value?.name == 'خرید از کاربر' ?
                                            SizedBox(width: double.infinity,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    padding: WidgetStatePropertyAll(
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7)),
                                                    elevation: WidgetStatePropertyAll(
                                                        5),
                                                    backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        AppColor.primaryColor),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                10)))),
                                                onPressed: (){
                                                  if(formKey.currentState!.validate()) {
                                                    if(orderCreateController.selectedAccount.value!=null){
                                                      if (_isPriceOverOnePercent()) {
                                                        Get.defaultDialog(
                                                          backgroundColor: AppColor.backGroundColor,
                                                          title: "اخطار قیمت",
                                                          titleStyle: AppTextStyle.smallTitleText,
                                                          middleText: "قیمت در محدوده غیر مجاز است. آیا مایل به ادامه دادن هستید؟",
                                                          middleTextStyle: AppTextStyle.bodyText,
                                                          confirm: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor)),
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.defaultDialog(
                                                                backgroundColor: AppColor.backGroundColor,
                                                                title: "ایجاد سفارش خرید",
                                                                titleStyle: AppTextStyle.smallTitleText,
                                                                middleText: "آیا از ایجاد سفارش مطمئن هستید؟",
                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                content: Card(
                                                                  color: AppColor.backGroundColor,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        Text('جزئیات خرید ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                        SizedBox(height: 2,),
                                                                        Divider(height: 1,color: AppColor.dividerColor,),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('نام کاربر: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.selectedAccount.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('محصول: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.selectedItem.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('مقدار: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(formatQuantity(double.parse(orderCreateController.quantityController.text)), style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('قیمت خرید: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.priceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('مبلغ کل: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.totalPriceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('تاریخ: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.dateController.text, style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                confirm: ElevatedButton(
                                                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                                                                      AppColor.primaryColor)),
                                                                  onPressed: () async {
                                                                    await orderCreateController.insertOrder();
                                                                  },
                                                                  child: Text('ایجاد', style: AppTextStyle.bodyText,),
                                                                ),
                                                                cancel: ElevatedButton(
                                                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                                                                      AppColor.accentColor)),
                                                                  onPressed: ()  {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    'لغو',
                                                                    style: AppTextStyle.bodyText,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Text('ادامه', style: AppTextStyle.bodyText,),
                                                          ),
                                                          cancel: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
                                                            onPressed: () { Get.back(); },
                                                            child: Text('لغو', style: AppTextStyle.bodyText,),
                                                          ),
                                                        );
                                                      }
                                                      else {
                                                        Get.defaultDialog(
                                                          backgroundColor: AppColor.backGroundColor,
                                                          title: "ایجاد سفارش خرید",
                                                          titleStyle: AppTextStyle.smallTitleText,
                                                          middleText: "آیا از ایجاد سفارش مطمئن هستید؟",
                                                          middleTextStyle: AppTextStyle.bodyText,
                                                          content: Card(
                                                            color: AppColor.backGroundColor,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Text('جزئیات خرید ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  SizedBox(height: 2,),
                                                                  Divider(height: 1,color: AppColor.dividerColor,),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('نام کاربر: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.selectedAccount.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('محصول: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.selectedItem.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('مقدار: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(formatQuantity(double.parse(orderCreateController.quantityController.text)), style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('قیمت خرید: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.priceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('مبلغ کل: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.totalPriceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('تاریخ: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.dateController.text, style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          confirm: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                                                                AppColor.primaryColor)),
                                                            onPressed: () async {
                                                              await orderCreateController.insertOrder();
                                                            },
                                                            child: Text('ایجاد', style: AppTextStyle.bodyText,),
                                                          ),
                                                          cancel: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                                                                AppColor.accentColor)),
                                                            onPressed: ()  {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'لغو',
                                                              style: AppTextStyle.bodyText,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                                child: orderCreateController.isLoading.value
                                                    ?
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<
                                                      Color>(AppColor.textColor),
                                                ) :
                                                Text(
                                                    'ایجاد سفارش خرید',
                                                    style: AppTextStyle.labelText.copyWith(
                                                        fontSize: isDesktop ? 12 : 10)
                                                ),
                                              ),
                                            ) :
                                            SizedBox(width: double.infinity,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    padding: WidgetStatePropertyAll(
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7)),
                                                    elevation: WidgetStatePropertyAll(
                                                        5),
                                                    backgroundColor:
                                                    WidgetStatePropertyAll(AppColor.accentColor),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10)))),
                                                onPressed: () {
                                                  if(formKey.currentState!.validate())
                                                  {
                                                    if(orderCreateController.selectedAccount.value!=null){
                                                      if (_isPriceOverOnePercent()) {
                                                        Get.defaultDialog(
                                                          backgroundColor: AppColor.backGroundColor,
                                                          title: "اخطار قیمت",
                                                          titleStyle: AppTextStyle.smallTitleText,
                                                          middleText: "قیمت در محدوده غیر مجاز است. آیا مایل به ادامه دادن هستید؟",
                                                          middleTextStyle: AppTextStyle.bodyText,
                                                          confirm: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor)),
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.defaultDialog(
                                                                backgroundColor: AppColor.backGroundColor,
                                                                title: "ایجاد سفارش فروش",
                                                                titleStyle: AppTextStyle.smallTitleText,
                                                                middleText: "آیا از ایجاد سفارش مطمئن هستید؟",
                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                content: Card(
                                                                  color: AppColor.backGroundColor,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        Text('جزئیات فروش ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                        SizedBox(height: 2,),
                                                                        Divider(height: 1,color: AppColor.dividerColor,),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('نام کاربر: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.selectedAccount.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('محصول: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.selectedItem.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('مقدار: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(formatQuantity(double.parse(orderCreateController.quantityController.text)), style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('قیمت فروش: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.priceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('مبلغ کل: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.totalPriceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(width: 5,),
                                                                            Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                            SizedBox(width: 2,),
                                                                            Text('تاریخ: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                            Text(orderCreateController.dateController.text, style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                confirm: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor: WidgetStatePropertyAll(
                                                                          AppColor.primaryColor)),
                                                                  onPressed: () async {
                                                                    await orderCreateController.insertOrder();
                                                                  },
                                                                  child: Text(
                                                                    'ایجاد',
                                                                    style: AppTextStyle
                                                                        .bodyText,
                                                                  ),
                                                                ),
                                                                cancel: ElevatedButton(
                                                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
                                                                  onPressed: ()  {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    'لغو',
                                                                    style: AppTextStyle.bodyText,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Text('ادامه', style: AppTextStyle.bodyText,),
                                                          ),
                                                          cancel: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
                                                            onPressed: () { Get.back(); },
                                                            child: Text('لغو', style: AppTextStyle.bodyText,),
                                                          ),
                                                        );
                                                      }
                                                      else {
                                                        Get.defaultDialog(
                                                          backgroundColor: AppColor.backGroundColor,
                                                          title: "ایجاد سفارش فروش",
                                                          titleStyle: AppTextStyle.smallTitleText,
                                                          middleText: "آیا از ایجاد سفارش مطمئن هستید؟",
                                                          middleTextStyle: AppTextStyle.bodyText,
                                                          content: Card(
                                                            color: AppColor.backGroundColor,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Text('جزئیات فروش ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  SizedBox(height: 2,),
                                                                  Divider(height: 1,color: AppColor.dividerColor,),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('نام کاربر: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.selectedAccount.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('محصول: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.selectedItem.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('مقدار: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(formatQuantity(double.parse(orderCreateController.quantityController.text)), style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('قیمت فروش: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.priceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('مبلغ کل: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.totalPriceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 5,),
                                                                      Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                      SizedBox(width: 2,),
                                                                      Text('تاریخ: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                      Text(orderCreateController.dateController.text, style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          confirm: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor: WidgetStatePropertyAll(
                                                                    AppColor.primaryColor)),
                                                            onPressed: () async {
                                                              await orderCreateController.insertOrder();
                                                            },
                                                            child: Text(
                                                              'ایجاد',
                                                              style: AppTextStyle
                                                                  .bodyText,
                                                            ),
                                                          ),
                                                          cancel: ElevatedButton(
                                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
                                                            onPressed: ()  {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'لغو',
                                                              style: AppTextStyle.bodyText,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                                child: orderCreateController
                                                    .isLoading.value
                                                    ?
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<
                                                      Color>(AppColor.textColor),
                                                ) :
                                                Text(
                                                  'ایجاد سفارش فروش',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(fontSize: isDesktop ? 12 : 10),
                                                ),
                                              ),
                                            )
                                          ],
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
                          Column(
                            children: [
                              orderCreateController.isLoadingBalance.value==false ?
                              Center(child: CircularProgressIndicator(),)
                                  :
                              BalanceWidget(title: orderCreateController.selectedAccount.value?.name,
                                listBalance: orderCreateController.balanceList,
                                size: 400,),
                              // Error display widget
                              Obx(() => orderCreateController.hasError.value
                                  ? Container(
                                margin: EdgeInsets.only(top: 16),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(color: Colors.red.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade600,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orderCreateController.errorTitle.value,
                                            style: AppTextStyle.bodyText.copyWith(
                                              color: Colors.red.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            orderCreateController.errorMessage.value,
                                            style: AppTextStyle.bodyText.copyWith(
                                              color: Colors.red.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => orderCreateController.clearError(),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red.shade600,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : SizedBox.shrink()),
                              const SizedBox(height: 8),
                              Obx(() {
                                return AccountSalesGroupGetOneItemWidget(
                                  data: orderCreateController.selectedAccountSalesGroupItem.value,
                                  width: 400,
                                  title: orderCreateController
                                      .selectedAccount.value?.accountSalesGroup?.name,
                                  isLoading:
                                  orderCreateController.isLoadingAccountSalesGroupItem.value,
                                  selectedItemId: orderCreateController.selectedItem.value?.id,
                                  selectedBuySellId: orderCreateController.selectedBuySell.value?.id,
                                  onPriceSelected: (mesghlPrice) {
                                    orderCreateController.setPriceFromSalesGroup(mesghlPrice);
                                  },
                                );
                              }),
                              SizedBox(height: 8),
                              Obx(() {
                                return AccountLevelGetOneItemWidget(
                                  data: orderCreateController.selectedAccountLevelItem.value,
                                  width: 400,
                                  title: orderCreateController
                                      .selectedAccount.value?.accountLevel?.name,
                                  isLoading:
                                  orderCreateController.isLoadingAccountLevelItem.value,
                                );
                              }),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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

  String formatQuantity(double value) {
    String formatted = value.toStringAsFixed(4);

    if (formatted.endsWith('.0000')) {
      return value.toStringAsFixed(0);
    } else {
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      return formatted;
    }
  }

  /// Get most-used products (items with id == 1 and id == 2)
  List<ItemModel> _getMostUsedProducts() {
    return orderCreateController.itemList
        .where((item) => item.id == 1 || item.id == 2 || item.id == 3)
        .toList();
  }

  /// Build a clickable card for most-used products
  Widget _buildMostUsedProductCard(ItemModel item, bool isSelected, bool isDesktop) {
    return GestureDetector(
      onTap: () {
        orderCreateController.changeSelectedItem(item);
      },
      child: Obx(() {
        final buySellId = orderCreateController.selectedBuySell.value?.id;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (buySellId == 0
                ? AppColor.accentColor.withAlpha(30)
                : AppColor.primaryColor.withAlpha(30))
                : AppColor.secondary200Color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (buySellId == 0
                  ? AppColor.accentColor.withAlpha(200)
                  : AppColor.primaryColor.withAlpha(200))
                  : AppColor.secondary200Color,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              item.name ?? '',
              style: AppTextStyle.labelText.copyWith(
                fontSize: isDesktop ? 10 : 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                color: isSelected
                    ? (buySellId == 0
                    ? AppColor.accentColor
                    : AppColor.primaryColor)
                    : AppColor.dividerColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }),
    );
  }

  /// Get the current limit (maxSell for sell, maxBuy for buy)
  double? _getCurrentLimit() {
    final accountLevelItem = orderCreateController.selectedAccountLevelItem.value;
    if (accountLevelItem == null ||
        accountLevelItem.accountLevelItems == null ||
        accountLevelItem.accountLevelItems!.isEmpty) {
      return null;
    }

    final item = accountLevelItem.accountLevelItems!.first;
    final buySellId = orderCreateController.selectedBuySell.value?.id;

    // id == 0 means sell, id == 1 means buy
    if (buySellId == 0) {
      // Sell order - check maxSell
      return item.maxSell;
    } else if (buySellId == 1) {
      // Buy order - check maxBuy
      return item.maxBuy;
    }

    return null;
  }

  /// Show dialog when entered amount exceeds the allowed limit
  Future<bool> _showLimitExceededDialog() async {
    bool? result = false;

    await Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: "هشدار",
      titleStyle: AppTextStyle.smallTitleText,
      middleText: "مقدار وارد شده از حد مجاز سطح بیشتر است",
      middleTextStyle: AppTextStyle.bodyText,
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
        ),
        onPressed: () {
          result = true;
          Get.back();
        },
        child: Text('ادامه', style: AppTextStyle.bodyText),
      ),
      cancel: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
        ),
        onPressed: () {
          result = false;
          Get.back();
        },
        child: Text('لغو', style: AppTextStyle.bodyText),
      ),
    );

    return result ?? false;
  }

}


