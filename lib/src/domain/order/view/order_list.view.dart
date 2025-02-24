import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:hanigold_admin/src/widget/err_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class OrderListView extends StatelessWidget {
  OrderListView({super.key});

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'سفارشات'),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    //فیلد جستجو
                    Expanded(
                      child: SizedBox(
                        height: 41,
                        child: TextFormField(
                          controller: orderController.searchController,
                          onChanged: orderController.filterOrders,
                          style: AppTextStyle.labelText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                            hintText: "جستجوی سفارش ... ",
                            hintStyle: AppTextStyle.labelText,
                            prefixIcon: SvgPicture.asset(
                              'assets/svg/search.svg',
                              height: 15,
                              width: 15,
                              colorFilter: ColorFilter.mode(
                                  AppColor.textColor, BlendMode.srcIn),
                              fit: BoxFit.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    //دکمه ایجاد سفارش جدید
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 7)),
                          elevation: WidgetStatePropertyAll(5),
                          backgroundColor:
                              WidgetStatePropertyAll(AppColor.buttonColor),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        Get.toNamed('/orderCreate');
                      },
                      child: Text(
                        'ایجاد سفارش جدید',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (orderController.state.value == PageState.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (orderController.state.value == PageState.empty) {
                  return EmptyPage(
                    title: 'سفارشی وجود ندارد',
                    callback: () {
                      orderController.fetchOrderList();
                    },
                  );
                }
                else if (orderController.state.value == PageState.list) {
                  // لیست سفارشات
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, mainAxisExtent: 200),
                      itemCount: orderController.filteredOrders.length,
                      itemBuilder: (context, index) {
                        if (index >= orderController.filteredOrders.length) {
                          return SizedBox();
                        }

                        var orders = orderController.filteredOrders[index];
                        return InkWell(
                          onTap: () {
                            showOrderDetailsSheet(context, orders);
                          },
                          child: Card(
                            margin: EdgeInsets.fromLTRB(8, 5, 8, 10),
                            color: AppColor.secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 15, bottom: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // تاریخ سفارش
                                  funcOrderDetail(
                                      'assets/svg/date.svg',
                                      '',
                                      orders.date?.toPersianDate(
                                              twoDigits: true,
                                              showTime: true,
                                              timeSeprator: '-') ??
                                          "نامشخص"),
                                  Divider(
                                    color: AppColor.backGroundColor,
                                    height: 2,
                                  ),
                                  // نام کاربر
                                  funcOrderDetail(
                                      'assets/svg/user.svg',
                                      'نام کاربر:',
                                      orders.account?.name ?? "نامشخص"),
                                  // محصول
                                  funcOrderDetail('assets/svg/product.svg',
                                      'محصول:', orders.item?.name ?? "نامشخص"),
                                  //مقدار سفارش
                                  funcOrderDetail(
                                      'assets/svg/amount.svg',
                                      'مقدار سفارش:',
                                      "${orders.amount?.toString() ?? "0"} ${orders.item?.itemUnit?.name ?? ""}"),
                                  //قیمت سفارش
                                  funcOrderDetail(
                                    'assets/svg/amount-price.svg',
                                    'قیمت سفارش:',
                                    (orders.price != null)
                                        ? "${orders.price.toString().seRagham(separator: ',')} ریال"
                                        : "0",
                                  ),
                                  //مبلغ کل
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/total-price.svg',
                                            colorFilter: ColorFilter.mode(
                                                AppColor.textFieldColor,
                                                BlendMode.srcIn),
                                            width: 18,
                                            height: 18,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'مبلغ کل: ',
                                            style: AppTextStyle.bodyText,
                                          ),
                                          Text(
                                            (orders.totalPrice != null)
                                                ? "${orders.totalPrice.toString().seRagham(separator: ',')} ریال"
                                                : "0",
                                            style: AppTextStyle.bodyText,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            height: 20,
                                            child: Card(
                                              color: (orders.type == 0)
                                                  ? AppColor.accentColor
                                                  : AppColor.primaryColor,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 5),
                                              child: Text(
                                                  (orders.type == 0)
                                                      ? 'فروش'
                                                      : 'خرید',
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.textColor),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return ErrPage(
                  callback: () {
                    orderController.fetchOrderList();
                  },
                  title: "خطا در دریافت سفارشات",
                  des: 'برای دریافت سفارشات مجددا تلاش کنید',
                );
              }),
            ],
          ),
        ),
      )),
    );
  }

