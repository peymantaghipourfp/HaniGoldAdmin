import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';
import 'package:hanigold_admin/src/domain/order/widget/total_balance_new.widget.dart';
import 'package:hanigold_admin/src/domain/transaction/widgets/balance_date_dialog.widget.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:hanigold_admin/src/widget/err_page.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/item_weight_calculator_dialog.widget.dart';
import '../../../widget/pager_widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../../transaction/widgets/balance_dialog.widget.dart';
import '../widget/hover_tooltip_balance.widget.dart';
import '../widget/order_create_dialog.widget.dart';
import '../widget/order_filter.widget.dart';
import '../widget/order_update_dialog.widget.dart';

class OrderListView extends StatefulWidget {
  OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  bool isExpanded = false;
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
  }
  // Method to handle expansion state changes from balance widgets
  void onBalanceExpansionChanged(bool isExpanded) {
    setState(() {
      this.isExpanded = isExpanded;
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    //final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(() {
      return Scaffold(
        appBar: CustomAppbar1(
          title: 'سفارشات', onBackTap: () => Get.offNamed('/home'),),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImageTotal(),
            // Real-time refresh indicator
            if (orderController.isRefreshing.value)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 5,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
                  ),
                ),
              ),
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: SingleChildScrollView(
                      controller:isDesktop ? null : orderController.scrollController,
                      child: Column(
                          children: [
                             orderController.stateBalance.value ==
                                PageState.loading ?
                            Center(
                            child: CircularProgressIndicator()) :
                            orderController.totalBalanceList.isNotEmpty ?
                              Padding(
                              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 45 : 30 ),
                              child:
                              SizedBox(
                                width: Get.width,
                                height: isExpanded ? Get.height * 0.49 : Get.height * 0.35,
                                child: ListView.builder(
                                  scrollDirection: isDesktop
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  controller: orderController.balanceScrollController,
                                  itemCount: orderController.totalBalanceList.length,
                                  shrinkWrap: true, // Allow ListView to size based on content
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var totalBalance = orderController.totalBalanceList[index];
                                      if (orderController.stateBalance.value == PageState.loading) {
                                        //   EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                                        return Center(child: CircularProgressIndicator());
                                      }else if (orderController.stateBalance.value == PageState.empty) {
                                        //  EasyLoading.dismiss();
                                        return EmptyPage(
                                          title: 'تراز وجود ندارد',
                                          callback: () {
                                            orderController.fetchTotalBalanceList();
                                          },
                                        );
                                      }else
                                      if (orderController.stateBalance.value == PageState.list){
                                        return
                                          TotalBalanceNewWidget(isDesktop: isDesktop, totalBalance: totalBalance,onExpansionChanged: onBalanceExpansionChanged,isExpanded: isExpanded,);
                                          //TotalBalanceWidget(isDesktop: isDesktop, totalBalance: totalBalance,);
                                      }
                                      return ErrPage(
                                        callback: () {
                                          orderController.clearFilter();
                                          orderController.fetchTotalBalanceList();
                                        },
                                        title: "خطا در دریافت تراز",
                                        des: 'برای دریافت تراز مجددا تلاش کنید',
                                      );
                                  },
                                ),
                              )
                            ) :
                            EmptyPage(
                              title: 'تراز وجود ندارد',
                              callback: () {
                                orderController.fetchTotalBalanceList();
                                },
                            ),
                      
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                    (isDesktop) ?
                                       /*Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment: Alignment.center,
                                        height: 70,
                                        child: TextSelectionTheme(
                                          data: TextSelectionThemeData(
                                            selectionColor: Colors.white.withAlpha(100),
                                          ),
                                          child: TextFormField(
                                            controller: orderController
                                                .searchController,
                                            style: AppTextStyle.labelText,
                                            textInputAction: TextInputAction.search,
                                            onFieldSubmitted: (value) async {
                                              if (value.isNotEmpty) {
                                                await orderController
                                                    .searchAccounts(value);
                                                showSearchResults(context);
                                              } else {
                                                orderController.clearSearch();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: isDesktop ? 16 : 12,
                                                horizontal: 16,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10),
                                              ),
                                              filled: true,
                                              fillColor: AppColor.textFieldColor,
                                              hintText: "جستجوی سفارش ... ",
                                              hintStyle: AppTextStyle.labelText,
                                              prefixIcon: IconButton(
                                                  onPressed: () async {
                                                    if (orderController
                                                        .searchController.text
                                                        .isNotEmpty) {
                                                      await orderController
                                                          .searchAccounts(
                                                          orderController
                                                              .searchController.text
                                                      );
                                                      showSearchResults(context);
                                                    } else {
                                                      orderController.clearSearch();
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.search,
                                                    color: AppColor.textColor,
                                                    size: 30,)
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: orderController
                                                    .clearSearch,
                                                icon: Icon(
                                                    Icons.close,
                                                    color: AppColor.textColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )*/
                                       SizedBox.shrink():
                                       Column(
                                        children: [
                                          TextSelectionTheme(
                                            data: TextSelectionThemeData(
                                              selectionColor: Colors.white.withAlpha(100),
                                            ),
                                            child: TextFormField(
                                              controller: orderController
                                                  .searchController,
                                              style: AppTextStyle.labelText,
                                              textInputAction: TextInputAction
                                                  .search,
                                              onFieldSubmitted: (value) async {
                                                if (value.isNotEmpty) {
                                                  await orderController
                                                      .searchAccounts(value);
                                                  showSearchResults(context);
                                                } else {
                                                  orderController.clearSearch();
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets
                                                    .symmetric(
                                                  vertical: isDesktop ? 16 : 12,
                                                  horizontal: 16,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                ),
                                                filled: true,
                                                fillColor: AppColor.textFieldColor,
                                                hintText: "جستجوی سفارش ... ",
                                                hintStyle: AppTextStyle.labelText,
                                                prefixIcon: IconButton(
                                                    onPressed: () async {
                                                      if (orderController
                                                          .searchController
                                                          .text.isNotEmpty) {
                                                        await orderController
                                                            .searchAccounts(
                                                            orderController
                                                                .searchController
                                                                .text
                                                        );
                                                        showSearchResults(context);
                                                      } else {
                                                        orderController
                                                            .clearSearch();
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.search,
                                                      color: AppColor.textColor,
                                                      size: 30,)
                                                ),
                                                suffixIcon: IconButton(
                                                  onPressed: orderController
                                                      .clearSearch,
                                                  icon: Icon(
                                                      Icons.close,
                                                      color: AppColor.textColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                            decoration: BoxDecoration(
                                              color: AppColor.appBarColor.withAlpha(30),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    // سفارش جدید
                                                    GestureDetector(
                                                      onTap: () {
                                                        //Get.toNamed('/orderCreate');
                                                        Get.dialog(
                                                          const OrderCreateDialogWidget(),
                                                          barrierDismissible: false,
                                                        );
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/svg/add-plus.svg',
                                                        height: 30,
                                                      ),
                                                    ),
                                                    SizedBox(width: 17,),
                                                    // خروجی اکسل
                                                    GestureDetector(
                                                      onTap: () {
                                                        showGeneralDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            barrierLabel: MaterialLocalizations
                                                                .of(context)
                                                                .modalBarrierDismissLabel,
                                                            barrierColor: Colors
                                                                .black45,
                                                            transitionDuration: const Duration(
                                                                milliseconds: 200),
                                                            pageBuilder: (
                                                                BuildContext buildContext,
                                                                Animation animation,
                                                                Animation secondaryAnimation) {
                                                              return Center(
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            8),
                                                                        color: AppColor
                                                                            .backGroundColor
                                                                    ),
                                                                    width: isDesktop
                                                                        ? Get.width *
                                                                        0.2
                                                                        : Get.height *
                                                                        0.5,
                                                                    height: isDesktop
                                                                        ? Get.height *
                                                                        0.5
                                                                        : Get.height *
                                                                        0.7,
                                                                    padding: EdgeInsets
                                                                        .all(20),
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(8.0),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Text(
                                                                                'خروجی اکسل',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight
                                                                                      .normal,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          color: AppColor
                                                                              .textColor,
                                                                          height: 0.2,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 8,),
                                                                              Column(
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'نوع سفارش',
                                                                                    style: AppTextStyle.labelText.copyWith(
                                                                                        fontSize: 11,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        color: AppColor.textColor),
                                                                                  ),
                                                                                  SizedBox(height: 10,),
                                                                                  Obx(() => Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Radio<int?>(
                                                                                            value: 1,
                                                                                            groupValue: orderController.type.value,
                                                                                            onChanged: (value) {
                                                                                              orderController.checkType(value);
                                                                                            },
                                                                                            activeColor: AppColor.primaryColor,
                                                                                          ),
                                                                                          Text(
                                                                                            'خرید',
                                                                                            style: AppTextStyle.labelText.copyWith(
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                color: AppColor.textColor),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Radio<int?>(
                                                                                            value: 0,
                                                                                            groupValue: orderController.type.value,
                                                                                            onChanged: (value) {
                                                                                              orderController.checkType(value);
                                                                                            },
                                                                                            activeColor: AppColor.primaryColor,
                                                                                          ),
                                                                                          Text(
                                                                                            'فروش',
                                                                                            style: AppTextStyle.labelText.copyWith(
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                color: AppColor.textColor),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Radio<int?>(
                                                                                            value: null,
                                                                                            groupValue: orderController.type.value,
                                                                                            onChanged: (value) {
                                                                                              orderController.checkType(value);
                                                                                            },
                                                                                            activeColor: AppColor.primaryColor,
                                                                                          ),
                                                                                          Text(
                                                                                            'همه',
                                                                                            style: AppTextStyle.labelText.copyWith(
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                color: AppColor.textColor),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ))
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                  height: 8),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    'از تاریخ',
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight
                                                                                            .normal,
                                                                                        color: AppColor
                                                                                            .textColor),
                                                                                  ),
                                                                                  Container(
                                                                                    //height: 50,
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: 5),
                                                                                    child: IntrinsicHeight(
                                                                                      child: TextSelectionTheme(
                                                                                        data: TextSelectionThemeData(
                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          validator: (
                                                                                              value) {
                                                                                            if (value ==
                                                                                                null ||
                                                                                                value
                                                                                                    .isEmpty) {
                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          controller: orderController
                                                                                              .dateStartController,
                                                                                          readOnly: true,
                                                                                          style: AppTextStyle
                                                                                              .labelText,
                                                                                          decoration: InputDecoration(
                                                                                            suffixIcon: Icon(
                                                                                                Icons
                                                                                                    .calendar_month,
                                                                                                color: AppColor
                                                                                                    .textColor),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius
                                                                                                  .circular(
                                                                                                  10),
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
                                                                                                  1400,
                                                                                                  1,
                                                                                                  1),
                                                                                              lastDate: Jalali(
                                                                                                  1450,
                                                                                                  12,
                                                                                                  29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                  .calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                  .day,
                                                                                              locale: Locale(
                                                                                                  "fa",
                                                                                                  "IR"),
                                                                                            );
                                                                                            Gregorian gregorian = pickedDate!
                                                                                                .toGregorian();
                                                                                            orderController
                                                                                                .startDateFilter
                                                                                                .value =
                                                                                            "${gregorian
                                                                                                .year}-${gregorian
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}-${gregorian
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";

                                                                                            orderController
                                                                                                .dateStartController
                                                                                                .text =
                                                                                            "${pickedDate
                                                                                                .year}/${pickedDate
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}/${pickedDate
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                  height: 8),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    'تا تاریخ',
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight
                                                                                            .normal,
                                                                                        color: AppColor
                                                                                            .textColor),
                                                                                  ),
                                                                                  Container(
                                                                                    //height: 50,
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: 5),
                                                                                    child: IntrinsicHeight(
                                                                                      child: TextSelectionTheme(
                                                                                        data: TextSelectionThemeData(
                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          validator: (
                                                                                              value) {
                                                                                            if (value ==
                                                                                                null ||
                                                                                                value
                                                                                                    .isEmpty) {
                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          controller: orderController
                                                                                              .dateEndController,
                                                                                          readOnly: true,
                                                                                          style: AppTextStyle
                                                                                              .labelText,
                                                                                          decoration: InputDecoration(
                                                                                            suffixIcon: Icon(
                                                                                                Icons
                                                                                                    .calendar_month,
                                                                                                color: AppColor
                                                                                                    .textColor),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius
                                                                                                  .circular(
                                                                                                  10),
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
                                                                                                  1400,
                                                                                                  1,
                                                                                                  1),
                                                                                              lastDate: Jalali(
                                                                                                  1450,
                                                                                                  12,
                                                                                                  29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                  .calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                  .day,
                                                                                              locale: Locale(
                                                                                                  "fa",
                                                                                                  "IR"),
                                                                                            );
                                                                                            // DateTime date=DateTime.now();
                                                                                            Gregorian gregorian = pickedDate!
                                                                                                .toGregorian();
                                                                                            orderController
                                                                                                .endDateFilter
                                                                                                .value =
                                                                                            "${gregorian
                                                                                                .year}-${gregorian
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}-${gregorian
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";

                                                                                            orderController
                                                                                                .dateEndController
                                                                                                .text =
                                                                                            "${pickedDate
                                                                                                .year}/${pickedDate
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}/${pickedDate
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Container(
                                                                          margin: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 10),
                                                                          width: double
                                                                              .infinity,
                                                                          height: 40,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                padding: WidgetStatePropertyAll(
                                                                                    EdgeInsets
                                                                                        .symmetric(
                                                                                        horizontal: 23,
                                                                                        )),
                                                                                // elevation: WidgetStatePropertyAll(5),
                                                                                backgroundColor:
                                                                                WidgetStatePropertyAll(
                                                                                    AppColor
                                                                                        .appBarColor),
                                                                                shape: WidgetStatePropertyAll(
                                                                                    RoundedRectangleBorder(
                                                                                        side: BorderSide(
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            5)))),
                                                                            onPressed: () async {
                                                                              orderController.getOrderExcel();
                                                                              Get.back();
                                                                            },
                                                                            child: orderController
                                                                                .isLoading
                                                                                .value ?
                                                                            CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<
                                                                                  Color>(
                                                                                  AppColor
                                                                                      .textColor),
                                                                            ) :
                                                                            Text(
                                                                              'ثبت',
                                                                              style: AppTextStyle
                                                                                  .labelText
                                                                                  .copyWith(
                                                                                  fontSize: isDesktop
                                                                                      ? 12
                                                                                      : 10),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/svg/excel.svg',
                                                          height: 30,
                                                      ),
                                                    ),
                                                    SizedBox(width: 17,),
                                                    // خروجی pdf
                                                    GestureDetector(
                                                      onTap: () {
                                                        showGeneralDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            barrierLabel: MaterialLocalizations
                                                                .of(context)
                                                                .modalBarrierDismissLabel,
                                                            barrierColor: Colors
                                                                .black45,
                                                            transitionDuration: const Duration(
                                                                milliseconds: 200),
                                                            pageBuilder: (
                                                                BuildContext buildContext,
                                                                Animation animation,
                                                                Animation secondaryAnimation) {
                                                              return Center(
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            8),
                                                                        color: AppColor
                                                                            .backGroundColor
                                                                    ),
                                                                    width: isDesktop
                                                                        ? Get.width *
                                                                        0.2
                                                                        : Get.height *
                                                                        0.5,
                                                                    height: isDesktop
                                                                        ? Get.height *
                                                                        0.5
                                                                        : Get.height *
                                                                        0.7,
                                                                    padding: EdgeInsets
                                                                        .all(20),
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(8.0),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Text(
                                                                                'خروجی pdf',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight
                                                                                      .normal,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          color: AppColor
                                                                              .textColor,
                                                                          height: 0.2,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                  height: 8),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    'از تاریخ',
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight
                                                                                            .normal,
                                                                                        color: AppColor
                                                                                            .textColor),
                                                                                  ),
                                                                                  Container(
                                                                                    //height: 50,
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: 5),
                                                                                    child: IntrinsicHeight(
                                                                                      child: TextSelectionTheme(
                                                                                        data: TextSelectionThemeData(
                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          validator: (
                                                                                              value) {
                                                                                            if (value ==
                                                                                                null ||
                                                                                                value
                                                                                                    .isEmpty) {
                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          controller: orderController
                                                                                              .dateStartController,
                                                                                          readOnly: true,
                                                                                          style: AppTextStyle
                                                                                              .labelText,
                                                                                          decoration: InputDecoration(
                                                                                            suffixIcon: Icon(
                                                                                                Icons
                                                                                                    .calendar_month,
                                                                                                color: AppColor
                                                                                                    .textColor),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius
                                                                                                  .circular(
                                                                                                  10),
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
                                                                                                  1400,
                                                                                                  1,
                                                                                                  1),
                                                                                              lastDate: Jalali(
                                                                                                  1450,
                                                                                                  12,
                                                                                                  29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                  .calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                  .day,
                                                                                              locale: Locale(
                                                                                                  "fa",
                                                                                                  "IR"),
                                                                                            );
                                                                                            Gregorian gregorian = pickedDate!
                                                                                                .toGregorian();
                                                                                            orderController
                                                                                                .startDateFilter
                                                                                                .value =
                                                                                            "${gregorian
                                                                                                .year}-${gregorian
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}-${gregorian
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";

                                                                                            orderController
                                                                                                .dateStartController
                                                                                                .text =
                                                                                            "${pickedDate
                                                                                                .year}/${pickedDate
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}/${pickedDate
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                  height: 8),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    'تا تاریخ',
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight
                                                                                            .normal,
                                                                                        color: AppColor
                                                                                            .textColor),
                                                                                  ),
                                                                                  Container(
                                                                                    //height: 50,
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: 5),
                                                                                    child: IntrinsicHeight(
                                                                                      child: TextSelectionTheme(
                                                                                        data: TextSelectionThemeData(
                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          validator: (
                                                                                              value) {
                                                                                            if (value ==
                                                                                                null ||
                                                                                                value
                                                                                                    .isEmpty) {
                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          controller: orderController
                                                                                              .dateEndController,
                                                                                          readOnly: true,
                                                                                          style: AppTextStyle
                                                                                              .labelText,
                                                                                          decoration: InputDecoration(
                                                                                            suffixIcon: Icon(
                                                                                                Icons
                                                                                                    .calendar_month,
                                                                                                color: AppColor
                                                                                                    .textColor),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius
                                                                                                  .circular(
                                                                                                  10),
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
                                                                                                  1400,
                                                                                                  1,
                                                                                                  1),
                                                                                              lastDate: Jalali(
                                                                                                  1450,
                                                                                                  12,
                                                                                                  29),
                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                  .calendar,
                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                  .day,
                                                                                              locale: Locale(
                                                                                                  "fa",
                                                                                                  "IR"),
                                                                                            );
                                                                                            // DateTime date=DateTime.now();
                                                                                            Gregorian gregorian = pickedDate!
                                                                                                .toGregorian();
                                                                                            orderController
                                                                                                .endDateFilter
                                                                                                .value =
                                                                                            "${gregorian
                                                                                                .year}-${gregorian
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}-${gregorian
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";

                                                                                            orderController
                                                                                                .dateEndController
                                                                                                .text =
                                                                                            "${pickedDate
                                                                                                .year}/${pickedDate
                                                                                                .month
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}/${pickedDate
                                                                                                .day
                                                                                                .toString()
                                                                                                .padLeft(
                                                                                                2,
                                                                                                '0')}";
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Container(
                                                                          margin: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 10),
                                                                          width: double
                                                                              .infinity,
                                                                          height: 40,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                padding: WidgetStatePropertyAll(
                                                                                    EdgeInsets
                                                                                        .symmetric(
                                                                                        horizontal: 23,
                                                                                        )),
                                                                                // elevation: WidgetStatePropertyAll(5),
                                                                                backgroundColor:
                                                                                WidgetStatePropertyAll(
                                                                                    AppColor
                                                                                        .appBarColor),
                                                                                shape: WidgetStatePropertyAll(
                                                                                    RoundedRectangleBorder(
                                                                                        side: BorderSide(
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            5)))),
                                                                            onPressed: () async {
                                                                              orderController
                                                                                  .exportToPdf();
                                                                              Get
                                                                                  .back();
                                                                            },
                                                                            child: orderController
                                                                                .isLoading
                                                                                .value ?
                                                                            CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<
                                                                                  Color>(
                                                                                  AppColor
                                                                                      .textColor),
                                                                            ) :
                                                                            Text(
                                                                              'ثبت',
                                                                              style: AppTextStyle
                                                                                  .labelText
                                                                                  .copyWith(
                                                                                  fontSize: isDesktop
                                                                                      ? 12
                                                                                      : 10),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/svg/pdf.svg',
                                                        height: 30,
                                                      ),
                                                    ),
                                                    SizedBox(width: 17,),
                                                    // تبدیل واحد
                                                    GestureDetector(
                                                        onTap: () {
                                                          showItemWeightCalculatorDialog(
                                                            context: context,
                                                            items: orderController.itemList,
                                                            mesghalPriceNotifier: orderController.mesghalPriceNotifier,
                                                            onChange: (result) {
                                                              // Handle real-time changes if needed
                                                              debugPrint('Total weight: ${result.totalWeight}g');
                                                            },
                                                            onConfirm: (result) {
                                                              // Handle confirmation
                                                              debugPrint('Confirmed - Total weight: ${result.totalWeight}g');
                                                              for (var item in result.selectedItems) {
                                                                debugPrint('${item.name}: ${item.count} x ${item.weight}g = ${item.totalItemWeight}g');
                                                              }
                                                            },
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.scale_rounded,
                                                          size: 30,
                                                          color: AppColor.buttonColor,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                // فیلتر
                                                 GestureDetector(
                                                      onTap: () async {
                                                        showGeneralDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            barrierLabel: MaterialLocalizations
                                                                .of(context)
                                                                .modalBarrierDismissLabel,
                                                            barrierColor: Colors
                                                                .black45,
                                                            transitionDuration: const Duration(
                                                                milliseconds: 200),
                                                            pageBuilder: (
                                                                BuildContext buildContext,
                                                                Animation animation,
                                                                Animation secondaryAnimation) {
                                                              return Center(
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            8),
                                                                        color: AppColor
                                                                            .backGroundColor
                                                                    ),
                                                                    width: isDesktop
                                                                        ? Get.width *
                                                                        0.35
                                                                        : Get.height *
                                                                        0.5,
                                                                    height: isDesktop
                                                                        ? Get.height *
                                                                        0.65
                                                                        : Get.height *
                                                                        0.75,
                                                                    padding: EdgeInsets
                                                                        .all(20),
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(8.0),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .end,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'فیلتر',
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight
                                                                                          .normal,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 50,
                                                                                height: 27,
                                                                                child: ElevatedButton(
                                                                                  style: ButtonStyle(
                                                                                      padding: WidgetStatePropertyAll(
                                                                                          EdgeInsets
                                                                                              .symmetric(
                                                                                              horizontal: 2,
                                                                                              vertical: 1)),
                                                                                      // elevation: WidgetStatePropertyAll(5),
                                                                                      backgroundColor:
                                                                                      WidgetStatePropertyAll(
                                                                                          AppColor
                                                                                              .accentColor
                                                                                              .withAlpha(
                                                                                              100)),
                                                                                      shape: WidgetStatePropertyAll(
                                                                                          RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                  color: AppColor
                                                                                                      .textColor),
                                                                                              borderRadius: BorderRadius
                                                                                                  .circular(
                                                                                                  5)))),
                                                                                  onPressed: () async {
                                                                                    orderController.currentPage.value=1;
                                                                                    orderController.itemsPerPage.value=25;
                                                                                    orderController
                                                                                        .clearFilter();
                                                                                    orderController
                                                                                        .getOrderListPager();
                                                                                    Get
                                                                                        .back();
                                                                                  },
                                                                                  child: Text(
                                                                                    'حذف فیلتر',
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: isDesktop
                                                                                            ? 9
                                                                                            : 8),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          color: AppColor
                                                                              .textColor,
                                                                          height: 0.2,
                                                                        ),
                                                                        OrderFilterWidget(
                                                                          orderController: orderController,
                                                                        ),
                                                                        Spacer(),
                                                                        Container(
                                                                          margin: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 10),
                                                                          width: double
                                                                              .infinity,
                                                                          height: 40,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                padding: WidgetStatePropertyAll(
                                                                                    EdgeInsets
                                                                                        .symmetric(
                                                                                        horizontal: 23,)),
                                                                                // elevation: WidgetStatePropertyAll(5),
                                                                                backgroundColor:
                                                                                WidgetStatePropertyAll(
                                                                                    AppColor
                                                                                        .appBarColor),
                                                                                shape: WidgetStatePropertyAll(
                                                                                    RoundedRectangleBorder(
                                                                                        side: BorderSide(
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            5)))),
                                                                            onPressed: () async {
                                                                              orderController.currentPage.value=1;
                                                                              orderController.itemsPerPage.value=25;
                                                                              orderController
                                                                                  .getOrderListPager();
                                                                              Get
                                                                                  .back();
                                                                            },
                                                                            child: orderController
                                                                                .isLoading
                                                                                .value ?
                                                                            CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<
                                                                                  Color>(
                                                                                  AppColor
                                                                                      .textColor),
                                                                            ) :
                                                                            Text(
                                                                              'فیلتر',
                                                                              style: AppTextStyle
                                                                                  .labelText
                                                                                  .copyWith(
                                                                                  fontSize: isDesktop
                                                                                      ? 12
                                                                                      : 10),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                    child: SvgPicture.asset(
                                                        'assets/svg/filter3.svg',
                                                        height: 26,
                                                        colorFilter:
                                                        ColorFilter.mode(
                                                          orderController
                                                              .nameFilterController
                                                              .text != "" ||
                                                              orderController
                                                                  .mobileFilterController
                                                                  .text != "" ||
                                                              orderController
                                                                  .dateStartController
                                                                  .text != "" ||
                                                              orderController
                                                                  .dateEndController
                                                                  .text != "" ||
                                                              orderController.byAdmin.value != null||
                                                              orderController.type.value != null ||
                                                              orderController.selectedItemFilter.value !=null
                                                              ? AppColor.filterColor
                                                              : AppColor
                                                              .textColor,
                                                          BlendMode.srcIn,
                                                        )
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                            ),
                            // لیست سفارشات
                            Obx(() {
                              if (orderController.state.value ==
                                  PageState.loading) {
                                //   EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                                return Center(child: CircularProgressIndicator());
                              }
                              else if (orderController.state.value ==
                                  PageState.empty) {
                                //  EasyLoading.dismiss();
                                return EmptyPage(
                                  title: 'سفارشی وجود ندارد',
                                  callback: () {
                                    orderController.getOrderListPager();
                                  },
                                );
                              }
                              else
                              if (orderController.state.value == PageState.list) {
                                // EasyLoading.dismiss();
                                // لیست سفارشات
                                return
                                  isDesktop ?
                                  Container(
                                    height: Get.height,
                                    width: Get.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5,vertical:5 ),
                                    padding: EdgeInsets.symmetric(horizontal: 5,vertical:5),
                                    decoration: BoxDecoration(
                                      color: AppColor.backGroundColor1,
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(color: const Color(0xFF64748B)),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: ClampingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  SingleChildScrollView(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric( vertical: 5),
                                                            /*margin: EdgeInsets.symmetric(
                                                                horizontal: isDesktop ? 20 : 5, vertical: 4),*/
                                                            /*decoration: BoxDecoration(
                                                              color: AppColor.appBarColor.withAlpha(30),
                                                              borderRadius: BorderRadius.circular(10),
                                                              //border: Border.all(color: const Color(0xFF64748B)),
                                                            ),*/
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: 400,
                                                                  child: TextFormField(
                                                                    controller: orderController
                                                                        .searchController,
                                                                    style: AppTextStyle.labelText,
                                                                    textInputAction: TextInputAction.search,
                                                                    onFieldSubmitted: (value) async {
                                                                      if (value.isNotEmpty) {
                                                                        await orderController
                                                                            .searchAccounts(value);
                                                                        showSearchResults(context);
                                                                      } else {
                                                                        orderController.clearSearch();
                                                                      }
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                        vertical: isDesktop ? 16 : 12,
                                                                        horizontal: 16,
                                                                      ),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            10),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: AppColor.textFieldColor,
                                                                      hintText: "جستجوی سفارش ... ",
                                                                      hintStyle: AppTextStyle.labelText,
                                                                      prefixIcon: IconButton(
                                                                          onPressed: () async {
                                                                            if (orderController
                                                                                .searchController.text
                                                                                .isNotEmpty) {
                                                                              await orderController
                                                                                  .searchAccounts(
                                                                                  orderController
                                                                                      .searchController.text
                                                                              );
                                                                              showSearchResults(context);
                                                                            } else {
                                                                              orderController.clearSearch();
                                                                            }
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.search,
                                                                            color: AppColor.textColor,
                                                                            size: 24,)
                                                                      ),
                                                                      suffixIcon: IconButton(
                                                                        onPressed: orderController
                                                                            .clearSearch,
                                                                        icon: Icon(
                                                                          Icons.close,
                                                                          color: AppColor.textColor,size: 24,),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    // ایجاد سفارش جدید
                                                                    TextButton.icon(
                                                                      //onPressed: () => Get.toNamed('/orderCreate'),
                                                                      onPressed: () {
                                                                        Get.dialog(
                                                                          const OrderCreateDialogWidget(),
                                                                          barrierDismissible: false,
                                                                          barrierColor: Colors.transparent,
                                                                        );
                                                                        },
                                                                      icon: SvgPicture.asset(
                                                                        'assets/svg/add-plus.svg',
                                                                        height: 24,
                                                                      ),
                                                                      label: Text(
                                                                        'ایجاد سفارش جدید',
                                                                        style: AppTextStyle
                                                                            .labelText.copyWith(fontSize: 12),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    // خروجی اکسل
                                                                    OutlinedButton.icon(
                                                                      onPressed: () {
                                                                        showGeneralDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            barrierLabel: MaterialLocalizations
                                                                                .of(context)
                                                                                .modalBarrierDismissLabel,
                                                                            barrierColor: Colors
                                                                                .black45,
                                                                            transitionDuration: const Duration(
                                                                                milliseconds: 200),
                                                                            pageBuilder: (
                                                                                BuildContext buildContext,
                                                                                Animation animation,
                                                                                Animation secondaryAnimation) {
                                                                              return Center(
                                                                                child: Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            8),
                                                                                        color: AppColor
                                                                                            .backGroundColor
                                                                                    ),
                                                                                    width: isDesktop
                                                                                        ? Get
                                                                                        .width *
                                                                                        0.2
                                                                                        : Get
                                                                                        .height *
                                                                                        0.5,
                                                                                    height: isDesktop
                                                                                        ? Get
                                                                                        .height *
                                                                                        0.5
                                                                                        : Get
                                                                                        .height *
                                                                                        0.7,
                                                                                    padding: EdgeInsets
                                                                                        .all(
                                                                                        20),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .all(
                                                                                              8.0),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                                .center,
                                                                                            children: [
                                                                                              Text(
                                                                                                'خروجی اکسل',
                                                                                                style: AppTextStyle
                                                                                                    .labelText
                                                                                                    .copyWith(
                                                                                                  fontSize: 15,
                                                                                                  fontWeight: FontWeight
                                                                                                      .normal,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          color: AppColor
                                                                                              .textColor,
                                                                                          height: 0.2,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .symmetric(
                                                                                              horizontal: 10),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: 8,),
                                                                                              Column(
                                                                                                crossAxisAlignment:
                                                                                                CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'نوع سفارش',
                                                                                                    style: AppTextStyle.labelText.copyWith(
                                                                                                        fontSize: 11,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        color: AppColor.textColor),
                                                                                                  ),
                                                                                                  SizedBox(height: 10,),
                                                                                                  Obx(() => Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Radio<int?>(
                                                                                                            value: 1,
                                                                                                            groupValue: orderController.type.value,
                                                                                                            onChanged: (value) {
                                                                                                              orderController.checkType(value);
                                                                                                            },
                                                                                                            activeColor: AppColor.primaryColor,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            'خرید',
                                                                                                            style: AppTextStyle.labelText.copyWith(
                                                                                                                fontSize: 11,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                color: AppColor.textColor),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Radio<int?>(
                                                                                                            value: 0,
                                                                                                            groupValue: orderController.type.value,
                                                                                                            onChanged: (value) {
                                                                                                              orderController.checkType(value);
                                                                                                            },
                                                                                                            activeColor: AppColor.primaryColor,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            'فروش',
                                                                                                            style: AppTextStyle.labelText.copyWith(
                                                                                                                fontSize: 11,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                color: AppColor.textColor),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Radio<int?>(
                                                                                                            value: null,
                                                                                                            groupValue: orderController.type.value,
                                                                                                            onChanged: (value) {
                                                                                                              orderController.checkType(value);
                                                                                                            },
                                                                                                            activeColor: AppColor.primaryColor,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            'همه',
                                                                                                            style: AppTextStyle.labelText.copyWith(
                                                                                                                fontSize: 11,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                color: AppColor.textColor),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ))
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height: 8),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                                    .start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'از تاریخ',
                                                                                                    style: AppTextStyle
                                                                                                        .labelText
                                                                                                        .copyWith(
                                                                                                        fontSize: 13,
                                                                                                        fontWeight: FontWeight
                                                                                                            .normal,
                                                                                                        color: AppColor
                                                                                                            .textColor),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    //height: 50,
                                                                                                    padding: EdgeInsets
                                                                                                        .only(
                                                                                                        bottom: 5),
                                                                                                    child: IntrinsicHeight(
                                                                                                      child: TextSelectionTheme(
                                                                                                        data: TextSelectionThemeData(
                                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                                        ),
                                                                                                        child: TextFormField(
                                                                                                          validator: (
                                                                                                              value) {
                                                                                                            if (value ==
                                                                                                                null ||
                                                                                                                value
                                                                                                                    .isEmpty) {
                                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                                            }
                                                                                                            return null;
                                                                                                          },
                                                                                                          controller: orderController
                                                                                                              .dateStartController,
                                                                                                          readOnly: true,
                                                                                                          style: AppTextStyle
                                                                                                              .labelText,
                                                                                                          decoration: InputDecoration(
                                                                                                            suffixIcon: Icon(
                                                                                                                Icons
                                                                                                                    .calendar_month,
                                                                                                                color: AppColor
                                                                                                                    .textColor),
                                                                                                            border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius
                                                                                                                  .circular(
                                                                                                                  10),
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
                                                                                                                  1400,
                                                                                                                  1,
                                                                                                                  1),
                                                                                                              lastDate: Jalali(
                                                                                                                  1450,
                                                                                                                  12,
                                                                                                                  29),
                                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                                  .calendar,
                                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                                  .day,
                                                                                                              locale: Locale(
                                                                                                                  "fa",
                                                                                                                  "IR"),
                                                                                                            );
                                                                                                            Gregorian gregorian = pickedDate!
                                                                                                                .toGregorian();
                                                                                                            orderController
                                                                                                                .startDateFilter
                                                                                                                .value =
                                                                                                            "${gregorian
                                                                                                                .year}-${gregorian
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}-${gregorian
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";

                                                                                                            orderController
                                                                                                                .dateStartController
                                                                                                                .text =
                                                                                                            "${pickedDate
                                                                                                                .year}/${pickedDate
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}/${pickedDate
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height: 8),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                                    .start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'تا تاریخ',
                                                                                                    style: AppTextStyle
                                                                                                        .labelText
                                                                                                        .copyWith(
                                                                                                        fontSize: 13,
                                                                                                        fontWeight: FontWeight
                                                                                                            .normal,
                                                                                                        color: AppColor
                                                                                                            .textColor),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    //height: 50,
                                                                                                    padding: EdgeInsets
                                                                                                        .only(
                                                                                                        bottom: 5),
                                                                                                    child: IntrinsicHeight(
                                                                                                      child: TextSelectionTheme(
                                                                                                        data: TextSelectionThemeData(
                                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                                        ),
                                                                                                        child: TextFormField(
                                                                                                          validator: (
                                                                                                              value) {
                                                                                                            if (value ==
                                                                                                                null ||
                                                                                                                value
                                                                                                                    .isEmpty) {
                                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                                            }
                                                                                                            return null;
                                                                                                          },
                                                                                                          controller: orderController
                                                                                                              .dateEndController,
                                                                                                          readOnly: true,
                                                                                                          style: AppTextStyle
                                                                                                              .labelText,
                                                                                                          decoration: InputDecoration(
                                                                                                            suffixIcon: Icon(
                                                                                                                Icons
                                                                                                                    .calendar_month,
                                                                                                                color: AppColor
                                                                                                                    .textColor),
                                                                                                            border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius
                                                                                                                  .circular(
                                                                                                                  10),
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
                                                                                                                  1400,
                                                                                                                  1,
                                                                                                                  1),
                                                                                                              lastDate: Jalali(
                                                                                                                  1450,
                                                                                                                  12,
                                                                                                                  29),
                                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                                  .calendar,
                                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                                  .day,
                                                                                                              locale: Locale(
                                                                                                                  "fa",
                                                                                                                  "IR"),
                                                                                                            );
                                                                                                            // DateTime date=DateTime.now();
                                                                                                            Gregorian gregorian = pickedDate!.toGregorian();
                                                                                                            orderController
                                                                                                                .endDateFilter
                                                                                                                .value =
                                                                                                            "${gregorian
                                                                                                                .year}-${gregorian
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}-${gregorian
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";

                                                                                                            orderController
                                                                                                                .dateEndController
                                                                                                                .text =
                                                                                                            "${pickedDate
                                                                                                                .year}/${pickedDate
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}/${pickedDate
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Spacer(),
                                                                                        Container(
                                                                                          margin: EdgeInsets
                                                                                              .symmetric(
                                                                                              horizontal: 20,
                                                                                              vertical: 10),
                                                                                          width: double
                                                                                              .infinity,
                                                                                          height: 40,
                                                                                          child: ElevatedButton(
                                                                                            style: ButtonStyle(
                                                                                                padding: WidgetStatePropertyAll(
                                                                                                    EdgeInsets
                                                                                                        .symmetric(
                                                                                                        horizontal: 23,
                                                                                                        )),
                                                                                                // elevation: WidgetStatePropertyAll(5),
                                                                                                backgroundColor:
                                                                                                WidgetStatePropertyAll(
                                                                                                    AppColor
                                                                                                        .appBarColor),
                                                                                                shape: WidgetStatePropertyAll(
                                                                                                    RoundedRectangleBorder(
                                                                                                        side: BorderSide(
                                                                                                            color: AppColor
                                                                                                                .textColor),
                                                                                                        borderRadius: BorderRadius
                                                                                                            .circular(
                                                                                                            5)))),
                                                                                            onPressed: () async {
                                                                                              orderController.getOrderExcel();
                                                                                              Get.back();
                                                                                            },
                                                                                            child: orderController
                                                                                                .isLoading
                                                                                                .value
                                                                                                ?
                                                                                            CircularProgressIndicator(
                                                                                              valueColor: AlwaysStoppedAnimation<
                                                                                                  Color>(
                                                                                                  AppColor
                                                                                                      .textColor),
                                                                                            )
                                                                                                :
                                                                                            Text(
                                                                                              'ثبت',
                                                                                              style: AppTextStyle
                                                                                                  .labelText
                                                                                                  .copyWith(
                                                                                                  fontSize: isDesktop
                                                                                                      ? 12
                                                                                                      : 10),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      label: Text(
                                                                        'خروجی اکسل',
                                                                        style: AppTextStyle
                                                                            .labelText.copyWith(color: AppColor.primaryColor,fontSize: 12),
                                                                      ),
                                                                      icon: SvgPicture.asset(
                                                                        'assets/svg/excel.svg',
                                                                        height: 24,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    // خروجی pdf
                                                                    OutlinedButton.icon(
                                                                      onPressed: () {
                                                                        showGeneralDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            barrierLabel: MaterialLocalizations
                                                                                .of(context)
                                                                                .modalBarrierDismissLabel,
                                                                            barrierColor: Colors
                                                                                .black45,
                                                                            transitionDuration: const Duration(
                                                                                milliseconds: 200),
                                                                            pageBuilder: (
                                                                                BuildContext buildContext,
                                                                                Animation animation,
                                                                                Animation secondaryAnimation) {
                                                                              return Center(
                                                                                child: Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            8),
                                                                                        color: AppColor
                                                                                            .backGroundColor
                                                                                    ),
                                                                                    width: isDesktop
                                                                                        ? Get
                                                                                        .width *
                                                                                        0.2
                                                                                        : Get
                                                                                        .height *
                                                                                        0.5,
                                                                                    height: isDesktop
                                                                                        ? Get
                                                                                        .height *
                                                                                        0.5
                                                                                        : Get
                                                                                        .height *
                                                                                        0.7,
                                                                                    padding: EdgeInsets
                                                                                        .all(
                                                                                        20),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .all(
                                                                                              8.0),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                                .center,
                                                                                            children: [
                                                                                              Text(
                                                                                                'خروجی pdf',
                                                                                                style: AppTextStyle
                                                                                                    .labelText
                                                                                                    .copyWith(
                                                                                                  fontSize: 15,
                                                                                                  fontWeight: FontWeight
                                                                                                      .normal,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          color: AppColor
                                                                                              .textColor,
                                                                                          height: 0.2,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .symmetric(
                                                                                              horizontal: 10),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                  height: 8),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                                    .start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'از تاریخ',
                                                                                                    style: AppTextStyle
                                                                                                        .labelText
                                                                                                        .copyWith(
                                                                                                        fontSize: 13,
                                                                                                        fontWeight: FontWeight
                                                                                                            .normal,
                                                                                                        color: AppColor
                                                                                                            .textColor),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    //height: 50,
                                                                                                    padding: EdgeInsets
                                                                                                        .only(
                                                                                                        bottom: 5),
                                                                                                    child: IntrinsicHeight(
                                                                                                      child: TextSelectionTheme(
                                                                                                        data: TextSelectionThemeData(
                                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                                        ),
                                                                                                        child: TextFormField(
                                                                                                          validator: (
                                                                                                              value) {
                                                                                                            if (value ==
                                                                                                                null ||
                                                                                                                value
                                                                                                                    .isEmpty) {
                                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                                            }
                                                                                                            return null;
                                                                                                          },
                                                                                                          controller: orderController
                                                                                                              .dateStartController,
                                                                                                          readOnly: true,
                                                                                                          style: AppTextStyle
                                                                                                              .labelText,
                                                                                                          decoration: InputDecoration(
                                                                                                            suffixIcon: Icon(
                                                                                                                Icons
                                                                                                                    .calendar_month,
                                                                                                                color: AppColor
                                                                                                                    .textColor),
                                                                                                            border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius
                                                                                                                  .circular(
                                                                                                                  10),
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
                                                                                                                  1400,
                                                                                                                  1,
                                                                                                                  1),
                                                                                                              lastDate: Jalali(
                                                                                                                  1450,
                                                                                                                  12,
                                                                                                                  29),
                                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                                  .calendar,
                                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                                  .day,
                                                                                                              locale: Locale(
                                                                                                                  "fa",
                                                                                                                  "IR"),
                                                                                                            );
                                                                                                            Gregorian gregorian = pickedDate!
                                                                                                                .toGregorian();
                                                                                                            orderController
                                                                                                                .startDateFilter
                                                                                                                .value =
                                                                                                            "${gregorian
                                                                                                                .year}-${gregorian
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}-${gregorian
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";

                                                                                                            orderController
                                                                                                                .dateStartController
                                                                                                                .text =
                                                                                                            "${pickedDate
                                                                                                                .year}/${pickedDate
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}/${pickedDate
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height: 8),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                                    .start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'تا تاریخ',
                                                                                                    style: AppTextStyle
                                                                                                        .labelText
                                                                                                        .copyWith(
                                                                                                        fontSize: 13,
                                                                                                        fontWeight: FontWeight
                                                                                                            .normal,
                                                                                                        color: AppColor
                                                                                                            .textColor),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    //height: 50,
                                                                                                    padding: EdgeInsets
                                                                                                        .only(
                                                                                                        bottom: 5),
                                                                                                    child: IntrinsicHeight(
                                                                                                      child: TextSelectionTheme(
                                                                                                        data: TextSelectionThemeData(
                                                                                                          selectionColor: Colors.white.withAlpha(100),
                                                                                                        ),
                                                                                                        child: TextFormField(
                                                                                                          validator: (
                                                                                                              value) {
                                                                                                            if (value ==
                                                                                                                null ||
                                                                                                                value
                                                                                                                    .isEmpty) {
                                                                                                              return 'لطفا تاریخ را انتخاب کنید';
                                                                                                            }
                                                                                                            return null;
                                                                                                          },
                                                                                                          controller: orderController
                                                                                                              .dateEndController,
                                                                                                          readOnly: true,
                                                                                                          style: AppTextStyle
                                                                                                              .labelText,
                                                                                                          decoration: InputDecoration(
                                                                                                            suffixIcon: Icon(
                                                                                                                Icons
                                                                                                                    .calendar_month,
                                                                                                                color: AppColor
                                                                                                                    .textColor),
                                                                                                            border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius
                                                                                                                  .circular(
                                                                                                                  10),
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
                                                                                                                  1400,
                                                                                                                  1,
                                                                                                                  1),
                                                                                                              lastDate: Jalali(
                                                                                                                  1450,
                                                                                                                  12,
                                                                                                                  29),
                                                                                                              initialEntryMode: PersianDatePickerEntryMode
                                                                                                                  .calendar,
                                                                                                              initialDatePickerMode: PersianDatePickerMode
                                                                                                                  .day,
                                                                                                              locale: Locale(
                                                                                                                  "fa",
                                                                                                                  "IR"),
                                                                                                            );
                                                                                                            // DateTime date=DateTime.now();
                                                                                                            Gregorian gregorian = pickedDate!
                                                                                                                .toGregorian();
                                                                                                            orderController
                                                                                                                .endDateFilter
                                                                                                                .value =
                                                                                                            "${gregorian
                                                                                                                .year}-${gregorian
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}-${gregorian
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";

                                                                                                            orderController
                                                                                                                .dateEndController
                                                                                                                .text =
                                                                                                            "${pickedDate
                                                                                                                .year}/${pickedDate
                                                                                                                .month
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}/${pickedDate
                                                                                                                .day
                                                                                                                .toString()
                                                                                                                .padLeft(
                                                                                                                2,
                                                                                                                '0')}";
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),

                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Spacer(),
                                                                                        Container(
                                                                                          margin: EdgeInsets
                                                                                              .symmetric(
                                                                                              horizontal: 20,
                                                                                              vertical: 10),
                                                                                          width: double
                                                                                              .infinity,
                                                                                          height: 40,
                                                                                          child: ElevatedButton(
                                                                                            style: ButtonStyle(
                                                                                                padding: WidgetStatePropertyAll(
                                                                                                    EdgeInsets
                                                                                                        .symmetric(
                                                                                                        horizontal: 23,
                                                                                                        )),
                                                                                                // elevation: WidgetStatePropertyAll(5),
                                                                                                backgroundColor:
                                                                                                WidgetStatePropertyAll(
                                                                                                    AppColor
                                                                                                        .appBarColor),
                                                                                                shape: WidgetStatePropertyAll(
                                                                                                    RoundedRectangleBorder(
                                                                                                        side: BorderSide(
                                                                                                            color: AppColor
                                                                                                                .textColor),
                                                                                                        borderRadius: BorderRadius
                                                                                                            .circular(
                                                                                                            5)))),
                                                                                            onPressed: () async {
                                                                                              orderController
                                                                                                  .exportToPdf();
                                                                                              Get
                                                                                                  .back();
                                                                                            },
                                                                                            child: orderController
                                                                                                .isLoading
                                                                                                .value
                                                                                                ?
                                                                                            CircularProgressIndicator(
                                                                                              valueColor: AlwaysStoppedAnimation<
                                                                                                  Color>(
                                                                                                  AppColor
                                                                                                      .textColor),
                                                                                            )
                                                                                                :
                                                                                            Text(
                                                                                              'ثبت',
                                                                                              style: AppTextStyle
                                                                                                  .labelText
                                                                                                  .copyWith(
                                                                                                  fontSize: isDesktop
                                                                                                      ? 12
                                                                                                      : 10),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      label: Text(
                                                                        'خروجی pdf',
                                                                        style: AppTextStyle.labelText.copyWith(color: AppColor.textAccentColor,fontSize: 12),
                                                                      ),
                                                                      icon: SvgPicture.asset(
                                                                        'assets/svg/pdf.svg',
                                                                        height: 24,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    // فیلتر
                                                                    OutlinedButton.icon(
                                                                      onPressed: () async {
                                                                        showGeneralDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            barrierLabel: MaterialLocalizations
                                                                                .of(context)
                                                                                .modalBarrierDismissLabel,
                                                                            barrierColor: Colors
                                                                                .black45,
                                                                            transitionDuration: const Duration(
                                                                                milliseconds: 200),
                                                                            pageBuilder: (
                                                                                BuildContext buildContext,
                                                                                Animation animation,
                                                                                Animation secondaryAnimation) {
                                                                              return Center(
                                                                                child: Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            8),
                                                                                        color: AppColor
                                                                                            .backGroundColor
                                                                                    ),
                                                                                    width: isDesktop
                                                                                        ? Get
                                                                                        .width * 0.35
                                                                                        : Get
                                                                                        .height *
                                                                                        0.5,
                                                                                    height: isDesktop
                                                                                        ? Get
                                                                                        .height *
                                                                                        0.65
                                                                                        : Get
                                                                                        .height *
                                                                                        0.7,
                                                                                    padding: EdgeInsets
                                                                                        .all(20),
                                                                                    child: SingleChildScrollView(
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets
                                                                                                .all(
                                                                                                8.0),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                                  .end,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      'فیلتر',
                                                                                                      style: AppTextStyle
                                                                                                          .labelText
                                                                                                          .copyWith(
                                                                                                        fontSize: 15,
                                                                                                        fontWeight: FontWeight
                                                                                                            .normal,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 50,
                                                                                                  height: 27,
                                                                                                  child: ElevatedButton(
                                                                                                    style: ButtonStyle(
                                                                                                        padding: WidgetStatePropertyAll(
                                                                                                            EdgeInsets
                                                                                                                .symmetric(
                                                                                                                horizontal: 2,
                                                                                                                vertical: 1)),
                                                                                                        // elevation: WidgetStatePropertyAll(5),
                                                                                                        backgroundColor:
                                                                                                        WidgetStatePropertyAll(
                                                                                                            AppColor
                                                                                                                .accentColor
                                                                                                                .withAlpha(
                                                                                                                130)),
                                                                                                        shape: WidgetStatePropertyAll(
                                                                                                            RoundedRectangleBorder(
                                                                                                                side: BorderSide(
                                                                                                                    color: AppColor
                                                                                                                        .textColor),
                                                                                                                borderRadius: BorderRadius
                                                                                                                    .circular(
                                                                                                                    5)))),
                                                                                                    onPressed: () async {
                                                                                                      orderController
                                                                                                          .clearFilter();
                                                                                                      orderController
                                                                                                          .getOrderListPager();
                                                                                                      Get
                                                                                                          .back();
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      'حذف فیلتر',
                                                                                                      style: AppTextStyle
                                                                                                          .labelText
                                                                                                          .copyWith(
                                                                                                          fontSize: isDesktop
                                                                                                              ? 9
                                                                                                              : 8),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            color: AppColor
                                                                                                .textColor,
                                                                                            height: 0.2,
                                                                                          ),
                                                                                          /*Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 10),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 8),
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'فیلتر ادمین',
                                                                                  style: AppTextStyle.labelText.copyWith(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      color: AppColor.textColor),
                                                                                ),
                                                                                SizedBox(height: 10,),
                                                                                Obx(() => Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Radio<int?>(
                                                                                          value: 1,
                                                                                          groupValue: orderController.byAdmin.value,
                                                                                          onChanged: (value) {
                                                                                            orderController.checkByAdmin(value);
                                                                                          },
                                                                                          activeColor: AppColor.primaryColor,
                                                                                        ),
                                                                                        Text(
                                                                                          'ادمین',
                                                                                          style: AppTextStyle.labelText.copyWith(
                                                                                              fontSize: 11,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              color: AppColor.textColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Radio<int?>(
                                                                                          value: 0,
                                                                                          groupValue: orderController.byAdmin.value,
                                                                                          onChanged: (value) {
                                                                                            orderController.checkByAdmin(value);
                                                                                          },
                                                                                          activeColor: AppColor.primaryColor,
                                                                                        ),
                                                                                        Text(
                                                                                          'غیر ادمین',
                                                                                          style: AppTextStyle.labelText.copyWith(
                                                                                              fontSize: 11,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              color: AppColor.textColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Radio<int?>(
                                                                                          value: null,
                                                                                          groupValue: orderController.byAdmin.value,
                                                                                          onChanged: (value) {
                                                                                            orderController.checkByAdmin(value);
                                                                                          },
                                                                                          activeColor: AppColor.primaryColor,
                                                                                        ),
                                                                                        Text(
                                                                                          'همه',
                                                                                          style: AppTextStyle.labelText.copyWith(
                                                                                              fontSize: 11,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              color: AppColor.textColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ))
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 8),
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'نوع سفارش',
                                                                                  style: AppTextStyle.labelText.copyWith(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      color: AppColor.textColor),
                                                                                ),
                                                                                SizedBox(height: 10,),
                                                                                Obx(() => Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Radio<int?>(
                                                                                          value: 1,
                                                                                          groupValue: orderController.type.value,
                                                                                          onChanged: (value) {
                                                                                            orderController.checkType(value);
                                                                                          },
                                                                                          activeColor: AppColor.primaryColor,
                                                                                        ),
                                                                                        Text(
                                                                                          'خرید',
                                                                                          style: AppTextStyle.labelText.copyWith(
                                                                                              fontSize: 11,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              color: AppColor.textColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Radio<int?>(
                                                                                          value: 0,
                                                                                          groupValue: orderController.type.value,
                                                                                          onChanged: (value) {
                                                                                            orderController.checkType(value);
                                                                                          },
                                                                                          activeColor: AppColor.primaryColor,
                                                                                        ),
                                                                                        Text(
                                                                                          'فروش',
                                                                                          style: AppTextStyle.labelText.copyWith(
                                                                                              fontSize: 11,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              color: AppColor.textColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Radio<int?>(
                                                                                          value: null,
                                                                                          groupValue: orderController.type.value,
                                                                                          onChanged: (value) {
                                                                                            orderController.checkType(value);
                                                                                          },
                                                                                          activeColor: AppColor.primaryColor,
                                                                                        ),
                                                                                        Text(
                                                                                          'همه',
                                                                                          style: AppTextStyle.labelText.copyWith(
                                                                                              fontSize: 11,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              color: AppColor.textColor),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ))
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8,),
                                                                            SizedBox(
                                                                              height: 8,),
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Text(
                                                                                  'نام',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight
                                                                                          .normal,
                                                                                      color: AppColor
                                                                                          .textColor),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,),
                                                                                IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      autovalidateMode: AutovalidateMode
                                                                                          .onUserInteraction,
                                                                                      controller: orderController
                                                                                          .nameFilterController,
                                                                                      style: AppTextStyle
                                                                                          .labelText
                                                                                          .copyWith(
                                                                                          fontSize: 15),
                                                                                      textAlign: TextAlign
                                                                                          .start,
                                                                                      keyboardType: TextInputType
                                                                                          .text,
                                                                                      decoration: InputDecoration(
                                                                                        contentPadding:
                                                                                        const EdgeInsets
                                                                                            .symmetric(
                                                                                            vertical: 11,
                                                                                            horizontal: 15
                                                                                        ),
                                                                                        isDense: true,
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius:
                                                                                          BorderRadius
                                                                                              .circular(
                                                                                              6),
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

                                                                            SizedBox(
                                                                                height: 8),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Text(
                                                                                  'از تاریخ',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight
                                                                                          .normal,
                                                                                      color: AppColor
                                                                                          .textColor),
                                                                                ),
                                                                                Container(
                                                                                  //height: 50,
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      bottom: 5),
                                                                                  child: IntrinsicHeight(
                                                                                    child: TextSelectionTheme(
                                                                                      data: TextSelectionThemeData(
                                                                                        selectionColor: Colors.white.withOpacity(0.4),
                                                                                      ),
                                                                                      child: TextFormField(
                                                                                        validator: (
                                                                                            value) {
                                                                                          if (value ==
                                                                                              null ||
                                                                                              value
                                                                                                  .isEmpty) {
                                                                                            return 'لطفا تاریخ را انتخاب کنید';
                                                                                          }
                                                                                          return null;
                                                                                        },
                                                                                        controller: orderController
                                                                                            .dateStartController,
                                                                                        readOnly: true,
                                                                                        style: AppTextStyle
                                                                                            .labelText,
                                                                                        decoration: InputDecoration(
                                                                                          suffixIcon: Icon(
                                                                                              Icons
                                                                                                  .calendar_month,
                                                                                              color: AppColor
                                                                                                  .textColor),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius
                                                                                                .circular(
                                                                                                10),
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
                                                                                                1400,
                                                                                                1,
                                                                                                1),
                                                                                            lastDate: Jalali(
                                                                                                1450,
                                                                                                12,
                                                                                                29),
                                                                                            initialEntryMode: PersianDatePickerEntryMode
                                                                                                .calendar,
                                                                                            initialDatePickerMode: PersianDatePickerMode
                                                                                                .day,
                                                                                            locale: Locale(
                                                                                                "fa",
                                                                                                "IR"),
                                                                                          );
                                                                                          Gregorian gregorian = pickedDate!
                                                                                              .toGregorian();
                                                                                          orderController
                                                                                              .startDateFilter
                                                                                              .value =
                                                                                          "${gregorian
                                                                                              .year}-${gregorian
                                                                                              .month
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}-${gregorian
                                                                                              .day
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}";

                                                                                          orderController
                                                                                              .dateStartController
                                                                                              .text =
                                                                                          "${pickedDate
                                                                                              .year}/${pickedDate
                                                                                              .month
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}/${pickedDate
                                                                                              .day
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}";
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                                height: 8),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Text(
                                                                                  'تا تاریخ',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight
                                                                                          .normal,
                                                                                      color: AppColor
                                                                                          .textColor),
                                                                                ),
                                                                                Container(
                                                                                  //height: 50,
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      bottom: 5),
                                                                                  child: IntrinsicHeight(
                                                                                    child: TextSelectionTheme(
                                                                                      data: TextSelectionThemeData(
                                                                                        selectionColor: Colors.white.withOpacity(0.4),
                                                                                      ),
                                                                                      child: TextFormField(
                                                                                        validator: (
                                                                                            value) {
                                                                                          if (value ==
                                                                                              null ||
                                                                                              value
                                                                                                  .isEmpty) {
                                                                                            return 'لطفا تاریخ را انتخاب کنید';
                                                                                          }
                                                                                          return null;
                                                                                        },
                                                                                        controller: orderController
                                                                                            .dateEndController,
                                                                                        readOnly: true,
                                                                                        style: AppTextStyle
                                                                                            .labelText,
                                                                                        decoration: InputDecoration(
                                                                                          suffixIcon: Icon(
                                                                                              Icons
                                                                                                  .calendar_month,
                                                                                              color: AppColor
                                                                                                  .textColor),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius
                                                                                                .circular(
                                                                                                10),
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
                                                                                                1400,
                                                                                                1,
                                                                                                1),
                                                                                            lastDate: Jalali(
                                                                                                1450,
                                                                                                12,
                                                                                                29),
                                                                                            initialEntryMode: PersianDatePickerEntryMode
                                                                                                .calendar,
                                                                                            initialDatePickerMode: PersianDatePickerMode
                                                                                                .day,
                                                                                            locale: Locale(
                                                                                                "fa",
                                                                                                "IR"),
                                                                                          );
                                                                                          // DateTime date=DateTime.now();
                                                                                          Gregorian gregorian = pickedDate!
                                                                                              .toGregorian();
                                                                                          orderController
                                                                                              .endDateFilter
                                                                                              .value =
                                                                                          "${gregorian
                                                                                              .year}-${gregorian
                                                                                              .month
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}-${gregorian
                                                                                              .day
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}";

                                                                                          orderController
                                                                                              .dateEndController
                                                                                              .text =
                                                                                          "${pickedDate
                                                                                              .year}/${pickedDate
                                                                                              .month
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}/${pickedDate
                                                                                              .day
                                                                                              .toString()
                                                                                              .padLeft(
                                                                                              2,
                                                                                              '0')}";
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),*/
                                                                                          OrderFilterWidget(
                                                                                            orderController: orderController,
                                                                                          ),
                                                                                          //  Spacer(),
                                                                                          Container(
                                                                                            margin: EdgeInsets
                                                                                                .symmetric(
                                                                                                horizontal: 20,
                                                                                                vertical: 10),
                                                                                            width: double
                                                                                                .infinity,
                                                                                            height: 40,
                                                                                            child: ElevatedButton(
                                                                                              style: ButtonStyle(
                                                                                                  padding: WidgetStatePropertyAll(
                                                                                                      EdgeInsets
                                                                                                          .symmetric(
                                                                                                          horizontal: 23,
                                                                                                          )),
                                                                                                  // elevation: WidgetStatePropertyAll(5),
                                                                                                  backgroundColor:
                                                                                                  WidgetStatePropertyAll(
                                                                                                      AppColor
                                                                                                          .appBarColor),
                                                                                                  shape: WidgetStatePropertyAll(
                                                                                                      RoundedRectangleBorder(
                                                                                                          side: BorderSide(
                                                                                                              color: AppColor
                                                                                                                  .textColor),
                                                                                                          borderRadius: BorderRadius
                                                                                                              .circular(
                                                                                                              5)))),
                                                                                              onPressed: () async {
                                                                                                orderController
                                                                                                    .getOrderListPager();
                                                                                                Get
                                                                                                    .back();
                                                                                              },
                                                                                              child: orderController
                                                                                                  .isLoading
                                                                                                  .value
                                                                                                  ?
                                                                                              CircularProgressIndicator(
                                                                                                valueColor: AlwaysStoppedAnimation<
                                                                                                    Color>(
                                                                                                    AppColor
                                                                                                        .textColor),
                                                                                              )
                                                                                                  :
                                                                                              Text(
                                                                                                'فیلتر',
                                                                                                style: AppTextStyle
                                                                                                    .labelText
                                                                                                    .copyWith(
                                                                                                    fontSize: isDesktop
                                                                                                        ? 12
                                                                                                        : 10),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      label: Text(
                                                                        'فیلتر',
                                                                        style: AppTextStyle
                                                                            .labelText
                                                                            .copyWith(
                                                                            fontSize: isDesktop
                                                                                ? 12
                                                                                : 10,
                                                                            color: orderController
                                                                                .nameFilterController
                                                                                .text != "" ||
                                                                                orderController
                                                                                    .mobileFilterController
                                                                                    .text !=
                                                                                    "" ||
                                                                                orderController
                                                                                    .dateStartController
                                                                                    .text !=
                                                                                    "" ||
                                                                                orderController
                                                                                    .dateEndController
                                                                                    .text != ""||
                                                                                orderController.byAdmin.value != null||
                                                                                orderController.type.value != null ||
                                                                                orderController.selectedItemFilter.value !=null
                                                                                ? AppColor
                                                                                .accentColor
                                                                                : AppColor
                                                                                .textColor),
                                                                      ),
                                                                      icon: SvgPicture.asset(
                                                                          'assets/svg/filter3.svg',
                                                                          height: 22,
                                                                          colorFilter:
                                                                          ColorFilter
                                                                              .mode(
                                                                            orderController
                                                                                .nameFilterController
                                                                                .text != "" ||
                                                                                orderController
                                                                                    .mobileFilterController
                                                                                    .text !=
                                                                                    "" ||
                                                                                orderController
                                                                                    .dateStartController
                                                                                    .text !=
                                                                                    "" ||
                                                                                orderController
                                                                                    .dateEndController
                                                                                    .text != "" ||
                                                                                orderController.byAdmin.value != null ||
                                                                                orderController.type.value != null ||
                                                                                orderController.selectedItemFilter.value !=null
                                                                                ? AppColor
                                                                                .accentColor
                                                                                : AppColor
                                                                                .textColor,
                                                                            BlendMode
                                                                                .srcIn,
                                                                          )),
                                                                    ),
                                                                    // تبدیل واحد
                                                                    const SizedBox(width: 12),
                                                                    Tooltip(
                                                                      message: 'تبدیل واحد',
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          showItemWeightCalculatorDialog(
                                                                            context: context,
                                                                            items: orderController.itemList,
                                                                            mesghalPriceNotifier: orderController.mesghalPriceNotifier,
                                                                            onChange: (result) {
                                                                              // Handle real-time changes if needed
                                                                              debugPrint('Total weight: ${result.totalWeight}g');
                                                                            },
                                                                            onConfirm: (result) {
                                                                              // Handle confirmation
                                                                              debugPrint('Confirmed - Total weight: ${result.totalWeight}g');
                                                                              for (var item in result.selectedItems) {
                                                                                debugPrint('${item.name}: ${item.count} x ${item.weight}g = ${item.totalItemWeight}g');
                                                                              }
                                                                            },
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          padding: const EdgeInsets.all(6),
                                                                          decoration: BoxDecoration(
                                                                            color: AppColor.buttonColor.withOpacity(0.15),
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            border: Border.all(
                                                                              color: AppColor.buttonColor.withOpacity(0.3),
                                                                            ),
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.scale_rounded,
                                                                                size: 20,
                                                                                color: AppColor.buttonColor,
                                                                              ),
                                                                              const SizedBox(width: 6),
                                                                              Text(
                                                                                'تبدیل واحد',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                  color: AppColor.buttonColor,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DataTable(
                                                            sortColumnIndex: orderController.sortColumnIndex.value,
                                                            sortAscending: orderController.sortAscending.value,
                                                            columns: buildDataColumns(),
                                                            rows: buildDataRows(context),
                                                            decoration: BoxDecoration(color: AppColor.backGroundColor),
                                                            dataRowMaxHeight: double.infinity,
                                                            dividerThickness: 0.3,
                                                            border: TableBorder.symmetric(
                                                              inside: BorderSide(color: AppColor.secondary200Color, width: 0.3),
                                                              outside: BorderSide(color: AppColor.secondary200Color, width: 0.3),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                            headingRowHeight: 35,
                                                            headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                                            columnSpacing: 30,
                                                            horizontalMargin: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 50,)
                                        ],
                                      ),
                                    ),
                                  ) :
                      
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child:
                                        Column(
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: orderController.orderList.length,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final orders = orderController.orderList[index];
                                                return  Container(
                                                    margin: const EdgeInsets.only(bottom: 12),
                                                    padding: const EdgeInsets.only(top: 5,right: 15,left: 15,bottom: 12),
                                                    decoration: BoxDecoration(
                                                      color: AppColor.secondaryColor.withAlpha(180),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(color: const Color(0xFF64748B)),
                                                    ),
                                                    child:
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // تاریخ سفارش
                                                                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                           Row(
                                                                             children: [
                                                                               Text(
                                                                                  "${orders.rowNum ?? 0}",
                                                                                  style: AppTextStyle.bodyText.copyWith(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                               SizedBox(width: 5,),
                                                                               orders.byAdmin==true ?
                                                                                   Column(
                                                                                     children: [
                                                                                       Text('ادمین', style: AppTextStyle.labelText.copyWith(
                                                                                       fontSize: 11,
                                                                                         fontWeight: FontWeight.bold,color: AppColor.primaryColor
                                                                                       ),
                                                                                       ),
                                                                                       Text(
                                                                                         (orders.createdBy?.name?.length ?? 0) > 10 ?
                                                                                         "${orders.createdBy?.name?.substring(0 , 10)}..." :
                                                                                         orders.createdBy?.name ?? "",
                                                                                         style: AppTextStyle.bodyText.copyWith(fontSize: 10, color: AppColor.primaryColor ),
                                                                                       ),
                                                                                     ],
                                                                                   ):
                                                                               Text('غیرادمین', style: AppTextStyle.labelText.copyWith(
                                                                                   fontSize: 11,
                                                                                   fontWeight: FontWeight.bold,color: AppColor.accentColor
                                                                               ),),
                                                                             ],
                                                                           ),
                                                                           funcOrderDetail(
                                                                              '',
                                                                              orders.date
                                                                                  ?.toPersianDate(
                                                                                  twoDigits: true,
                                                                                  showTime: true,
                                                                                  timeSeprator: '-') ??
                                                                                  "نامشخص",size: 11

                                                                            ),
                                                                           GestureDetector(
                                                                             onTap: () {
                                                                               showDialog(
                                                                                 context: context,
                                                                                 builder: (context) {
                                                                                   return AlertDialog(
                                                                                     title: const Text('نام کامل کاربر'),
                                                                                     content: Text(
                                                                                       "${orders.account?.name}" "(${orders.account?.accountLevel?.name})",
                                                                                       style: const TextStyle(fontSize: 14),
                                                                                     ),
                                                                                     actions: [
                                                                                       TextButton(
                                                                                         onPressed: () => Navigator.pop(context),
                                                                                         child: const Text('بستن'),
                                                                                       ),
                                                                                     ],
                                                                                   );
                                                                                 },
                                                                               );
                                                                             },
                                                                             child: funcOrderDetail(
                                                                                'کاربر:',
                                                                                 (orders.account?.name?.length ?? 0) > 11 ?
                                                                                 "${orders.account?.name?.substring(0 , 11)}..." "(${orders.account?.accountLevel?.name})" :
                                                                                 "${orders.account?.name} " "(${orders.account?.accountLevel?.name})", size: 11
                                                                              ),
                                                                           ),
                                                                        ],
                                                                      ),
                                                                SizedBox(height: 5,),
                                                                Divider(color: AppColor.iconViewColor, height: 2,),
                                                                SizedBox(height: 5,),
                                                                // محصول
                                                                Container(
                                                                  margin: const EdgeInsets.all(5),
                                                                  padding: const EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(
                                                                    color:orders.type==0 ? AppColor.accentColor.withAlpha(30) :  AppColor.primaryColor.withAlpha(30),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border: Border.all(color: const Color(0xFF64748B)),
                                                                  ),
                                                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Expanded(
                                                                        child: funcOrderDetail(
                                                                          'محصول:',
                                                                          orders.item?.name ??
                                                                              "نامشخص",color: orders.type==0 ? AppColor.accentColor : AppColor.primaryColor,size: 13
                                                                        ),
                                                                      ),
                                                                      //مقدار سفارش
                                                                      Expanded(
                                                                        child: funcOrderDetail(
                                                                          'مقدار سفارش:',
                                                                          "${orders.quantity?.toDisplayString().seRagham(separator: ",")} ${orders.item?.itemUnit?.name ?? ""}",
                                                                          color: (orders.type == 0)
                                                                              ? AppColor.accentColor
                                                                              : AppColor.primaryColor,size: 13
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.all(5),
                                                                  padding: const EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColor.dividerColor.withAlpha(30),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border: Border.all(color: const Color(0xFF64748B)),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          //قیمت مثقال
                                                                          Expanded(
                                                                            child: funcOrderDetail(
                                                                              'مثقال:',
                                                                              (orders.mesghalPrice != null)
                                                                                  ? "${orders.mesghalPrice
                                                                                  ?.toInt()
                                                                                  .toString()
                                                                                  .seRagham(
                                                                                  separator: ',')} ریال"
                                                                                  : "0",color: AppColor.textPrimaryColor,size: 11
                                                                            ),
                                                                          ),
                                                                          //قیمت ریال
                                                                          Expanded(
                                                                            child: funcOrderDetail(
                                                                              'قیمت (ریال):',
                                                                              (orders.price != null)
                                                                                  ? "${orders.price
                                                                                  ?.toInt()
                                                                                  .toString()
                                                                                  .seRagham(
                                                                                  separator: ',')}"
                                                                                  : "0",color: AppColor.textPrimaryColor,size: 11
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 5,),
                                                                      // مبلغ کل
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                'مبلغ کل: ',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                  color: const Color(0xFF94A3B8),
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                (orders.totalPrice != null)
                                                                                    ? "${orders.totalPrice?.toInt().toString().seRagham(separator: ',')} ریال" : "0",
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                  fontSize: 12,color: AppColor.dividerColor),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Tooltip(
                                                                            message: "کارتخوان",
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(Icons.credit_card,size:20,color: orders.isCard==true ? AppColor.primaryColor : AppColor.textColor.withAlpha(50),)
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: 7,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    //دکمه ادیت جزئیات سفارش
                                                                    Row(
                                                                      children: [
                                                                        orders.status==1?
                                                                        GestureDetector(
                                                                          //onTap: () { Get.toNamed('/orderUpdate', parameters: {"id": orders.id.toString()});},
                                                                          onTap: () {
                                                                            Get.dialog(
                                                                              OrderUpdateDialogWidget(orderId: orders.id ?? 0),
                                                                              barrierDismissible: false,
                                                                            );
                                                                          },
                                                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.dividerColor.withAlpha(40)),
                                                                              padding: EdgeInsets.all(5),
                                                                              child: SvgPicture.asset('assets/svg/edit.svg', height: 25, colorFilter: ColorFilter.mode(AppColor.dividerColor.withAlpha(200), BlendMode.srcIn))),
                                                                        ):
                                                                        SizedBox.shrink(),
                                                                        SizedBox(width: 12,),
                                                                        //دکمه حذف سفارش
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            Get.defaultDialog(
                                                                                backgroundColor: AppColor.backGroundColor,
                                                                                title: "حذف سفارش",
                                                                                titleStyle: AppTextStyle.smallTitleText,
                                                                                middleText: "آیا از حذف سفارش مطمئن هستید؟",
                                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                                confirm: ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                            AppColor.primaryColor)),
                                                                                    onPressed: () {
                                                                                      //Get.back();
                                                                                      orderController.deleteOrder(
                                                                                          orders.id ?? 0, true);
                                                                                      //orderController.fetchOrderList();
                                                                                      //Get.back();
                                                                                    },
                                                                                    child: Text(
                                                                                      'حذف',
                                                                                      style: AppTextStyle.bodyText,
                                                                                    )));
                                                                          },
                                                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.accentColor.withAlpha(40)),
                                                                              padding: EdgeInsets.all(5),
                                                                              child: SvgPicture.asset('assets/svg/trash-bin.svg', height: 25, colorFilter: ColorFilter.mode(AppColor.accentColor.withAlpha(200), BlendMode.srcIn))),
                                                                        ),
                                                                        SizedBox(width: 12,),
                                                                        // ارسال تلگرام
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            await orderController.checkAccountSocialStatus(orders.account?.id ?? 0);
                                                                            if (orderController.socialStatus.value != null) {
                                                                              Get.defaultDialog(
                                                                                  backgroundColor: AppColor.backGroundColor,
                                                                                  title: "ارسال سفارش",
                                                                                  titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                  middleText: "آیا از ارسال سفارش مطمئن هستید؟",
                                                                                  middleTextStyle: AppTextStyle.bodyText,
                                                                                  confirm:
                                                                                  Obx(() {
                                                                                    final status = orderController.socialStatus.value;
                                                                                    final hasTelegram = status?.telegramStatus == true;
                                                                                    final hasWhatsApp = status?.whatsappStatus == true;

                                                                                    if (!hasTelegram && !hasWhatsApp) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.all(16.0),
                                                                                        child: Text(
                                                                                          'هیچ کانال ارتباطی فعال نیست',
                                                                                          style: AppTextStyle.bodyText.copyWith(
                                                                                            color: AppColor.errorColor,
                                                                                            fontSize: 13,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        if (hasTelegram)
                                                                                          GestureDetector(
                                                                                            onTap: () async {
                                                                                              Get.back();
                                                                                              await orderController.sendTelegramOrder(orders.id ?? 0);
                                                                                            },
                                                                                            child: Tooltip(
                                                                                              message: orders.isSendTelegram == true ?  "ارسال مجدد سفارش به تلگرام" : "ارسال سفارش به تلگرام",
                                                                                              child: SvgPicture.asset(
                                                                                                'assets/svg/telegram.svg',height: 24,
                                                                                                colorFilter: ColorFilter.mode(orders.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        if (hasWhatsApp)
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              // TODO: Implement WhatsApp send logic
                                                                                              Get.back();
                                                                                            },
                                                                                            child: Tooltip(
                                                                                              message: orders.isSendWhatsapp == true ?  "ارسال مجدد سفارش به واتس آپ" : "ارسال سفارش به واتس آپ",
                                                                                              child: SvgPicture.asset(orders.isSendWhatsapp == true ? 'assets/svg/whatsapp1.svg' : 'assets/svg/whatsapp.svg',height: 24,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                      ],
                                                                                    );
                                                                                  })
                                                                              );
                                                                            }
                                                                          },
                                                                          child: Tooltip(
                                                                            message: "ارسال سفارش",
                                                                            child: SvgPicture.asset(
                                                                              'assets/svg/send.svg',height: 25,
                                                                              colorFilter: ColorFilter.mode(AppColor.secondary3Color , BlendMode.srcIn) ,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        /*GestureDetector(
                                                                          onTap: () {
                                                                            orders.isSendTelegram == true ?
                                                                            Get.defaultDialog(
                                                                                backgroundColor: AppColor.backGroundColor,
                                                                                title: "ارسال مجدد",
                                                                                titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                                                middleText: "آیا از ارسال مجدد سفارش مطمئن هستید؟",
                                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                                confirm: ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                            AppColor.primaryColor)),
                                                                                    onPressed: () {
                                                                                      Get.back();
                                                                                      orderController.sendTelegramOrder(orders.id ?? 0);
                                                                                    },
                                                                                    child: Text(
                                                                                      'ارسال مجدد',
                                                                                      style: AppTextStyle.bodyText,
                                                                                    ))
                                                                            ) :
                                                                            Get.defaultDialog(
                                                                                backgroundColor: AppColor.backGroundColor,
                                                                                title: "ارسال به تلگرام",
                                                                                titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                middleText: "آیا از ارسال سفارش مطمئن هستید؟",
                                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                                confirm: ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                            AppColor.primaryColor)),
                                                                                    onPressed: () {
                                                                                      Get.back();
                                                                                      orderController.sendTelegramOrder(orders.id ?? 0);
                                                                                    },
                                                                                    child: Text(
                                                                                      'ارسال',
                                                                                      style: AppTextStyle.bodyText,
                                                                                    ))
                                                                            );
                                                                          },
                                                                          child: Tooltip(
                                                                            message: orders.isSendTelegram == true ?  "ارسال مجدد سفارش به تلگرام" : "ارسال سفارش به تلگرام",
                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                //Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: order.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                                                SvgPicture.asset(
                                                                                  'assets/svg/telegram.svg',height: 25,
                                                                                  colorFilter: ColorFilter.mode(orders.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),*/
                                                                      ],
                                                                    ),
                                                                    /*orders.status == 1
                                                                        ? funcOrderDetail('', "تایید شده",
                                                                        color: AppColor.primaryColor,size: 10
                                                                    )
                                                                        : funcOrderDetail('', "تایید نشده",
                                                                        color: AppColor.accentColor,size: 10
                                                                    ),*/
                                                                    //دکمه تایید سفارش در جزئیات
                                                                    // Row(
                                                                    //   children: [
                                                                    //     GestureDetector(
                                                                    //       onTap: () {
                                                                    //         Get.defaultDialog(
                                                                    //             backgroundColor: AppColor.backGroundColor,
                                                                    //             title: "تایید سفارش",
                                                                    //             titleStyle: AppTextStyle.smallTitleText,
                                                                    //             middleText: "آیا از تایید سفارش مطمئن هستید؟",
                                                                    //             middleTextStyle: AppTextStyle.bodyText,
                                                                    //             confirm: ElevatedButton(
                                                                    //                 style: ButtonStyle(
                                                                    //                     backgroundColor: WidgetStatePropertyAll(
                                                                    //                         AppColor.primaryColor)),
                                                                    //                 onPressed: () {
                                                                    //                   //Get.back();
                                                                    //                   orderController.updateStatusOrder(orders.id ?? 0, 1);
                                                                    //                   //orderController.getOrderListPager();
                                                                    //                   //Get.back();
                                                                    //                 },
                                                                    //                 child: Text(
                                                                    //                   'تایید',
                                                                    //                   style: AppTextStyle.bodyText,
                                                                    //                 )));
                                                                    //       },
                                                                    //       child: SvgPicture.asset('assets/svg/check-mark-circle.svg', height: 30, colorFilter: ColorFilter.mode(AppColor.primaryColor.withAlpha(200), BlendMode.srcIn)),
                                                                    //     ),
                                                                    //     SizedBox(
                                                                    //       width: 5,
                                                                    //     ),
                                                                    //     //دکمه رد سفارش در جزئیات
                                                                    //     GestureDetector(
                                                                    //       onTap: () {
                                                                    //         Get.defaultDialog(
                                                                    //             backgroundColor: AppColor.backGroundColor,
                                                                    //             title: "رد سفارش",
                                                                    //             titleStyle: AppTextStyle.smallTitleText,
                                                                    //             middleTextStyle: AppTextStyle.bodyText,
                                                                    //             middleText: "آیا از رد سفارش مطمئن هستید؟",
                                                                    //             confirm: ElevatedButton(
                                                                    //                 style: ButtonStyle(
                                                                    //                     backgroundColor: WidgetStatePropertyAll(
                                                                    //                         AppColor.accentColor)),
                                                                    //                 onPressed: () {
                                                                    //                   //Get.back();
                                                                    //                   orderController.updateStatusOrder(
                                                                    //                       orders.id ?? 0, 2);
                                                                    //                   //orderController.getOrderListPager();
                                                                    //                   // Get.back();
                                                                    //                 },
                                                                    //                 child: Text(
                                                                    //                   'رد',
                                                                    //                   style: AppTextStyle.bodyText,
                                                                    //                 )));
                                                                    //       },
                                                                    //       child: SvgPicture.asset('assets/svg/close-circle1.svg', height: 30, colorFilter: ColorFilter.mode(AppColor.accentColor.withAlpha(200), BlendMode.srcIn)),
                                                                    //     ),
                                                                    //   ],
                                                                    // ),
                                                                    //دکمه تایید سفارش در جزئیات
                                                                    Transform.scale(
                                                                      scale: 0.85,
                                                                      child: Switch(
                                                                        value: orders.status == 1,
                                                                        onChanged: (value) {
                                                                          final newStatus = value ? 1 : 2;
                                                                          orderController.updateStatusOrder(orders.id ?? 0, newStatus);
                                                                        },
                                                                        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                                          if (states.contains(WidgetState.disabled)) {
                                                                            return AppColor.dividerColor;
                                                                          }
                                                                          return orders.status == 1
                                                                              ? AppColor.successColor
                                                                              : AppColor.accentColor;
                                                                        }),
                                                                        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                                          if (states.contains(WidgetState.disabled)) {
                                                                            return AppColor.dividerColor.withOpacity(0.4);
                                                                          }
                                                                          return orders.status == 1
                                                                              ? AppColor.successColor.withOpacity(0.4)
                                                                              : AppColor.accentColor.withOpacity(0.4);
                                                                        }),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                  );
                                              },
                                            ),
                                            Obx(() {
                                              if (orderController.isLoading.value && orderController.orderList.isNotEmpty) {
                                                return Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                );
                                              }

                                              if (!orderController.hasMore.value && orderController.orderList.isNotEmpty) {
                                                return Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: Text(
                                                    "همه تراکنش‌ها نمایش داده شد",
                                                    textAlign: TextAlign.center,
                                                    style: AppTextStyle.bodyText.copyWith(
                                                      color: AppColor.textColor.withOpacity(0.7),
                                                    ),
                                                  ),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            }),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                  );
                              }

                              return ErrPage(
                                callback: () {
                                  orderController.clearFilter();
                                  orderController.getOrderListPager();
                                },
                                title: "خطا در دریافت سفارشات",
                                des: 'برای دریافت سفارشات مجددا تلاش کنید',
                              );
                            }),
                          ],
                        ),
                    ),
                  ),
                )),
            isDesktop ?
            Obx(() =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    orderController.paginated.value != null ? Container(
                        height: 70,
                        margin: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        //color: AppColor.appBarColor.withAlpha(130),
                        alignment: Alignment.bottomCenter,
                        child: PagerWidget(
                          countPage: orderController.paginated.value
                              ?.totalCount ?? 0, callBack: (int index) {
                          orderController.isChangePage(index);
                        },)) : SizedBox(),
                  ],
                ),) : SizedBox.shrink()
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

//
  Widget funcOrderDetail( String label, String value, {Color color = AppColor.textColor, double? size}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Text(
      label,
      style: AppTextStyle.labelText.copyWith(
        color: const Color(0xFF94A3B8),
        fontSize: 10,
      ),
        ),
        SizedBox(width: 3),
        Text(value,
                style: AppTextStyle.bodyText.copyWith(
                    color: color, fontSize: size,fontWeight: FontWeight.w600)),
      ],
    );
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(backgroundColor: AppColor.backGroundColor,
            title: Text('انتخاب کنید', style: AppTextStyle.smallTitleText,),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: orderController.searchedAccounts.length,
                itemBuilder: (context, index) {
                  final account = orderController.searchedAccounts[index];
                  return ListTile(
                    title: Text(account.name ?? '',
                      style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                    onTap: () => orderController.selectAccount(account),
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

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('ردیف', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('ارسال سفارش', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
        label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
            child: Text('تاریخ', style: AppTextStyle.labelText)),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          orderController.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام کاربر (سطح)', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            orderController.onSort(columnIndex, ascending);
          }
      ),
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('موبایل', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('محصول', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مقدار', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            orderController.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('قیمت(مثقال)', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            orderController.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('قیمت(ریال)', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            orderController.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مبلغ کل', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            orderController.onSort(columnIndex, ascending);
          }
      ),
      /*DataColumn(
        label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
            child: Text('اضافه مبلغ', style: AppTextStyle.labelText)),
      ),*/
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('توسط ادمین', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('کارتخوان', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('خرید/فروش', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('وضعیت', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('عملیات', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده سکه', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده ریالی', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده طلایی', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return orderController.orderList.asMap().entries.map((entry) {
      final index = entry.key;
      final order = entry.value;

      // Alternating row colors for better readability
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        //color: WidgetStateProperty.all(order.type==0 ? AppColor.accentColor.withAlpha(10) : AppColor.primaryColor.withAlpha(10)),
        color: WidgetStateProperty.all(rowColor),
        cells: [
          // ردیف
          DataCell(
              Center(
                child:
                Row(
                  children: [
                    // رجیستر
                    Checkbox(
                      value: order.registered ?? false,
                      onChanged: (value) async {
                        if (value != null) {
                          //EasyLoading.show(status: 'لطفا منتظر بمانید');
                          await orderController.updateRegistered(order.id ?? 0, value);
                        }
                      },
                    ),
                    SizedBox(width: 5,),
                    Text("${order.rowNum}",
                      style:
                      AppTextStyle.bodyText,
                    ),
                  ],
                ),
              )),
          // ارسال
          DataCell(
              Center(
                child:
                GestureDetector(
                  onTap: () async {
                    await orderController.checkAccountSocialStatus(order.account?.id ?? 0);
                    if (orderController.socialStatus.value != null) {
                      Get.defaultDialog(
                          backgroundColor: AppColor.backGroundColor,
                          title: "ارسال سفارش",
                          titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                          middleText: "آیا از ارسال سفارش مطمئن هستید؟",
                          middleTextStyle: AppTextStyle.bodyText,
                          confirm:
                          Obx(() {
                            final status = orderController.socialStatus.value;
                            final hasTelegram = status?.telegramStatus == true;
                            final hasWhatsApp = status?.whatsappStatus == true;

                            if (!hasTelegram && !hasWhatsApp) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'هیچ کانال ارتباطی فعال نیست',
                                  style: AppTextStyle.bodyText.copyWith(
                                    color: AppColor.errorColor,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }
                            return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (hasTelegram)
                                  GestureDetector(
                                    onTap: () async {
                                      Get.back();
                                      await orderController.sendTelegramOrder(order.id ?? 0);
                                    },
                                    child: Tooltip(
                                      message: order.isSendTelegram == true ?  "ارسال مجدد سفارش به تلگرام" : "ارسال سفارش به تلگرام",
                                      child: SvgPicture.asset(
                                        'assets/svg/telegram.svg',height: 24,
                                        colorFilter: ColorFilter.mode(order.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                      ),
                                    ),
                                  ),
                                if (hasWhatsApp)
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Implement WhatsApp send logic
                                      Get.back();
                                    },
                                    child: Tooltip(
                                      message: order.isSendWhatsapp == true ?  "ارسال مجدد سفارش به واتس آپ" : "ارسال سفارش به واتس آپ",
                                      child: SvgPicture.asset(order.isSendWhatsapp == true ? 'assets/svg/whatsapp1.svg' : 'assets/svg/whatsapp.svg',height: 24,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          })
                      );
                    }
                  },
                  child: Tooltip(
                    message: "ارسال سفارش",
                    child: SvgPicture.asset(
                      'assets/svg/send.svg',height: 19,
                      colorFilter: ColorFilter.mode(AppColor.secondary3Color , BlendMode.srcIn) ,
                    ),
                  ),
                ),
                /*GestureDetector(
                  onTap: () {
                    order.isSendTelegram == true ?
                    Get.defaultDialog(
                        backgroundColor: AppColor.backGroundColor,
                        title: "ارسال مجدد",
                        titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                        middleText: "آیا از ارسال مجدد سفارش مطمئن هستید؟",
                        middleTextStyle: AppTextStyle.bodyText,
                        confirm: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColor.primaryColor)),
                            onPressed: () {
                              Get.back();
                              orderController.sendTelegramOrder(order.id ?? 0);
                            },
                            child: Text(
                              'ارسال مجدد',
                              style: AppTextStyle.bodyText,
                            ))
                    ) :
                    Get.defaultDialog(
                        backgroundColor: AppColor.backGroundColor,
                        title: "ارسال به تلگرام",
                        titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                        middleText: "آیا از ارسال سفارش مطمئن هستید؟",
                        middleTextStyle: AppTextStyle.bodyText,
                        confirm: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColor.primaryColor)),
                            onPressed: () {
                              Get.back();
                              orderController.sendTelegramOrder(order.id ?? 0);
                            },
                            child: Text(
                              'ارسال',
                              style: AppTextStyle.bodyText,
                            ))
                    );
                  },
                  child: Tooltip(
                    message: order.isSendTelegram == true ?  "ارسال مجدد سفارش به تلگرام" : "ارسال سفارش به تلگرام",
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: order.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                        SvgPicture.asset(
                          'assets/svg/telegram.svg',height: 24,
                          colorFilter: ColorFilter.mode(order.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                        ),
                      ],
                    ),
                  ),
                ),*/
              )
          ),
          // تاریخ
          DataCell(
              Center(
                child: Text(
                  order.date != null ? order.date?.toPersianDate(
                      twoDigits: true, showTime: true, timeSeprator: '-') ?? ''
                      : 'تاریخ نامشخص',
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),
              )),
          // نام کاربر
          DataCell(
              Center(
                /*child: Text(
                  order.account?.name ?? "",
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),*/
                child: order.account?.id != null
                    ? HoverTooltipBalanceWidget(
                  key: ValueKey('tooltip_${order.account?.id}_${orderController.refreshCounter.value}'),
                  isNegative:order.account?.isNegative ?? false,
                  accountId: order.account?.id ?? 0,
                  accountName: "${order.account?.name} (${order.account?.accountLevel?.name})",
                  orderController: orderController,
                )
                    : Row(
                      children: [
                        Text(
                          order.account?.name ?? "",
                          style: AppTextStyle.bodyText.copyWith(fontSize: 12, color: order.account?.isNegative==true ? AppColor.errorColor : AppColor.textColor ),
                        ),
                        Text(
                          " (${order.account?.accountLevel?.name})",
                          style: AppTextStyle.bodyText.copyWith(fontSize: 12,),
                        ),
                      ],
                    ),
              )),
          // موبایل
          /*DataCell(
              Center(
                child: Text(
                  order.account?.contactInfo ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),*/
          // محصول
          DataCell(
              Container(
                //height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (order.type == 0)
                      ? AppColor.accentColor.withAlpha(120)
                      : AppColor.primaryColor.withAlpha(120),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child:
                  Row(
                    children: [
                      Image.network('${BaseUrl
                          .baseUrl}Attachment/downloadResource?fileName=${order
                          .item?.icon}',
                        width: 25,
                        height: 25,),
                      SizedBox(width: 5,),
                      Text(
                        order.item?.name ?? "",
                        style:
                        AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.bold,color: AppColor.textColor),
                      ),
                    ],
                  ),
              )),
          // مقدار
          DataCell(
              Center(
                child: Text(
                  "${order.quantity?.toDisplayString().seRagham(
                      separator: ",")} ${order.item?.itemUnit?.name ?? ""}",
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),
              )),
          // قیمت مثقال
          DataCell(
            Center(
              child: Text(
                "${order.mesghalPrice == null ? 0 : order.mesghalPrice?.toInt()
                    .toString()
                    .seRagham(separator: ',')} ریال",
                style:
                AppTextStyle.bodyText.copyWith(fontSize: 11),
              ),
            ),
          ),
          // قیمت ریال
          DataCell(
            Center(
              child: Text(
                "${order.price == null ? 0 : order.price?.toInt()
                    .toString()
                    .seRagham(separator: ',')} ریال",
                style:
                AppTextStyle.bodyText.copyWith(fontSize: 11),
              ),
            ),
          ),
          //مبلغ کل
          DataCell(
            Center(
              child: Text(
                (order.totalPrice != null)
                    ? "${order.totalPrice?.toInt().toString().seRagham(
                    separator: ',')} ریال"
                    : "0",
                style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // اضافه مبلغ
          /*DataCell(
              Center(
                child: Text(
                  "${order.extraAmount?.toString().seRagham(separator: ",") ??
                      0}",
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),
              )),*/
          // توسط ادمین
          DataCell(
              Center(
                child:
                order.byAdmin==true ?
                Column(
                  children: [
                    SvgPicture.asset('assets/svg/shield-check.svg',height: 20,
                        colorFilter: ColorFilter.mode(
                          AppColor.primaryColor,
                          BlendMode.srcIn,
                        ),),
                    Text(
                      order.createdBy?.name ?? "",
                      style: AppTextStyle.bodyText.copyWith(fontSize: 10, color: AppColor.primaryColor , fontWeight: FontWeight.w400 ),
                    ),
                  ],
                ) :
                SvgPicture.asset('assets/svg/shield-close.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    ),),
              )),
          // کارتخوان
          DataCell(
              Center(
                child:
                order.isCard==true ?
                SvgPicture.asset('assets/svg/check-mark-circle.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.primaryColor,
                      BlendMode.srcIn,
                    )) :
                SvgPicture.asset('assets/svg/close-circle1.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
              )),
          // خرید/فروش
          /*DataCell(
            Center(
              child: Container(
                height: 25,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (order.type == 0)
                      ? AppColor.accentColor
                      : AppColor.secondary2Color,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                child: Text(
                    (order.type == 0)
                        ? 'فروش'
                        : 'خرید',
                    style: TextStyle(color: AppColor.textColor, fontSize: 10),
                    textAlign: TextAlign.center),
              ),
            ),
          ),*/
          // وضعیت
          DataCell(
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 5),
            //   child: Center(
            //     child: Column(
            //       children: [
            //         SizedBox(height: 5,),
            //         Text(
            //           '${order.status == 0 ? 'در انتظار' : order.status == 1
            //               ? 'تایید شده'
            //               : 'تایید نشده'} ',
            //           style: AppTextStyle
            //               .bodyText.copyWith(
            //               color: order.status == 1
            //                   ? AppColor.primaryColor
            //                   : order.status == 2
            //                   ? AppColor.accentColor
            //                   : AppColor.textColor, fontSize: 11
            //           ),
            //         ),
            //         SizedBox(height: 6,),
            //         // دکمه تایید و رد سفارش
            //         Row(
            //           children: [
            //             //دکمه تایید سفارش در جزئیات
            //             GestureDetector(
            //               onTap: () {
            //                 Get.defaultDialog(
            //                     backgroundColor: AppColor.backGroundColor,
            //                     title: "تایید سفارش",
            //                     titleStyle: AppTextStyle.smallTitleText,
            //                     middleText: "آیا از تایید سفارش مطمئن هستید؟",
            //                     middleTextStyle: AppTextStyle.bodyText,
            //                     confirm: ElevatedButton(
            //                         style: ButtonStyle(
            //                             backgroundColor: WidgetStatePropertyAll(
            //                                 AppColor.primaryColor)),
            //                         onPressed: () {
            //                           orderController.updateStatusOrder(order.id ?? 0, 1);
            //                           Get.back();
            //                           //orderController.fetchOrderList();
            //                         },
            //                         child: Text(
            //                           'تایید',
            //                           style: AppTextStyle.labelText,
            //                         )));
            //               },
            //               child: Container(
            //                 alignment: Alignment.center,
            //                 height: 25,
            //                 width: 45,
            //                 //  padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2.5),
            //                 /*height: 23,
            //                   width: 40,*/
            //                 //alignment: Alignment(0.3, 0),
            //                 decoration: BoxDecoration(
            //                     border: Border.all(
            //                         color: AppColor.primaryColor),
            //                     borderRadius: BorderRadius.circular(5),
            //                     color: AppColor.primaryColor
            //                 ),
            //                 child: Text(
            //                   'تایید',
            //                   style: AppTextStyle.bodyText.copyWith(
            //                       fontSize: 11, color: AppColor.textColor),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ),
            //             SizedBox(width: 7,),
            //             //دکمه رد سفارش در جزئیات
            //             GestureDetector(
            //               onTap: () {
            //                 Get.defaultDialog(
            //                     backgroundColor: AppColor.backGroundColor,
            //                     title: "رد سفارش",
            //                     titleStyle: AppTextStyle.smallTitleText,
            //                     middleTextStyle: AppTextStyle.bodyText,
            //                     middleText: "آیا از رد سفارش مطمئن هستید؟",
            //                     confirm: ElevatedButton(
            //                         style: ButtonStyle(
            //                             backgroundColor: WidgetStatePropertyAll(
            //                                 AppColor.accentColor)),
            //                         onPressed: () {
            //                           orderController.updateStatusOrder(order.id ?? 0, 2);
            //                           Get.back();
            //                           //orderController.fetchOrderList();
            //
            //                         },
            //                         child: Text(
            //                             ' رد ',
            //                             style: AppTextStyle.bodyText,
            //                             textAlign: TextAlign.center
            //                         )));
            //               },
            //               child: Container(
            //                 height: 25,
            //                 width: 45,
            //                 //  padding: EdgeInsets.symmetric(horizontal: 11,vertical: 2.6),
            //                 alignment: Alignment.center,
            //                 decoration: BoxDecoration(
            //                     border: Border.all(color: AppColor.accentColor),
            //                     borderRadius: BorderRadius.circular(5),
            //                     color: AppColor.accentColor
            //                 ),
            //                 child: Text('رد',
            //                   style: AppTextStyle.bodyText.copyWith(
            //                       fontSize: 11, color: AppColor.textColor),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ),
            Center(
              child: Transform.scale(
                scale: 0.80,
                child: Switch(
                  value: order.status == 1,
                  onChanged: (value) {
                    // پذیرش = 1، عدم پذیرش = 2
                    final newStatus = value ? 1 : 2;
                    orderController.updateStatusOrder(order.id ?? 0, newStatus);
                  },
                  thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppColor.dividerColor;
                    }
                    return order.status == 1
                        ? AppColor.successColor
                        : AppColor.accentColor;
                  }),
                  trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppColor.dividerColor.withAlpha(100);
                    }
                    return order.status == 1
                        ? AppColor.successColor.withAlpha(100)
                        : AppColor.accentColor.withAlpha(100);
                  }),
                ),
              ),
            ),
          ),
          // آیکون های عملیات
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 5,
                    height: 5,
                  ),
                  //دکمه حذف سفارش
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                          backgroundColor: AppColor.backGroundColor,
                          title: "حذف سفارش",
                          titleStyle: AppTextStyle.smallTitleText,
                          middleText: "آیا از حذف سفارش مطمئن هستید؟",
                          middleTextStyle: AppTextStyle.bodyText,
                          confirm: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColor.primaryColor)),
                              onPressed: () {
                                //Get.back();
                                orderController.deleteOrder(order.id ?? 0, true);
                                //orderController.fetchOrderList();
                                //Get.back();
                              },
                              child: Text(
                                'حذف',
                                style: AppTextStyle.bodyText,
                              )));
                    },
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.accentColor.withAlpha(40)),
                        padding: EdgeInsets.all(5),
                        child: SvgPicture.asset('assets/svg/trash-bin.svg', height: 19, colorFilter: ColorFilter.mode(AppColor.accentColor.withAlpha(200), BlendMode.srcIn))),
                  ),
                  SizedBox(width: 15,),
                  //دکمه ادیت جزئیات سفارش
                  order.status==1 ?
                  GestureDetector(
                    //onTap: () { Get.toNamed('/orderUpdate', parameters: {"id": order.id.toString()});},
                    onTap: () {
                        Get.dialog(
                           OrderUpdateDialogWidget(orderId: order.id ?? 0),
                            barrierDismissible: false,
                          barrierColor: Colors.transparent,
                            );
                         },
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.iconViewColor.withAlpha(40)),
                        padding: EdgeInsets.all(5),
                        child: SvgPicture.asset('assets/svg/edit.svg', height: 19, colorFilter: ColorFilter.mode(AppColor.iconViewColor.withAlpha(200), BlendMode.srcIn))),
                  ) :
                      SizedBox.shrink(),
                  SizedBox(
                    width: 5,
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          // مانده
          DataCell(
            Center(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    order.status==2 ?
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BalanceDateDialog(
                            accountId: order.account?.id ?? 0,
                            accountName: order.account?.name ?? "",
                            initialDate: order.date.toString(),
                            isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),);
                      },
                    )
                        :
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BalanceDialog(
                          entityId: order.id ?? 0,
                          entityType: order.type==0 ? "sell" : "buy",
                          entityName: order.account?.name ?? 'نامشخص',
                          isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 20,
                        color:order.account?.isNegative==true ? AppColor.errorColor : AppColor.buttonColor,
                      ),
                      Text(' مانده',
                        style: AppTextStyle
                            .labelText
                            .copyWith(
                            color:order.account?.isNegative==true ? AppColor.errorColor : AppColor.buttonColor, fontSize: 11,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            )
          ),
          // مانده سکه
          /*DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      order.balances != null ?
                      Column(
                          children: order.balances!.map((e) =>
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 2),
                                    child: e.unitName == "عدد" ? Text(
                                      "${e.balance}", style: e.balance! > 0 ?
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold) :
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.accentColor,
                                        fontWeight: FontWeight.bold),
                                      textDirection: TextDirection.ltr,
                                    ) : SizedBox(),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 2),
                                    child: e.unitName == "عدد" ? Text(
                                      "${e.unitName}", style: e.balance! > 0 ?
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.primaryColor) :
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.accentColor),
                                      textDirection: TextDirection.ltr,
                                    ) : SizedBox(),
                                  ),
                                  Container(
                                    child: e.unitName == "عدد" ? Text(
                                      "${e.itemName}", style: e.balance! > 0 ?
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.primaryColor) :
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.accentColor),
                                      textDirection: TextDirection.ltr,
                                    ) : SizedBox(),
                                  ),
                                ],
                              )).toList()
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
              )
          ),*/
          // مانده ریالی
          /*DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    order.balances != null ?
                    Column(
                      children: order.balances!.map((e) =>
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                child: e.unitName == "ریال" ? Text(
                                  "${e.balance?.toInt().toString().seRagham(
                                      separator: ',')}", style: e.balance! > 0 ?
                                AppTextStyle.bodyText.copyWith(fontSize: 11,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold) :
                                AppTextStyle.bodyText.copyWith(fontSize: 11,
                                    color: AppColor.accentColor,
                                    fontWeight: FontWeight.bold),
                                  textDirection: TextDirection.ltr,
                                ) : SizedBox(),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                child: e.unitName == "ریال" ? Text(
                                  "${e.unitName}", style: e.balance! > 0
                                    ?
                                AppTextStyle.bodyText.copyWith(
                                    fontSize: 11, color: AppColor.primaryColor)
                                    :
                                AppTextStyle.bodyText.copyWith(
                                    fontSize: 11, color: AppColor.accentColor),
                                  textDirection: TextDirection.ltr,
                                ) : SizedBox(),
                              ),
                              Container(
                                child: e.unitName == "ریال" ? Text(
                                  "${e.itemName}", style: e.balance! > 0
                                    ?
                                AppTextStyle.bodyText.copyWith(
                                    fontSize: 11, color: AppColor.primaryColor)
                                    :
                                AppTextStyle.bodyText.copyWith(
                                    fontSize: 11, color: AppColor.accentColor),
                                  textDirection: TextDirection.ltr,
                                ) : SizedBox(),
                              ),
                            ],
                          )).toList(),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),*/
          // مانده طلایی
          /*DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      order.balances != null ?
                      Column(
                          children: order.balances!.map((e) =>
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 2),
                                    child: e.unitName == "گرم" ? Text(
                                      "${e.balance}", style: e.balance! > 0 ?
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold) :
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.accentColor,
                                        fontWeight: FontWeight.bold),
                                      textDirection: TextDirection.ltr,
                                    ) : SizedBox(),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 2),
                                    child: e.unitName == "گرم" ? Text(
                                      "${e.unitName}", style: e.balance! > 0 ?
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.primaryColor) :
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.accentColor),
                                      textDirection: TextDirection.ltr,
                                    ) : SizedBox(),
                                  ),
                                  Container(
                                    child: e.unitName == "گرم" ? Text(
                                      "${e.itemName}", style: e.balance! > 0 ?
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.primaryColor) :
                                    AppTextStyle.bodyText.copyWith(fontSize: 11,
                                        color: AppColor.accentColor),
                                      textDirection: TextDirection.ltr,
                                    ) : SizedBox(),
                                  ),
                                ],
                              )).toList()
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
              )
          ),*/
        ],
      );
    }).toList();
  }
}
