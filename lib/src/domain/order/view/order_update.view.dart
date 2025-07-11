import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/order_update.controller.dart';
import '../model/order.model.dart';

class OrderUpdateView extends StatefulWidget {
  const OrderUpdateView({super.key});

  @override
  State<OrderUpdateView> createState() => _OrderUpdateViewState();
}

class _OrderUpdateViewState extends State<OrderUpdateView> {
  OrderUpdateController orderUpdateController =
  Get.find<OrderUpdateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
    return Obx(() {
      return Scaffold(
        appBar: CustomAppbar1(title: 'ویرایش سفارش', onBackTap: () {
          Get.back();
          orderUpdateController.clearList(); }),
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
                          orderUpdateController.isLoadingBalance.value == false
                              ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: orderUpdateController.balanceList,
                            size: 400,),
                        ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          padding: EdgeInsets.symmetric(
                              horizontal:isDesktop ?40 : 2, vertical: isDesktop ? 20 : 5),
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
                                              Get.toNamed('/orderList');
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: isDesktop ? 200 : 70, bottom: 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('لیست سفارشات',
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
                                      constraints: isDesktop ? BoxConstraints(
                                          maxWidth: 500) : BoxConstraints(
                                          maxWidth: 400),
                                      padding: isDesktop
                                          ? const EdgeInsets.symmetric(
                                          horizontal: 40)
                                          : const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Form(
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
                                                enabledChange: false,
                                                items: orderUpdateController
                                                    .orderTypeList.map((type) =>
                                                type.name ?? '')
                                                    .toList(),
                                                selectedValue: orderUpdateController
                                                    .selectedBuySell.value
                                                    ?.name ?? '',
                                                onChanged: (String? newValue) {
                                                  var selectedBuySell = orderUpdateController
                                                      .orderTypeList
                                                      .firstWhere((type) =>
                                                  type.name == newValue);
                                                  orderUpdateController
                                                      .changeSelectedBuySell(
                                                      selectedBuySell);
                                                },
                                                backgroundColor: AppColor
                                                    .textFieldColor,
                                                borderRadius: 7,
                                                borderColor: AppColor
                                                    .secondaryColor,
                                                hideUnderline: true,
                                              ),
                                            ),
                                            // محصول
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
                                            // محصول
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child: CustomDropdownWidget(
                                                items: orderUpdateController
                                                    .itemList
                                                    .map((item) =>
                                                item.name ?? '').toList(),
                                                selectedValue: orderUpdateController
                                                    .selectedItem.value?.name,
                                                onChanged: (String? newValue) {
                                                  var selectedItem = orderUpdateController
                                                      .itemList.firstWhere((
                                                      item) =>
                                                  item.name == newValue);
                                                  orderUpdateController
                                                      .changeSelectedItem(
                                                      selectedItem);
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
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.loose,
                                                    child: CustomDropdownWidget(
                                                      dropdownSearchData: DropdownSearchData<
                                                          String>(
                                                        searchController: orderUpdateController
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
                                                          child: TextFormField(
                                                            style: AppTextStyle
                                                                .bodyText,
                                                            controller: orderUpdateController
                                                                .searchController,
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
                                                                BorderRadius.circular(
                                                                    8),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      value: orderUpdateController.selectedAccount.value,
                                                      showSearchBox: true,
                                                      items:[
                                                        'انتخاب کنید',
                                                        ...orderUpdateController
                                                            .searchedAccounts
                                                            .map((account) =>
                                                        account.name ?? "")
                                                      ].toList(),
                                                      selectedValue: orderUpdateController
                                                          .selectedAccount.value
                                                          ?.name,
                                                      onChanged: (String? newValue) {
                                                        var selectedAccount = orderUpdateController
                                                            .searchedAccounts
                                                            .firstWhere((account) =>
                                                        account.name == newValue);
                                                        orderUpdateController.changeSelectedAccount(selectedAccount);
                                                      },
                                                      onMenuStateChange: (isOpen) {
                                                        if (isOpen) {
                                                          orderUpdateController.fetchAccountList();
                                                        }
                                                        if (!isOpen) {
                                                          orderUpdateController.resetAccountSearch();
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
                                                  SizedBox(width: 3),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed('/insertUser',parameters: {'id':0.toString()});
                                                    },
                                                    child: SvgPicture.asset('assets/svg/add.svg',
                                                      width: 35,
                                                      height: 35,
                                                      colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child:
                                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(fit: FlexFit.loose,
                                                    child: TextFormField(
                                                      readOnly: !orderUpdateController.manualPriceChecked.value,
                                                      controller: orderUpdateController
                                                          .priceController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      onChanged: (value) {
                                                        // حذف کاماهای قبلی و فرمت جدید
                                                        String cleanedValue = value
                                                            .replaceAll(',', '');
                                                        if (cleanedValue.isNotEmpty) {
                                                          orderUpdateController
                                                              .priceController.text =
                                                              cleanedValue
                                                                  .toPersianDigit()
                                                                  .seRagham();
                                                          orderUpdateController
                                                              .priceController
                                                              .selection =
                                                              TextSelection.collapsed(
                                                                  offset: orderUpdateController
                                                                      .priceController
                                                                      .text.length);
                                                        }
                                                        orderUpdateController.updateTotalPrice();
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
                                                  SizedBox(width: 3),
                                                  Checkbox(
                                                    hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                    value: orderUpdateController.manualPriceChecked.value,
                                                    onChanged: (value) async{
                                                      orderUpdateController.manualPriceChecked.value = value!;
                                                      if(!value) {
                                                        orderUpdateController.changeSelectedItem(orderUpdateController.selectedItem.value);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                            orderUpdateController
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
                                                            if(orderUpdateController.notLimitChecked.value==false){
                                                              setState(() {
                                                                double item = double
                                                                    .tryParse(
                                                                    value == ""
                                                                        ? "0"
                                                                        : value.replaceAll(" ", "").toEnglishDigit()) ?? 0;
                                                                if (item >= orderUpdateController.maxItemSell.value) {
                                                                  orderUpdateController.quantityController.text =
                                                                      orderUpdateController.maxItemSell.value.toString();
                                                                  print(item);
                                                                }
                                                              });
                                                            }
                                                            orderUpdateController
                                                                .updateTotalPrice();
                                                          },
                                                          autovalidateMode: AutovalidateMode
                                                              .onUserInteraction,
                                                          controller: orderUpdateController
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
                                                    SizedBox(width: 3),
                                                    Checkbox(
                                                      hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                      value: orderUpdateController.notLimitChecked.value,
                                                      onChanged: (value) async{
                                                        orderUpdateController.notLimitChecked.value = value!;
                                                      },
                                                    ),
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
                                                            if(orderUpdateController.notLimitChecked.value==false){
                                                              setState(() {
                                                                double item = double
                                                                    .tryParse(
                                                                    value == ""
                                                                        ? "0"
                                                                        : value.replaceAll(" ", "").toEnglishDigit()) ?? 0;
                                                                if (item >= orderUpdateController.maxItemBuy.value) {
                                                                  orderUpdateController.quantityController.text = orderUpdateController.maxItemBuy.value.toString();
                                                                  print(item);
                                                                }
                                                              });
                                                            }
                                                            orderUpdateController
                                                                .updateTotalPrice();
                                                          },
                                                          autovalidateMode: AutovalidateMode
                                                              .onUserInteraction,
                                                          controller: orderUpdateController
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
                                                    SizedBox(width: 3),
                                                    Checkbox(
                                                      hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                                                      value: orderUpdateController.notLimitChecked.value,
                                                      onChanged: (value) async{
                                                        orderUpdateController.notLimitChecked.value = value!;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            orderUpdateController
                                                .selectedBuySell.value?.name ==
                                                'فروش به کاربر' ?
                                            Row(
                                              children: [
                                                Text(
                                                  ' حداکثر مقدار فروش برای این محصول: ',
                                                  style: AppTextStyle
                                                      .labelText,),
                                                Text('${orderUpdateController
                                                    .maxItemSell.value}',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .primaryColor),)
                                              ],
                                            )
                                                :
                                            Row(
                                              children: [
                                                Text(
                                                  ' حداکثر مقدار خرید برای این محصول: ',
                                                  style: AppTextStyle
                                                      .labelText,),
                                                Text('${orderUpdateController
                                                    .maxItemBuy.value}',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .primaryColor),)
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            /*Container(
                                              height: 50,
                                              padding: EdgeInsets.only(bottom: 5),
                                              child: TextFormField(
                                                  controller: orderUpdateController.quantityController,
                                                  style: AppTextStyle.labelText,
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                                      // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                      String newText = newValue.text
                                                          .replaceAll('٠', '0')
                                                          .replaceAll('١', '1')
                                                          .replaceAll('٢', '2')
                                                          .replaceAll('٣', '3')
                                                          .replaceAll('٤', '4')
                                                          .replaceAll('٥', '5')
                                                          .replaceAll('٦', '6')
                                                          .replaceAll('٧', '7')
                                                          .replaceAll('٨', '8')
                                                          .replaceAll('٩', '9');

                                                      return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                                                    }),
                                                  ],
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    filled: true,
                                                    fillColor: AppColor.textFieldColor,
                                                  ),
                                                ),
                                            ),*/
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
                                                controller: orderUpdateController
                                                    .totalPriceController,
                                                style: AppTextStyle.labelText,
                                                keyboardType: TextInputType
                                                    .number,
                                                onChanged: (value) {
                                                  // حذف کاماهای قبلی و فرمت جدید
                                                  String cleanedValue = value
                                                      .replaceAll(',', '');
                                                  if (cleanedValue.isNotEmpty) {
                                                    orderUpdateController
                                                        .totalPriceController
                                                        .text =
                                                        cleanedValue
                                                            .toPersianDigit()
                                                            .seRagham();
                                                    orderUpdateController
                                                        .totalPriceController
                                                        .selection =
                                                        TextSelection.collapsed(
                                                            offset: orderUpdateController
                                                                .totalPriceController
                                                                .text.length);
                                                  }
                                                  orderUpdateController
                                                      .updateQuantity();
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
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  bottom: 5),
                                              child: TextFormField(
                                                controller: orderUpdateController.dateController,
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
                                                    locale: Locale("fa", "IR"),
                                                  );
                                                  DateTime date = DateTime
                                                      .now();
                                                  if (pickedDate != null) {
                                                    orderUpdateController
                                                        .dateController.text =
                                                    "${pickedDate
                                                        .year}/${pickedDate
                                                        .month.toString()
                                                        .padLeft(
                                                        2, '0')}/${pickedDate
                                                        .day.toString().padLeft(
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
                                              TextFormField(
                                                controller: orderUpdateController
                                                    .descriptionController,
                                                maxLines: 5,
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
                                            // دکمه آپدیت سفارش
                                            SizedBox(height: 20,),
                                            orderUpdateController
                                                .selectedBuySell.value?.name ==
                                                'خرید از کاربر' ?
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
                                                    Get.defaultDialog(
                                                      backgroundColor: AppColor.backGroundColor,
                                                      title: "ویرایش سفارش خرید",
                                                      titleStyle: AppTextStyle.smallTitleText,
                                                      middleText: "آیا از ویرایش سفارش مطمئن هستید؟",
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
                                                                  Text('محصول: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  Text(orderUpdateController.selectedItem.value?.name ??'', style: AppTextStyle.bodyText,),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 5,),
                                                                  Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                  SizedBox(width: 2,),
                                                                  Text('مقدار: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  Text(formatQuantity(double.parse(orderUpdateController.quantityController.text)), style: AppTextStyle.bodyText,),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 5,),
                                                                  Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                  SizedBox(width: 2,),
                                                                  Text('قیمت خرید: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  Text(orderUpdateController.priceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 5,),
                                                                  Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                  SizedBox(width: 2,),
                                                                  Text('مبلغ کل: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  Text(orderUpdateController.totalPriceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: 5,),
                                                                  Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                  SizedBox(width: 2,),
                                                                  Text('تاریخ: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                  Text(orderUpdateController.dateController.text, style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
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
                                                          await orderUpdateController.updateOrder();
                                                        },
                                                        child: Text(
                                                          'ویرایش',
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
                                                child: orderUpdateController
                                                    .isLoading.value
                                                    ?
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<
                                                      Color>(AppColor
                                                      .textColor),
                                                ) :
                                                Text(
                                                  'ویرایش سفارش خرید',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                            ) :
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
                                                        AppColor.accentColor),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                10)))),
                                                onPressed: () {
                                                  Get.defaultDialog(
                                                    backgroundColor: AppColor.backGroundColor,
                                                    title: "ویرایش سفارش فروش",
                                                    titleStyle: AppTextStyle.smallTitleText,
                                                    middleText: "آیا از ویرایش سفارش مطمئن هستید؟",
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
                                                                Text('محصول: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                Text(orderUpdateController.selectedItem.value?.name ??'', style: AppTextStyle.bodyText,),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 5,),
                                                                Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                SizedBox(width: 2,),
                                                                Text('مقدار: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                Text(formatQuantity(double.parse(orderUpdateController.quantityController.text)), style: AppTextStyle.bodyText,),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 5,),
                                                                Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                SizedBox(width: 2,),
                                                                Text('قیمت فروش: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                Text(orderUpdateController.priceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 5,),
                                                                Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                SizedBox(width: 2,),
                                                                Text('مبلغ کل: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                Text(orderUpdateController.totalPriceController.text.seRagham(separator: ','), style: AppTextStyle.bodyText,),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 5,),
                                                                Icon(Icons.circle,size: 5,color: AppColor.primaryColor,),
                                                                SizedBox(width: 2,),
                                                                Text('تاریخ: ', style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                                                Text(orderUpdateController.dateController.text, style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,),
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
                                                        await orderUpdateController.updateOrder();
                                                      },
                                                      child: Text(
                                                        'ویرایش',
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
                                                child: orderUpdateController.isLoading.value
                                                    ?
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<
                                                      Color>(AppColor
                                                      .textColor),
                                                ) :
                                                Text(
                                                  'ویرایش سفارش فروش',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
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
                          orderUpdateController.isLoadingBalance.value == false
                              ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: orderUpdateController.balanceList,
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
}