// ButtonSheet جزئیات سفارش
  void showOrderDetailsSheet(BuildContext context, OrderModel orders) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.backGroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Card(
            margin: EdgeInsets.all(5),
            color: AppColor.backGroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 15,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'جزئیات سفارش',
                        style: AppTextStyle.smallTitleText,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                        style: ButtonStyle(
                          iconColor: WidgetStatePropertyAll(AppColor.textColor),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    funcOrderDetail(
                        '',
                        'تاریخ سفارش:',
                        orders.date?.toPersianDate(
                                twoDigits: true,
                                showTime: true,
                                timeSeprator: '-') ??
                            "نامشخص"),
                    funcOrderDetail(
                        '', 'نام کاربر:', orders.account?.name ?? "نامشخص"),
                    funcOrderDetail(
                        '', 'محصول:', orders.item?.name ?? "نامشخص"),
                    funcOrderDetail('', 'مقدار سفارش:',
                        "${orders.amount?.toString() ?? "0"} ${orders.item?.itemUnit?.name ?? ""}"),
                    funcOrderDetail(
                      '',
                      'قیمت سفارش:',
                      (orders.price != null)
                          ? "${orders.price.toString().seRagham(separator: ',')} ریال"
                          : "0",
                    ),
                    funcOrderDetail(
                      '',
                      'مبلغ کل:',
                      (orders.totalPrice != null)
                          ? "${orders.totalPrice.toString().seRagham(separator: ',')} ریال"
                          : "0",
                    ),
                    funcOrderDetail('', 'شماره تماس:',
                        "${orders.account?.contactInfo ?? "0"} "),
                    orders.checked == true
                        ? funcOrderDetail('', 'وضعیت:', "تایید شده",
                            color: AppColor.primaryColor)
                        : funcOrderDetail('', 'وضعیت:', "تایید نشده",
                            color: AppColor.accentColor),
                  ],
                ),
                Spacer(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //دکمه ادیت جزئیات سفارش
                      OutlinedButton(
                        onPressed: () {
                          orderController.setOrderDetails(orders);
                          Get.toNamed('/orderCreate');
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/edit.svg',
                          colorFilter: ColorFilter.mode(
                              AppColor.textColor, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //دکمه تایید سفارش در جزئیات
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "تایید سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleText: "آیا از تایید سفارش مطمئن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    Get.snackbar('تایید', 'سفارش تایید شد');
                                  },
                                  child: Text(
                                    'تایید',
                                    style: AppTextStyle.bodyText,
                                  )));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColor.primaryColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                        child: Text(
                          'تایید',
                          style: AppTextStyle.bodyText,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //دکمه رد سفارش در جزئیات
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "رد سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleTextStyle: AppTextStyle.bodyText,
                              middleText: "آیا از رد سفارش مطمئن هستید؟",
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.accentColor)),
                                  onPressed: () {
                                    Get.back();
                                    Get.snackbar('رد', 'سفارش رد شد');
                                  },
                                  child: Text(
                                    'رد',
                                    style: AppTextStyle.bodyText,
                                  )));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColor.accentColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                        child: Text(
                          'رد',
                          style: AppTextStyle.bodyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//
  Widget funcOrderDetail(String iconPath, String label, String value,
      {Color color = AppColor.textColor}) {
    return Row(
      children: [
        SvgPicture.asset(iconPath,
            width: 18,
            height: 18,
            colorFilter:
                ColorFilter.mode(AppColor.textFieldColor, BlendMode.srcIn)),
        SizedBox(width: 10),
        Text(label, style: AppTextStyle.bodyText),
        SizedBox(width: 7),
        Expanded(
            child: Text(value,
                style: AppTextStyle.bodyText.copyWith(color: color))),
      ],
    );
  }
}
